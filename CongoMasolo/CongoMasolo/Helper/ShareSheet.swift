//
//  ShareSheet.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 06/09/2023.
//

import UIKit

enum ShareSheet {
    
    static func shareRadioStation(station: RadioStation, artworkURL: URL?) {
        Task {
            let imagePreview = await getImage(station: station, artworkURL: artworkURL)
            
            
            let radioPreview = StationSharePreview(
                albumArt: .init(uiImage: imagePreview),
                radioShoutout: station.shoutout,
                trackTitle: station.trackName,
                trackArtist: station.artistName)
            
            let stationPreviewImage = radioPreview.snapshot()
            let activityVC = await UIActivityViewController(activityItems: [stationPreviewImage], applicationActivities: nil)
            await UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }
    
    private static func getImage(station: RadioStation, artworkURL: URL?) async -> UIImage {
        if let artworkURL = artworkURL {
            return await UIImage.image(from: artworkURL) ?? UIImage(named: "stationImage")!
        } else {
            return await station.getImage()
        }
    }
}
