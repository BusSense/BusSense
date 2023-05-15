//
//  NoNearbyView.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 5/15/23.
//

import SwiftUI

struct NoNearbyView: View {
    var body: some View {
        ZStack {
            Color("Color1").ignoresSafeArea()
            
            VStack {
                Image(systemName: "binoculars.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                Text("Not close enough to a bus stop.").padding()
            }
        }
    }
}

struct NoNearbyView_Previews: PreviewProvider {
    static var previews: some View {
        NoNearbyView()
    }
}
