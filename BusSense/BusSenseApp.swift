//
//  BusSenseApp.swift
//  BusSense
//
//  Created by Suhaima Islam on 2/4/23.
//

import SwiftUI

@main
struct BusSenseApp: App {
    @StateObject var speechSynthesizer = SpeechSynthesizer()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(speechSynthesizer)
        }
    }
}
