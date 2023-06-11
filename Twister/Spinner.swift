import SwiftUI
import AVFoundation

struct Spinner: View {
    let synthesizer = AVSpeechSynthesizer()
    @State var color = Color.red
    @State var member = "Left foot"

    var body: some View {
        VStack {
            Text(member)
                .font(.largeTitle).bold()

            Circle()
                .frame(width: 140)
                .padding(.top, 30)
                .padding(.bottom, 100)
                .foregroundColor(color)

            Button(action: spin) {
                HStack {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .imageScale(.large)
                    Text("Spin")
                        .font(.title)
                }
            }
        }
    }

    private func spin() {
        let colors = [Color.red, Color.blue, Color.yellow, Color.green]
        let members = ["Left foot", "Right foot", "Left hand", "Right hand"]
        let countries = ["AU", "GB", "IE", "IN", "US"]

        // Show next move.
        withAnimation {
            color = colors.randomElement()!
            member = members.randomElement()!
        }
        
        // Say next move.
        let utterance = AVSpeechUtterance(string: member + " " + color.description)
        utterance.rate = Float.random(in: 0.2 ..< 0.8)
        utterance.pitchMultiplier = Float.random(in: 0.5 ..< 1.5)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-" + countries.randomElement()!)
        synthesizer.speak(utterance)
    }
}

struct Spinner_Previews: PreviewProvider {
    static var previews: some View {
        Spinner()
    }
}
