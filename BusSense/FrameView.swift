//
//  FrameView.swift
//  BusSense
//
//  Created by Min Zheng on 2/20/23.
//
import SwiftUI

struct FrameView: View {
    var image: CGImage?
    private let label = Text("frame")
    
    var body: some View {
        if let image = image {
            Image(image, scale: 1.0, orientation: .up, label: label)
            Color.green
        } else {
            Text("No camera on simulator, need actual iphone")
        }
    }
}

struct FrameView_Previews: PreviewProvider {
    static var previews: some View {
        FrameView()
    }
}
