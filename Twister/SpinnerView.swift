import AVFoundation
import SwiftUI

struct SpinnerView: View {
	@EnvironmentObject private var model: Model
	@State private var autoSpinTask: Task<(), Error>?

	var body: some View {
		VStack(spacing: 30) {
			Text("Spin \(model.spins)")
				.font(.title2)
				.foregroundColor(.gray)
				.opacity(model.spins == 0 ? 0 : 1)
			
			Text(model.member)
				.font(.largeTitle)
				.bold()

			Circle()
				.foregroundColor(model.color)
				.frame(width: 140)
				.padding(.bottom, 40)

			Button(action: spin) {
				HStack {
					Image(systemName: "arrow.triangle.2.circlepath")
						.imageScale(.large)
					Text("Spin")
						.font(.title)
				}
			}

			if let voice = model.voice {
				HStack {
					Image(systemName: "bubble.left")
					Text("\(voice.name) – \(Locale.current.localizedString(forIdentifier: voice.language) ?? voice.language)")
				}
				.foregroundColor(.gray)
			}
		}
	}

	private func spin() {
		// Show the next move.
		withAnimation {
			model.member = [ "Left foot", "Right foot", "Left hand", "Right hand"].randomElement()!

			model.color = [Color.red, Color.blue, Color.yellow, Color.green].randomElement()!
			if model.color == .blue && model.member == "Right hand" && model.goofyColors {
				model.color = .teal
			}
						
			model.spins += 1
		}

		// Speak the next move.
		var speech = model.member + " " + model.color.description
		if model.sillySayings {
			let goofyText = getGoofyText(startingText: speech)
			if goofyText != "" {
				speech += ". " + goofyText
			}
		}
		model.speak(speech)
		
		// Spin again if autospinning.
		autoSpinTask?.cancel()
		if model.autoSpin {
			autoSpinTask = Task {
				try await Task.sleep(until: .now + .seconds(model.autoSpinSeconds), clock: .continuous)
				if model.autoSpin { spin() }
			}
		}
	}
	
	private func getGoofyText(startingText: String) -> String {
		if startingText == "Right hand blue" {
			return "By the way, Happy Birthday River!"
		}
		if startingText == "Left hand red" {
			return "What do you call a fish with no eyes?  A fsh."
		}
		if startingText == "Left foot yellow" {
			return "Ghivvle gavvle."
		}
		if startingText == "Right hand green" {
			return "Why do ducks have feathers? To cover their butt quack."
		}
		if startingText == "Right hand red" {
			return "Knock knock. Who's there? Boo. Boo who? Don't cry. It's just a joke."
		}
		if startingText == "Left foot green" {
			return "By the way, you're awesomly bad at twister!"
		}
		return ""
	}
}

struct SpinnerView_Previews: PreviewProvider {
	static var previews: some View {
		SpinnerView().environmentObject(Model())
	}
}
