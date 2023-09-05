//
//  BlurredBackground.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 05/09/2023.
//

import SwiftUI

struct BlurredBackground: View {
    var body: some View {
        Image("background")
            .resizable()
            .ignoresSafeArea()
    }
}

struct BlurredBackground_Previews: PreviewProvider {
    static var previews: some View {
        BlurredBackground()
    }
}
