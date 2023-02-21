//
//  WaitingView.swift
//  BusSense
//
//  Created by Suhaima Islam on 2/4/23.
//

import SwiftUI

struct WaitingView: View {
    
    var body: some View {
        
        ZStack {
            
            Color("Color1").ignoresSafeArea()
            
            VStack {
                
                Text("Currently waiting for:\nBUS BOUND SELECTION")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(50)
                    .background(Color("Color2"))
                    .cornerRadius(20)
                
                Spacer()
                
                Text("X min")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(100)
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
        WaitingView()
    }
}


