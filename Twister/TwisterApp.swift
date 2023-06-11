import AVFoundation
import SwiftUI

@main
struct TwisterApp: App {
    let speechSynthesizer = AVSpeechSynthesizer()

    var body: some Scene {
        WindowGroup {
            Spinner(speechSynthesizer: speechSynthesizer)
        }
    }
}
