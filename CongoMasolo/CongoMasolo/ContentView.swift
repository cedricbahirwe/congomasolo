//
//  ContentView.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 04/09/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        StationsView()
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
