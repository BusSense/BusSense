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
            
            Color("Color1").ignoresSafeArea()
            
            VStack {
                
                Text("Waiting for:")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(50)
                    .background(Color("Color2"))
                    .cornerRadius(20)
                
                Text(busName)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(50)
                    .background(Color("Color2"))
                    .cornerRadius(20)
                
                Spacer()
                
                Text("Status: \nX min\nY blocks")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(50)
                    .background(Color("Color2"))
                    .cornerRadius(20)
                    
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


