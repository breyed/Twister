import SwiftUI

struct SettingsView: View {
	@EnvironmentObject private var model: Model

	var body: some View {
		Form {
			Section("Timer") {
				Toggle(isOn: $model.autoSpin.animation()) { Text("Spin automatically") }
				if (model.autoSpin) {
					Stepper("Every \(model.autoSpinSeconds) seconds", value: $model.autoSpinSeconds, in: 1...30, step: 1) {_ in}
				}
			}

			Section("Speech") {
				Toggle(isOn: $model.randomVoices) { Text("Random voices") }
				
				Toggle(isOn: $model.randomRatesAndPitches) { Text("Random rates and pitches") }
				
				Toggle(isOn: $model.sillySayings) { Text("Silly sayings") }
			}
			
			// When changing settings, remember to adjust the popover size in MainView.
		}
		.onDisappear{ try? UserDefaults.standard.set(PropertyListEncoder().encode(model), forKey: "Model") }
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView().environmentObject(Model())
	}
}
