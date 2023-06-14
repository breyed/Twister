import SwiftUI

struct MainView: View {
	@State private var isSettingsViewPresented = false

	var body: some View {
		NavigationStack {
			SpinnerView()
				.toolbar {
					Button(action: { isSettingsViewPresented = true}) {
						Image(systemName: "gear")
					}
				}
				.sheet(isPresented: $isSettingsViewPresented) {
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
