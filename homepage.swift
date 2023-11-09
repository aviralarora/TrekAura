import SwiftUI

struct Destination: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let link: String
}

struct homepage: View {
    @State private var searchText = ""
    @State private var destinations: [Destination] = [
        Destination(name: "map", imageName: "maps", link: "map_view"),
        Destination(name: "mountain", imageName: "Image", link: "mountain"),
        Destination(name: "weather", imageName: "weather", link: "weather_view"),
        Destination(name: "accommodation", imageName: "accomodation", link: "accommodation"),
        Destination(name: "adventure", imageName: "adventure", link: "adventure"),
        Destination(name: "medical_assistance", imageName: "hospital", link: "medical")
    ]
    
    @State private var isProfileViewPresented = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .topTrailing) {
                Image("mountain")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                        TextField("", text: $searchText, prompt: Text("Search").foregroundColor(.white))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    ScrollView {
                        Spacer()
                        Spacer()
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 20)], spacing: 20) {
                            ForEach(destinations.filter { searchText.isEmpty ? true : $0.name.lowercased().contains(searchText.lowercased()) }) { destination in
                                NavigationLink(destination: getDetailViewBasedOnLink(destination: destination)) {
                                    VStack {
                                        Image(destination.imageName)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 150, height: 150)
                                            .cornerRadius(10)
                                        
                                        Text(destination.name)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }
                                }
                                .tag(destination.link) // Use the link property as the tag
                            }
                        }
                        .padding()
                    }
                }
                .navigationBarHidden(true)
                
                Button(action: {
                    isProfileViewPresented.toggle()
                }) {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                        .foregroundColor(.white)
                        .padding(.trailing, 20)
                        .padding(.top, 20)
                }
                .sheet(isPresented: $isProfileViewPresented) {
                    // Add your profile view here
                    ProfileView()
                }
            }
        }
    }
    
    private func getDetailViewBasedOnLink(destination: Destination) -> AnyView {
        switch destination.link {
        case "map_view":
            return AnyView(map_view()) // Replace with your actual MapsDetailView
        case "weather_view":
            return AnyView(weather_view())
        case "adventure":
            return AnyView(adventure())
        case "medical":
            return AnyView(medical())
        case "mountain":
            return AnyView(mountain())
            
        default:
            return AnyView(Text("Default Detail View"))
        }
    }
}

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.black)
                .padding(.top, 20)

            Text("Full Name") // Replace with the user's name
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top, 20)

            Text("email@example.com") // Replace with the user's email
                .font(.headline)
                .foregroundColor(.black)
                .padding(.top, 10)

            Spacer()

            Button(action: {
                // Add your sign-out logic here
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Sign Out")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 2))
            }
            .padding(.bottom, 20)
        }
        .padding()
    }
}


struct Homepage_Previews: PreviewProvider {
    static var previews: some View {
        homepage()
    }
}

