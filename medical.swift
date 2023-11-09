import SwiftUI
import Foundation

struct medical: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    SectionCard(title: "Emergency Numbers") {
                        EmergencyNumbersSection()
                    }
                    
                    SectionCard(title: "First Aid Tips") {
                        FirstAidTipsSection()
                    }
                    
                    SectionCard(title: "Snake Bite") {
                        SnakeBiteSection()
                    }
                    
                    SectionCard(title: "Heatstroke") {
                        HeatstrokeSection()
                    }
                    
                    SectionCard(title: "Insect Bites") {
                        InsectBitesSection()
                    }
                }
                .padding()
            }
            .navigationBarTitle("Medical Assistance")
            .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.green.opacity(0.3)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .edgesIgnoringSafeArea(.all)
                                        )
        }
    }
}

struct SectionCard<Content: View>: View {
    let title: String
    let content: () -> Content
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(radius: 5)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding([.top, .horizontal])
                
                content()
                    .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
}

struct EmergencyNumbersSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            EmergencyNumberRow(number: "108", description: "Medical Emergency hotline")
            EmergencyNumberRow(number: "100", description: "Police")
            EmergencyNumberRow(number: "101", description: "Fire Department")
        }
    }
}

struct FirstAidTipsSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            FirstAidTipRow(tip: "Apply pressure to stop bleeding.")
            FirstAidTipRow(tip: "Keep the injured area elevated.")
            FirstAidTipRow(tip:"If someone has a suspected bone fracture, stabilize the injured area by applying a splint or immobilizing the limb to prevent further damage.")
            FirstAidTipRow(tip:"If the person is not breathing or their heartbeat has stopped, begin CPR immediately.")
        }
    }
}

struct SnakeBiteSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            FirstAidTipRow(tip: "Keep the bite area below the heart.")
            FirstAidTipRow(tip: "Clean the bite area with soap and water.")
            FirstAidTipRow(tip: "Do not apply ice or a tourniquet.")
            FirstAidTipRow(tip: "Keep the person still and calm.")
            FirstAidTipRow(tip: "Seek medical attention immediately.")
        }
    }
}

struct HeatstrokeSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            FirstAidTipRow(tip: "Move to a cooler place.")
            FirstAidTipRow(tip: "Drink water and take cool showers.")
            FirstAidTipRow(tip: "Apply cool, wet cloths to the body.")
            FirstAidTipRow(tip: "Fan the person to increase cooling.")
            FirstAidTipRow(tip: "Do not give fluids containing caffeine or alcohol.")
        }
    }
}

struct InsectBitesSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            FirstAidTipRow(tip: "Clean the bite area with antiseptic.")
            FirstAidTipRow(tip: "Apply ice to reduce swelling.")
            FirstAidTipRow(tip: "Avoid scratching to prevent infection.")
            FirstAidTipRow(tip: "Use over-the-counter creams for itch relief.")
            FirstAidTipRow(tip: "If allergic reactions occur, seek medical help.")
        }
    }
}


struct EmergencyNumberRow: View {
    let number: String
    let description: String
    
    var body: some View {
        HStack {
            Image(systemName: "phone.fill")
                .foregroundColor(.green)
                .font(.title)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(number)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
            }
        }
        .padding(.vertical, 8)
    }
}

struct FirstAidTipRow: View {
    let tip: String
    
    var body: some View {
        HStack {
            Image(systemName: "staroflife.fill")
                .foregroundColor(.red)
                .font(.title)
                .frame(width: 30)
            
            Text(tip)
                .font(Font.system(size: 14)) // Specify the font type explicitly
        }
        .padding(.vertical, 8)
    }
}

struct medical_Previews: PreviewProvider {
    static var previews: some View {
        medical()
    }
}


