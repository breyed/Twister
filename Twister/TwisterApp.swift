import AVFoundation
import SwiftUI

@main
struct TwisterApp: App {
    let speechSynthesizer = AVSpeechSynthesizer()
    
    init() {
        try? AVAudioSession.sharedInstance().setCategory(.ambient)
    }

    var body: some Scene {
        WindowGroup {
            Spinner(speechSynthesizer: speechSynthesizer)
        }
    }
}
