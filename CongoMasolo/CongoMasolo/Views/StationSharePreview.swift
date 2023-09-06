//
//  StationSharePreview.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 06/09/2023.
//

import SwiftUI

struct StationSharePreview: View {
    let albumArt : Image
    let radioShoutout: String
    let trackTitle: String
    let trackArtist: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            albumArt
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 435)
                .clipped()
            
            VStack {
                HStack(spacing: 20) {
                    VStack(alignment: .leading) {
                        Text(trackTitle)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text(trackArtist)
                            .font(.headline)
                            .font(.system(size: 18))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(.lightText))
                    
                    Image("appicon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 70)
                        .background(.white)
                        .cornerRadius(10)
                        .layoutPriority(1)
                }
                
                HStack {
                    Spacer()
                    
                    Text(radioShoutout)
                        .foregroundColor(Color(.lightText))
                    
                }
                .frame(height: 24)
            }
            .padding(.vertical)
            .frame(maxHeight: .infinity)
        }
        .padding(10
        )
        .frame(width: 600, height: 600)
        .background(Color(.darkGray))
    }
}

#if DEBUG
struct StationSharePreview_Previews: PreviewProvider {
    static let example = RadioStation.example
    static var previews: some View {
        StationSharePreview(albumArt: .init("stationImage"),
                            radioShoutout: example.shoutout,
                            trackTitle: example.trackName,
                            trackArtist: example.artistName)
            .padding()
            .previewLayout(.sizeThatFits)
            .background(.green)
//            .previewLayout(.fixedla)
        
    }
}
#endif
