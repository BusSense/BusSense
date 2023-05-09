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
                Image(systemName: "bus.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                Text("Please enable location services to enable bus tracking!")
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
    }
}

struct DefaultView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultView()
    }
}
