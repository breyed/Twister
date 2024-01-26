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
			model.member = ["Left foot", "Right foot", "Left hand", "Right hand"].randomElement()!
			model.color = [Color.red, Color.blue, Color.yellow, Color.green].randomElement()!
			model.colorName = model.color.description

			if model.goofyColors {
				makeColorGoofy()
			}
						
			model.spins += 1
		}

		// Speak the next move.
		var action = model.member + " " + model.colorName
		if model.sillySayings, let sillySaying = sillySaying(action: action) {
			action += ". " + sillySaying
		}
		model.speak(action)
		
		// Spin again if autospinning.
		autoSpinTask?.cancel()
		if model.autoSpin {
			autoSpinTask = Task {
				try await Task.sleep(until: .now + .seconds(model.autoSpinSeconds), clock: .continuous)
				if model.autoSpin { spin() }
			}
		}
	}
	
	private func makeColorGoofy() {
		if model.member == "Right hand" && model.color == .blue {
			model.color = .teal
			model.colorName = Color.teal.description
		}
		if model.member == "Right hand" && model.color == .green {
			model.color = Color("pickle")
			model.colorName = "pickle"
		}
		if model.member == "Left foot" && model.color == .green {
			model.color = Color("broccoli")
			model.colorName = "broccoli"
		}
		if model.member == "Right foot" && model.color == .green {
			model.color = Color("pea")
			model.colorName = "pea pod"
		}
		if model.member == "Left hand" && model.color == .red {
			model.color = Color("tomato")
			model.colorName = "tomato"
		}
		if model.member == "Right hand" && model.color == .red {
			model.color = Color("cherry")
			model.colorName = "cherry"
		}
	}
	
	private func sillySaying(action: String) -> String? {
		switch (action) {
		case "Right hand blue": return "By the way, Happy Birthday River!"
		case "Left hand red": return "What do you call a fish with no eyes?  A fsh."
		case "Left foot yellow": return "Ghivvle gavvle."
		case "Right hand green": return "Why do ducks have feathers? To cover their butt quack."
		case "Right hand red": return "Knock knock. Who's there? Boo. Boo who? Don't cry. It's just a joke."
		case "Left foot green": return "By the way, you're awesomly bad at twister!"
		default: return nil
		}
	}
}

struct SpinnerView_Previews: PreviewProvider {
	static var previews: some View {
		SpinnerView().environmentObject(Model())
	}
}
