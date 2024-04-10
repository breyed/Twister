import Foundation
import AVFoundation
import SwiftUI

final class Model: ObservableObject {
	private let speechSynthesizer = AVSpeechSynthesizer()

	@Published var spins = 0
	@Published var member = ""
	@Published var color = Color.gray
	var colorName = ""

	@Published var autoSpin = false
	@Published var autoSpinSeconds = 5
	@Published var funVoices = false
	@Published var randomVoices = true
	@Published var randomRatesAndPitches = false
	@Published var sillySayings = false
	@Published var goofyColors = false
	@Published var voice: AVSpeechSynthesisVoice // Only applies if using fun voices.

	init() {
		try? AVAudioSession.sharedInstance().setCategory(.soloAmbient)
		voice = AVSpeechSynthesisVoice(language: Locale.current.language.maximalIdentifier) ?? AVSpeechSynthesisVoice()
		resetGame()
	}

	func resetGame() {
		spins = 0
		color = .gray
		member = "Twister Spinner"
	}

	func speak(_ text: String) {
		if randomVoices {
			voice = AVSpeechSynthesisVoice.speechVoices().randomElement() ?? AVSpeechSynthesisVoice()
		}

		let utterance = AVSpeechUtterance(string: text)
		utterance.voice = voice
		if utterance.voice == nil {
			let language = Locale.current.language
			if language.languageCode?.identifier == "en", language.region == "US" {
				utterance.voice = AVSpeechSynthesisVoice(language: "en-GB") // Uses British over American because it sounds better.
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
		case funVoices
		case randomVoices
		case randomRatesAndPitches
		case sillySayings
		case goofyColors
	}

	convenience init(from decoder: Decoder) {
		self.init()
		do {
			let values = try decoder.container(keyedBy: CodingKeys.self)
			autoSpin = try values.decode(Bool.self, forKey: .autoSpin)
			autoSpinSeconds = try values.decode(Int.self, forKey: .autoSpinSeconds)
			funVoices = try values.decode(Bool.self, forKey: .funVoices)
			randomVoices = try values.decode(Bool.self, forKey: .randomVoices)
			randomRatesAndPitches = try values.decode(Bool.self, forKey: .randomRatesAndPitches)
			sillySayings = try values.decode(Bool.self, forKey: .sillySayings)
			goofyColors = try values.decode(Bool.self, forKey: .goofyColors)
		} catch {}
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(autoSpin, forKey: .autoSpin)
		try container.encode(autoSpinSeconds, forKey: .autoSpinSeconds)
		try container.encode(funVoices, forKey: .funVoices)
		try container.encode(randomVoices, forKey: .randomVoices)
		try container.encode(randomRatesAndPitches, forKey: .randomRatesAndPitches)
		try container.encode(sillySayings, forKey: .sillySayings)
		try container.encode(goofyColors, forKey: .goofyColors)
	}
}
