//
//  toggleVoiceView.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 5/15/23.
//

import SwiftUI

struct toggleVoiceView: View {
    @EnvironmentObject var speechSynthesizer: SpeechSynthesizer
    
    var body: some View {
        ZStack {
            
            Text("").frame(width: 175, height: 225)
                .background(Color("Color2"))
                .cornerRadius(20)
            
            VStack {
                if speechSynthesizer.voiceEnabled {
                    Text("Disable Voice")
                        .frame(width: 175, height: 50)
                        .multilineTextAlignment(.center)
                        .background(Color("Color2"))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .cornerRadius(20)
                    
                    Spacer().frame(height: 20)
                    
                    Image(systemName: "speaker.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .foregroundColor(.white)
                } else {
                    Text("Enable Voice")
                        .frame(width: 175, height: 50)
                        .multilineTextAlignment(.center)
                        .background(Color("Color2"))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .cornerRadius(20)
                    
                    Spacer().frame(height: 20)
                    
                    Image(systemName: "speaker.slash.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75)
                        .foregroundColor(.white)
                }
                
            }
        }
    }
}

struct toggleVoiceView_Previews: PreviewProvider {
    static var previews: some View {
        toggleVoiceView()
    }
}
