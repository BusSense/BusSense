//
//  WaitingView.swift
//  BusSense
//
//  Created by Suhaima Islam on 2/4/23.
//

import SwiftUI

struct WaitingView: View {
    
    @ObservedObject var chosenBus: ChosenBus
    
    var body: some View {
        
        ZStack {
            
            let busName = chosenBus.bound + " bound " + chosenBus.borough + String(chosenBus.number)
            
            let waitingMessage = "Waiting for:\n" + busName
            
            Color("Color1").ignoresSafeArea()
            
            VStack {
                
                Text(waitingMessage)
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(width:300, height:300)
                    .foregroundColor(Color.white)
                    .background(Color("Color2"))
                    .cornerRadius(20)
                    .padding(20)
                    .multilineTextAlignment(.center)
                
//                Text(busName)
//                    .font(.title)
//                    .frame(width:300, height:300)
//                    .foregroundColor(Color.white)
//                    .background(Color("Color2"))
//                    .cornerRadius(20)
                
                Spacer()
                
                Text("Status: \nX min\nY blocks")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(width:300, height:200)
                    .foregroundColor(Color.white)
                    .background(Color("Color2"))
                    .cornerRadius(20)
                    .padding(20)
                    .multilineTextAlignment(.center)
                    
                Spacer()
                
                Text("Open Camera")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(50)
                    .background(Color("Color2"))
                    .cornerRadius(20)
            }
            .padding()
        }
    }
}

struct WaitingView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingView(chosenBus: ChosenBus())
    }
}


