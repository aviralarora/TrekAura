//
//  SplashScreen.swift
//  TrekAura
//
//  Created by Aviral Arora on 08/09/23.
//

import Foundation
import SwiftUI
import Lottie

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Image("home")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            Spacer()
            Text("TrekAura")
                .font(.largeTitle)
                .foregroundColor(.white)
                .font(.system(size: 60))
                .bold()
                .padding(.bottom,60)
        }
        .onAppear {
            // Add any initialization code or delays you need for your splash screen.
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                // After a delay (e.g., 2 seconds), navigate to the main content view.
                // You can use NavigationLink or a custom transition here.
            }
        }
    }
}

struct splash_Previews: PreviewProvider {
    static var previews: some View {
       SplashScreen()
    }
}
