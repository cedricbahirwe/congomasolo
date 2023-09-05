//
//  StationRow.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 05/09/2023.
//

import SwiftUI

struct StationRow: View {
    let station: RadioStation
    @State private var image: Image?
    
    
    var body: some View {
        HStack {
            (image ?? Image("stationImage"))
                .resizable()
                .scaledToFill()
                .frame(maxWidth: 120)
                .frame(height: 75)
                .clipped()
                .shadow(color: .black,
                        radius: 0.5,
                        x: 0, y: 1)
            
            VStack(alignment: .leading) {
                Text(station.name)
                    .font(.headline)
                
                Text(station.desc)
                    .font(.subheadline)
            }
        }
        .task {
            self.image = Image(uiImage: await station.getImage())
        }
    }
}

#if DEBUG
struct StationRow_Previews: PreviewProvider {
    static var previews: some View {
        StationRow(station: .example)
    }
}
#endif
