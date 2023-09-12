import SwiftUI

// Enum to represent the time of day
enum TimeOfDay {
    case morning, afternoon, evening, night
}

struct weather_view: View {
    @StateObject private var weatherViewModel = WeatherViewModel()
    @State private var searchCity = ""
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.black]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Text("Weather in \(weatherViewModel.cityName)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 30)
                
                Text(weatherViewModel.currentDate)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                
                WeatherAnimationView(condition: weatherViewModel.weather?.condition ?? "")
                    .font(.system(size: 150))
                    .foregroundColor(.white)
                
                Text("\(weatherViewModel.weather?.temperature ?? 0)°")
                    .font(.system(size: 70, weight: .light))
                    .foregroundColor(.white)
                
                // Cute text with fade-up animation
                CuteText(text: weatherViewModel.cuteText, animationState: $weatherViewModel.cuteTextAnimation)
                    .font(.headline)
                    .foregroundColor(.white)
                    .opacity(weatherViewModel.cuteTextOpacity)
                
                Divider()
                    .background(Color.white)
                    .padding(.horizontal)
                
                Text("Today")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical)
                
                HStack {
                    ForEach(weatherViewModel.hourlyWeather, id: \.self) { hourlyWeather in
                        WeatherHourlyView(hourlyWeather: hourlyWeather)
                    }
                }
                .onAppear {
                    weatherViewModel.fetchWeather()
                }
                
                VStack {
                    HStack {
                        TextField("Search City", text: $searchCity, onCommit: {
                            weatherViewModel.cityName = searchCity
                            weatherViewModel.fetchWeather()
                            searchCity = ""
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        
                        Button(action: {
                            weatherViewModel.cityName = searchCity
                            weatherViewModel.fetchWeather()
                            searchCity = ""
                        }) {
                            Text("Search Weather")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: 400) // Set a maximum width for the VStack
                    .modifier(KeyboardAwareModifier()) // Apply the modifier here
                }
            }
            .padding()
        }
    }
}

// A cute text with a fade-up animation
struct CuteText: View {
    let text: String
    @Binding var animationState: WeatherViewModel.AnimationState
    var animationDuration: Double = 2.0
    
    var body: some View {
        Text(text)
            .opacity(animationState == .show ? 1.0 : 0.0)
            .animation(.easeInOut(duration: animationDuration))
            .onAppear {
                withAnimation {
                    animationState = .show
                }
            }
    }
}

struct WeatherHourlyView: View {
    let hourlyWeather: HourlyWeather
    
    var body: some View {
        VStack {
            Text(hourlyWeather.time)
                .font(.system(size: 12))
                .foregroundColor(.white)
                .padding(.bottom, 5)
            
            WeatherAnimationView(condition: hourlyWeather.condition)
                .font(.system(size: 30))
                .foregroundColor(.white)
            
            Text("\(hourlyWeather.temperature)°")
                .font(.system(size: 16))
                .foregroundColor(.white)
        }
    }
}

struct WeatherAnimationView: View {
    let condition: String
    
    var body: some View {
        Image(systemName: conditionToImageName(condition))
            .font(.system(size: 100))
            .foregroundColor(.white)
    }
    
    private func conditionToImageName(_ condition: String) -> String {
        switch condition {
        case "Clear":
            return "sun.max.fill"
        case "Clouds":
            return "cloud.fill"
        case "Rain":
            return "cloud.rain.fill"
        case "Snow":
            return "cloud.rain.fill"
        default:
            return "sun.max.fill"
        }
    }
}

struct Weather {
    let temperature: Int
    let condition: String
}

struct HourlyWeather: Hashable {
    let time: String
    let temperature: Int
    let condition: String
}

class WeatherViewModel: ObservableObject {
    enum AnimationState {
        case hide
        case show
    }
    
    @Published var cityName: String = "Bangalore"
    @Published var weather: Weather?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var cuteText = ""
    @Published var cuteTextOpacity = 0.0
    @Published var cuteTextAnimation: AnimationState = .hide

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter
    }()

    var currentDate: String {
        return dateFormatter.string(from: Date())
    }

    var hourlyWeather: [HourlyWeather] = []

    func fetchWeather() {
        isLoading = true
        errorMessage = nil

        // Replace "YOUR_API_KEY" with your actual API key
        let apiKey = "c834bc71becd4d76c16ed98927883dd0"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKey)&units=metric"

        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                DispatchQueue.main.async {
                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            let weatherData = try decoder.decode(WeatherData.self, from: data)
                            self.weather = Weather(temperature: Int(weatherData.main.temp),
                                                  condition: weatherData.weather.first?.main ?? "Unknown")
                            self.isLoading = false

                            // Simulate hourly weather data
                            let conditions = ["Clear", "Clouds", "Rain", "Snow"]
                            self.hourlyWeather = (0..<8).map { index in
                                let time = Calendar.current.date(byAdding: .hour, value: index, to: Date())!
                                let temperature = Int.random(in: 10...30)
                                let condition = conditions.randomElement() ?? "Unknown"
                                return HourlyWeather(time: self.hourFormatter.string(from: time),
                                                     temperature: temperature,
                                                     condition: condition)
                            }
                            
                            // Set cute text based on the condition
                            self.setCuteText()
                        } catch {
                            self.errorMessage = "Failed to fetch weather"
                        }
                    } else if let error = error {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }.resume()
        }
    }

    let hourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        return formatter
    }()

    // Set the cute text based on the weather condition
    private func setCuteText() {
        if let condition = weather?.condition {
            switch condition {
            case "Clear":
                cuteText = "Hey! It's sunny today ☀️"
            case "Clouds":
                cuteText = "It's cloudy today ☁️"
            case "Rain":
                cuteText = "Don't forget your umbrella! 🌧️"
            case "Snow":
                cuteText = "Let it snow! ❄️"
            default:
                cuteText = "Weather is \(condition)"
            }
            
            // Fade in the cute text
            withAnimation {
                cuteTextOpacity = 1.0
            }
        }
    }
}

struct WeatherData: Decodable {
    let main: WeatherMain
    let weather: [WeatherDescription]
}

struct WeatherMain: Decodable {
    let temp: Double
}

struct WeatherDescription: Decodable {
    let main: String
}

struct weather_view_Previews: PreviewProvider {
    static var previews: some View {
        weather_view()
    }
}

// Keyboard-aware modifier to adjust the view when the keyboard appears
struct KeyboardAwareModifier: ViewModifier {
    @State private var currentHeight: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .padding(.bottom, currentHeight)
            .onAppear(perform: subscribeToKeyboardEvents)
            .onDisappear(perform: unsubscribeFromKeyboardEvents)
    }

    private func subscribeToKeyboardEvents() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { notification in
            if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                currentHeight = keyboardSize.height
            }
        }

        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { _ in
            currentHeight = 0
        }
    }

    private func unsubscribeFromKeyboardEvents() {
        NotificationCenter.default.removeObserver(self)
    }
}

