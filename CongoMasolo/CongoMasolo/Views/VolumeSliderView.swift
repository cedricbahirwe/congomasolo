//
//  VolumeSliderView.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 05/09/2023.
//

import SwiftUI

struct VolumeSliderView: UIViewRepresentable {
    let slider: UISlider
    
    func makeUIView(context: Context) -> UISlider {
        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) {}
}
