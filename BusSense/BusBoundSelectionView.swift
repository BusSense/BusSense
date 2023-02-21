//
//  BusBoundSelectionView.swift
//  BusSense
//
//  Created by Suhaima Islam on 2/4/23.
//

import SwiftUI

struct BusBoundSelectionView: View {
    
    var body: some View {
        
        ZStack {
            
            Color("Color1").ignoresSafeArea()
            
            VStack {
                
                Text("DIRECTION 1")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(100)
                    .background(Color("Color2"))
                    .cornerRadius(20)
                
                Spacer()
                
                Text("Select Bus Direction")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(30)
                    .background(Color("Color2"))
                    .cornerRadius(20)
                
                Spacer()
                
                Text("DIRECTION 2")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(100)
                    .background(Color("Color2"))
                    .cornerRadius(20)
                    
                    
            }
            .padding()
            
        }
    }
}

struct BusBoundSelection_Previews: PreviewProvider {
    static var previews: some View {
        BusBoundSelectionView()
    }
}
