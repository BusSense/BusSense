//
//  LoadingView.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 3/27/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color("Color1").ignoresSafeArea()
            
            ProgressView()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
