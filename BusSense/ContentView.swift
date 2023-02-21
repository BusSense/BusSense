//
//  ContentView.swift
//  BusSense
//
//  Created by Suhaima Islam on 2/4/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model = FrameHandler()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                NavigationLink(destination: MainView()) {
                    Text("MainView")
                }
                
                NavigationLink(destination: WaitingView()) {
                    Text("WaitingView")
                }
                
                NavigationLink(destination: ResultView()) {
                    Text("ResultView")
                }
                
                // camera only works on actual iphone not the simulator
                NavigationLink(destination: FrameView(image: model.frame)
                    .ignoresSafeArea()) {
                        Text("FrameView")
                    }
            }
            .navigationTitle("Navigation")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
