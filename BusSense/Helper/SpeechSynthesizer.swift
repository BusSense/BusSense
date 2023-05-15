//
//  SpeechSynthesizer.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 5/14/23.
//

import Foundation
import AVFoundation

class SpeechSynthesizer: ObservableObject {
    @Published var synthesizer = AVSpeechSynthesizer()
    var voiceToUse: AVSpeechSynthesisVoice? = nil
    @Published var voiceEnabled = true
    
    func toggleVoice() {
        if voiceEnabled {
            voiceEnabled = false
        } else {
            voiceEnabled = true
        }
    }
    
    init() {
        var speechVoice = AVSpeechSynthesisVoice(language: "en-US")
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            if voice.name == "Samantha (Enhanced)" {
                speechVoice = voice
            }
        }
        voiceToUse = speechVoice
    }
    
    func formatSpeechString(_ text: String) -> String {
        let abbrevations = [
            "LTD": "limited",
            "ST": "street",
            "AV": "avenue",
            "FT": "fort",
            "/": " ",
            "AMSTER": "amsterdam",
            "N": "west",
            "E": "east",
            "S": "south",
            "W": "west"
        ]
        
        var formatted = text
//        var formated = text.replacingOccurrences(of: "/", with: " ")
        
        for (key, value) in abbrevations {
            formatted = formatted.replacingOccurrences(of: "\\b" + key + "\\b", with: value, options: .regularExpression)
        }
        
        return formatted
    }

    func speak(_ text: String) {
//        for voice in AVSpeechSynthesisVoice.speechVoices() {
//            print("\(voice.name)")
//            print(voice)
//        }
        
        let formattedText = formatSpeechString(text)
        print(formattedText)
        
        let utterance = AVSpeechUtterance(string: formattedText)
        utterance.voice = voiceToUse
//        utterance.voice = AVSpeechSynthesisVoice(identifier: AVSpeechSynthesisVoiceIdentifierAlex)
//        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//        utterance.rate = 0.5
//        utterance.pitchMultiplier = 1.0
//        utterance.volume = 1.0

        synthesizer.speak(utterance)
    }
}
