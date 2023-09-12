//
//  Login.swift
//  TrekAura
//
//  Created by Aviral Arora on 22/08/23.
//

import Foundation
import SwiftUI

struct Login: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            Image("login") // Replace with your background image
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Text("Login")
                    .offset(y:-50)
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.8), radius: 5, x: 0, y: 5)
                    .padding(.bottom, 20)
                
                VStack(alignment: .leading) {
                    Text("Email")
                        .font(.headline)
                        .foregroundColor(.white)
                    TextField("Enter your email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(30)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    Text("Password")
                        .font(.headline)
                        .foregroundColor(.white)
                    SecureField("Enter your password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(30)
                        .padding(.bottom,30)
                }
                .padding(.horizontal)
    
                NavigationLink(destination: homepage().navigationBarBackButtonHidden(true)) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

