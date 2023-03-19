//
//  BusConfimationView.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 3/6/23.
//

import SwiftUI

struct BusConfimationView: View {
    var body: some View {
        ZStack {
            Color("Color1").ignoresSafeArea()
            
            VStack {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Spacer()
                
                Text("TRACKING")
                    .font(.title)
                    .fontWeight(.bold)
                Text("M100 - INWOOD 220 ST\nBus is 4.5 miles away")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color("Color2"))
                    .cornerRadius(20)
                
                Spacer()
                Spacer()
            }
        }
    }
}

struct BusConfimationView_Previews: PreviewProvider {
    static var previews: some View {
        BusConfimationView()
    }
}
