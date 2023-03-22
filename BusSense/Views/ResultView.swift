//
//  ResultView.swift
//  BusSense
//
//  Created by Suhaima Islam on 2/4/23.
//

import SwiftUI

struct ResultView: View {
    
    var body: some View {
        
        ZStack {
            
            Color("Color1").ignoresSafeArea()
            
            VStack {
                
                Text("You are looking for:\nBUS BOUND SELECTION")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color("Color2"))
                    .cornerRadius(20)
                
                Spacer()
                
                Text("Direction Results\n\n\n\n")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(100)
                    .background(Color("Color2"))
                    .cornerRadius(20)
                    
                Spacer()
                
                Text("Current Setting: Audio Description / Beacon Sounds")
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

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView()
    }
}

