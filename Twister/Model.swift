import Foundation
import AVFoundation
import SwiftUI

final class Model: ObservableObject {
	private let speechSynthesizer = AVSpeechSynthesizer()

	@Published var spins = 0
	@Published var color = Color.gray
	@Published var member = ""

	@Published var autoSpin = false
	@Published var autoSpinSeconds = 5
	@Published var randomVoices = false
	@Published var randomRatesAndPitches = false
	@Published var sillySayings = false
	@Published var voice: AVSpeechSynthesisVoice?

	init() {
		try? AVAudioSession.sharedInstance().setCategory(.soloAmbient)
		resetGame()
	}
	
	func resetGame() {
		spins = 0
		color = .gray
		member = "Twister Spinner"
	}

	func speak(_ text: String) {
		let utterance = AVSpeechUtterance(string: text)

		if randomVoices {
			voice = AVSpeechSynthesisVoice.speechVoices().randomElement()
			utterance.voice = voice
		} else {
			voice = nil
			let language = Locale.current.language
			if language.languageCode?.identifier == "en", language.region == "US" {
				utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
			}
		}
		
		if randomRatesAndPitches {
			utterance.rate = Float.random(in: 0.2 ..< 0.8)
			utterance.pitchMultiplier = Float.random(in: 0.8 ..< 1.2)
		}

		speechSynthesizer.stopSpeaking(at: .word)
		speechSynthesizer.speak(utterance)
	}
}

extension Model: Codable {
	enum CodingKeys: String, CodingKey {
		case autoSpin
		case autoSpinSeconds
		case randomVoices
		case randomRatesAndPitches
		case sillySayings
	}
	
	convenience init(from decoder: Decoder) {
		self.init()
		do {
			let values = try decoder.container(keyedBy: CodingKeys.self)
			autoSpin = try values.decode(Bool.self, forKey: .autoSpin)
			autoSpinSeconds = try values.decode(Int.self, forKey: .autoSpinSeconds)
			randomVoices = try values.decode(Bool.self, forKey: .randomVoices)
			randomRatesAndPitches = try values.decode(Bool.self, forKey: .randomRatesAndPitches)
			sillySayings = try values.decode(Bool.self, forKey: .sillySayings)
		} catch {}
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(autoSpin, forKey: .autoSpin)
		try container.encode(autoSpinSeconds, forKey: .autoSpinSeconds)
		try container.encode(randomVoices, forKey: .randomVoices)
		try container.encode(randomRatesAndPitches, forKey: .randomRatesAndPitches)
		try container.encode(sillySayings, forKey: .sillySayings)
	}
}
