import SwiftUI

@main
struct TwisterApp: App {
	@StateObject private var model = (try? PropertyListDecoder().decode(Model.self, from: UserDefaults.standard.data(forKey: "Model") ?? .init())) ?? Model()
	@Environment(\.scenePhase) private var scenePhase

	var body: some Scene {
		WindowGroup {
			MainView().environmentObject(model)
		}
	}
}
