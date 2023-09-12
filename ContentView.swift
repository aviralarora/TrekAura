import SwiftUI

struct ContentView: View {
    @State private var isAnimatingText = true
    @State private var showSplashScreen = true // Add this state variable
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    var body: some View {
        NavigationView {
            ZStack {
                if showSplashScreen {
                    // Show the splash screen
                    SplashScreen()
                        .onAppear {
                            // Add any additional logic or delays here if needed
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showSplashScreen = false // Hide the splash screen
                            }
                        }
                } else {
                    Image("home") // Set the background image
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Spacer()
                        
                        // Welcome text
                        CurvedBoxView(text: "Welcome to TrekAura, how can I help you?", isAnimatingText: $isAnimatingText)
                            .padding(.horizontal, 20)
                            .padding(.vertical, verticalSizeClass == .regular ? 20 : 10) // Adjust vertical spacing based on size class
                        
                        Spacer()
                        
                        // Register button
                        NavigationLink(destination: RegisterView().navigationBarBackButtonHidden(true)) {
                            Text("Register")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: verticalSizeClass == .regular ? 60 : 50) // Adjust button height based on size class
                                .background(Color.blue.opacity(0.8))
                                .cornerRadius(10)
                                .padding(.horizontal, 20)
                        }
                        
                        // Login button
                        NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
                            Text("Login")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: verticalSizeClass == .regular ? 60 : 50) // Adjust button height based on size class
                                .background(Color.blue.opacity(0.8))
                                .cornerRadius(10)
                                .padding(.horizontal, 20)
                        }
                        
                        Spacer()
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct RegisterView: View {
    var body: some View {
        Text("Register Page")
    }
}

struct LoginView: View {
    var body: some View {
        Text("Login Page")
    }
}

struct CurvedBoxView: View {
    let text: String
    @Binding var isAnimatingText: Bool // Use a binding to control animation state
    @State private var animatedText = ""
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color.blue.opacity(0.8))
                .frame(height: 100)
            Text(animatedText)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .onAppear {
                    if isAnimatingText {
                        animateText()
                    }
                }
        }
    }
    private func animateText() {
           for (index, character) in text.enumerated() {
               DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                   animatedText += String(character)
                   if index == text.count - 1 {
                       isAnimatingText = false
                   }
               }
           }
       }
   }

    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


