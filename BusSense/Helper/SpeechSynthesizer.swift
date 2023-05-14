//
//  SpeechSynthesizer.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 5/14/23.
//

import Foundation
import AVFoundation

class SpeechSynthesizer {
    let synthesizer = AVSpeechSynthesizer()

    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0

        synthesizer.speak(utterance)
    }
}
