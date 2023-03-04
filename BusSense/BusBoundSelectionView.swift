//
//  BusBoundSelectionView.swift
//  BusSense
//
//  Created by Suhaima Islam on 2/4/23.
//

import SwiftUI

struct BusBoundSelectionView: View {
    
    @ObservedObject var bus: Bus
    
    var body: some View {
        
        ZStack {
            
            let busName = bus.borough + String(bus.number)
            
            Color("Color1").ignoresSafeArea()
            
            VStack {
                
                Text(busName)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(30)
                    .background(Color("Color2"))
                    .cornerRadius(20)
                
                Text("Select Bus Direction")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(30)
                    .background(Color("Color2"))
                    .cornerRadius(20)
                
                Spacer()
                
                Button {
                    print(bus.bound1)
                } label: {
                    NavigationLink(destination: WaitingView(chosenBus: ChosenBus(bound: bus.bound1, borough: bus.borough, number: bus.number))) {
                        Text(bus.bound1)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .padding(50)
                            .background(Color("Color2"))
                            .cornerRadius(20)
                    }
                }
                
//                Text(bus.bound1)
//                    .font(.title)
//                    .fontWeight(.bold)
//                    .foregroundColor(Color.white)
//                    .multilineTextAlignment(.center)
//                    .padding(50)
//                    .background(Color("Color2"))
//                    .cornerRadius(20)
                
                Spacer()
                
                Button {
                    print(bus.bound2)
                } label: {
                    NavigationLink(destination: WaitingView(chosenBus: ChosenBus(bound: bus.bound2, borough: bus.borough, number: bus.number))) {
                        Text(bus.bound2)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .padding(50)
                            .background(Color("Color2"))
                            .cornerRadius(20)
                    }
                }
                    
                    
            }
            .padding()
            
        }
    }
}

struct BusBoundSelection_Previews: PreviewProvider {
    
    static var previews: some View {
        BusBoundSelectionView(bus: Bus())
    }
}
