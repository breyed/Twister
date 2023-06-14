import AVFoundation
import SwiftUI

struct Spinner: View {
	let speechSynthesizer: AVSpeechSynthesizer
	@State var color = Color.gray
	@State var member = "Twister Spinner"

	var body: some View {
		VStack {
			Text(member)
				.font(.largeTitle)
				.bold()

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

		// Show next move.
		withAnimation {
			color = colors.randomElement()!
			member = members.randomElement()!
		}
		
		// Say next move.
		let utterance = AVSpeechUtterance(string: member + " " + color.description)
		utterance.rate = 0.4
		utterance.voice = makeVoice()
		speechSynthesizer.stopSpeaking(at: .word)
		speechSynthesizer.speak(utterance)
	}
}

private func makeVoice() -> AVSpeechSynthesisVoice? {
	let language = Locale.current.language
	guard language.languageCode?.identifier == "en", language.region == "US" else { return nil }
	return AVSpeechSynthesisVoice(language: "en-GB")
}

struct Spinner_Previews: PreviewProvider {
	static var previews: some View {
		Spinner(speechSynthesizer: AVSpeechSynthesizer())
	}
}
