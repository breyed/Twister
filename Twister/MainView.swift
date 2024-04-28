import AVFoundation
import SwiftUI

struct MainView: View {
	@EnvironmentObject private var model: Model
	@State private var isSettingsViewPresented = false

	var body: some View {
		NavigationStack {
			SpinnerView()
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						Button("New Game") { withAnimation { model.resetGame() } }
					}
					ToolbarItem(placement: .navigationBarTrailing) {
						withSettingsSheetOrPopover(Button("Settings") { isSettingsViewPresented = true })
					}
				}
		}
	}

	/// Displays settings in a popover on a pad or in a sheet on a phone.
	@ViewBuilder private func withSettingsSheetOrPopover<V: View>(_ content: V) -> some View {
		if UIDevice.current.userInterfaceIdiom == .pad {
			content.popover(isPresented: $isSettingsViewPresented) {
				SettingsView()
					.frame(width: 400, height: 390) // Height leaves room for conditional "Every x seconds" line.
				// Tried .presentationCompactAdaptation(.popover) here with .scrollDisabled(true) on the Form, but that caused the popover height to be too small.
			}
		} else {
			content.sheet(isPresented: $isSettingsViewPresented) {
				NavigationStack {
					SettingsView()
						.navigationTitle("Settings").navigationBarTitleDisplayMode(.inline)
						.toolbar { Button("Done") { isSettingsViewPresented = false } }
				}
			}
		}
	}
}

struct MainView_Previews: PreviewProvider {
	static var previews: some View {
		MainView().environmentObject(Model())
	}
}
