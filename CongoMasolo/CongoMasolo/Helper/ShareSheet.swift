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
            
            DispatchQueue.main.async {
                presentShareSheet(radioPreview)
            }
            
        }
    }
    
    private static func presentShareSheet(_ radioPreview: StationSharePreview) {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow})
            .first
        let stationPreviewImage = radioPreview.snapshot()
        
        let promoMessage = radioPreview.radioShoutout + ".\nTéléchargez l'appli sur \(Config.appStoreURL)"
        let activityVC = UIActivityViewController(activityItems: [promoMessage, stationPreviewImage], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = keyWindow?.rootViewController?.view
        //Setup share activity position on screen on bottom center
        activityVC.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height, width: 0, height: 0)
        activityVC.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        
        keyWindow?.rootViewController?.present(activityVC, animated: true)
    }
    
    private static func getImage(station: RadioStation, artworkURL: URL?) async -> UIImage {
        if let artworkURL = artworkURL {
            return await UIImage.image(from: artworkURL) ?? UIImage(named: "stationImage")!
        } else {
            return await station.getImage()
        }
    }
}
