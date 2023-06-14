import AVFoundation
import SwiftUI

@main
struct TwisterApp: App {
	let speechSynthesizer = AVSpeechSynthesizer()
	
	init() {
		try? AVAudioSession.sharedInstance().setCategory(.soloAmbient)
	}

	var body: some Scene {
		WindowGroup {
			Spinner(speechSynthesizer: speechSynthesizer)
		}
	}
}
