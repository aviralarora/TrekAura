
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var presentationMode: PresentationMode
        @Binding var image: UIImage?
        
        init(presentationMode: Binding<PresentationMode>, image: Binding<UIImage?>) {
            _presentationMode = presentationMode
            _image = image
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                image = uiImage
            }
            presentationMode.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, image: $image)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        // Nothing to do here
    }
}

struct Main: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var fullName = ""
    @State private var profileImage: UIImage? = nil
    @State private var showingImagePicker = false
    @State private var inputAlert = false
    @State private var inputAlertMessage = ""
    
    // Validation states for input fields
    @State private var isFullNameValid = false
    @State private var isEmailValid = false
    @State private var isPasswordValid = false
    @State private var isConfirmPasswordValid = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("register") // Replace with your background image
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Profile Registration")
                        .fontWeight(.bold)
                        .padding(.top,30)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.8), radius: 5, x: 0, y: 5)
                        .padding(.bottom, 90)
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Full Name")
                            .font(.headline)
                            .foregroundColor(.white)
                        TextField("Enter your full name", text: $fullName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(30)
                            .onChange(of: fullName) { newValue in
                                isFullNameValid = isValidFullName(newValue)
                                validateInput()
                            }
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        Text("Email")
                            .font(.headline)
                            .foregroundColor(.white)
                        TextField("Enter your email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(30)
                            .keyboardType(.emailAddress)
                            .onChange(of: email) { newValue in
                                isEmailValid = isValidEmail(newValue)
                                validateInput()
                            }
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        Text("Password")
                            .font(.headline)
                            .foregroundColor(.white)
                        SecureField("Enter your password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(30)
                            .onChange(of: password) { newValue in
                                isPasswordValid = isValidPassword(newValue)
                                validateInput()
                            }
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        Text("Confirm Password")
                            .font(.headline)
                            .foregroundColor(.white)
                        SecureField("Confirm your password", text: $confirmPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(30)
                            .onChange(of: confirmPassword) { newValue in
                                isConfirmPasswordValid = isValidConfirmPassword(newValue)
                                validateInput()
                            }
                    }
                    .padding()
                    
                    // Display error message if any
                    Text(inputAlertMessage)
                        .foregroundColor(.red)
                        .padding()
                    
                    NavigationLink(destination: homepage().navigationBarBackButtonHidden(true)) {
                        Text("Register")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .disabled(!isInputValid)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding()
                VStack{
                    if profileImage != nil {
                        Image(uiImage: profileImage!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .offset(y: -230)
                            .onTapGesture {
                                showingImagePicker.toggle()
                            }
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.white)
                            .offset(y: -230)
                            .onTapGesture {
                                showingImagePicker.toggle()
                            }
                    }
                }
                    
                        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                            ImagePicker(image: $profileImage)
                        }
                        .alert(isPresented: $inputAlert) {
                            Alert(
                                title: Text("Input Error"),
                                message: Text(inputAlertMessage),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                }
            }
        }
    
    // Validation functions
    private func isValidFullName(_ fullName: String) -> Bool {
        // Implement your full name validation logic here
        return !fullName.isEmpty
    }

    private func isValidEmail(_ email: String) -> Bool {
        // Implement your email validation logic here
        return !email.isEmpty && email.isValidEmail() // You can create an extension for email validation
    }

    private func isValidPassword(_ password: String) -> Bool {
        // Implement your password validation logic here (e.g., minimum length)
        return password.count >= 6
    }

    private func isValidConfirmPassword(_ confirmPassword: String) -> Bool {
        // Implement your confirm password validation logic here (e.g., matching with password)
        return confirmPassword == password
    }

    // Combine all validation checks
    private var isInputValid: Bool {
        return isFullNameValid && isEmailValid && isPasswordValid && isConfirmPasswordValid
    }

    // Validate input when any field changes
    private func validateInput() {
        // Display a common error message or handle validation feedback here
        if !isInputValid {
            inputAlertMessage = "Please fill in all fields correctly."
        } else {
            inputAlertMessage = ""
        }
    }

    func loadImage() {
        guard let selectedImage = profileImage else { return }
        // Handle the selected image (e.g., display it, upload it, etc.)
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}

