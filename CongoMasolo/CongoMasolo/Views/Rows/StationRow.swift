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
        HStack(spacing: 8) {
            (image ?? Image("stationImage"))
                .resizable()
                .scaledToFill()
                .frame(maxWidth: 110)
                .frame(height: 75)
                .cornerRadius(5)
                .shadow(color: .black,
                        radius: 0.5,
                        x: 0, y: 1)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(station.name)
                    .font(.headline)
                
                Text(station.desc)
                    .font(.subheadline)
            }
        }
        .task {
            image = Image(uiImage: await station.getImage())
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
