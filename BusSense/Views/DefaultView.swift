//
//  DefaultView.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 3/27/23.
//

import SwiftUI

struct DefaultView: View {
    var body: some View {
        ZStack {
            Color("Color1").ignoresSafeArea()
            
            VStack {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
                    .padding()
                Text("Please enable location services to enable bus tracking!")
                    .font(.system(size: 20))
                    .multilineTextAlignment(.center)
//                    .padding()
            }
        }
    }
}

struct DefaultView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultView()
    }
}
