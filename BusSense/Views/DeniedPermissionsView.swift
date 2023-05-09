//
//  DeniedPermissionsView.swift
//  BusSense
//
//  Created by Daniel Aguilar-Rodriguez on 3/27/23.
//

import SwiftUI

struct DeniedPermissionsView: View {
    var body: some View {
        ZStack {
            Color("Color1").ignoresSafeArea()
            
            VStack {
                Image(systemName: "location.slash.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                Text("Location services have been disabled.").padding()
            }
        }
    }
}

struct DeniedPermissionsView_Previews: PreviewProvider {
    static var previews: some View {
        DeniedPermissionsView()
    }
}
