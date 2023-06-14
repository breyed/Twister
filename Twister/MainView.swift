import SwiftUI

struct MainView: View {
	@State private var isSettingsViewPresented = false
	
	var body: some View {
		NavigationStack {
			SpinnerView()
				.toolbar {
					withSettingsSheetOrPopover(Button(action: { isSettingsViewPresented = true}) {
						Image(systemName: "gear")
					})
				}
		}
	}

	/// Displays settings in a popover on a pad or in a sheet on a phone.
	@ViewBuilder private func withSettingsSheetOrPopover<V: View>(_ content: V) -> some View {
		if UIDevice.current.userInterfaceIdiom == .pad {
			content.popover(isPresented: $isSettingsViewPresented) {
				SettingsView()
					.frame(width: 400, height: 300) // Height leaves room for conditional "Every x seconds" line.
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
