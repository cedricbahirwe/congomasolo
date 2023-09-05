//
//  RadioPlayerManager.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 05/09/2023.
//

import Foundation
import UIKit

@MainActor class RadioPlayerManager: ObservableObject {
    @Published var isNewStation: Bool = false
    
    @Published var volume = 0.0
    let volumRange: ClosedRange<CGFloat> = 0...1
    let volumeStep = 0.1
    
    var currentStation: RadioStation? {
        manager.currentStation
    }
    
    @Published var albumImage: UIImage?
    @Published var stationDesc: String?
    @Published var stationDescIsHidden: Bool = true
    
    
    
    @Published var songLabel: String?
    @Published var artistLabel: String?
    
    private let player = FRadioPlayer.shared
    private let manager = StationsManager.shared
    
    init(_ station: RadioStation) {
        self.isNewStation = isNewStation
        
        isNewStation = station != manager.currentStation
        if isNewStation {
            manager.set(station: station)
        }
        
        performSetup()
    }
    
    func performSetup() {
        // Check for station change
        if isNewStation {
            stationDidChange()
        } else {
            updateTrackArtwork()
            //            playerStateDidChange(player.state, animate: false)
        }
    }
    
    
    func stationDidChange() {
        albumImage = nil
        Task {
            albumImage = await manager.currentStation?.getImage()
        }
        stationDesc = manager.currentStation?.desc
        stationDescIsHidden = player.currentArtworkURL != nil
        updateLabels()
    }
    
    func updateLabels(with statusMessage: String? = nil, animate: Bool = true) {
        
        guard let statusMessage = statusMessage else {
            // Radio is (hopefully) streaming properly
            songLabel = manager.currentStation?.trackName
            artistLabel = manager.currentStation?.artistName
            //            shouldAnimateSongLabel(animate)
            return
        }
        
        // There's a an interruption or pause in the audio queue
        
        // Update UI only when it's not aleary updated
        guard songLabel != statusMessage else { return }
        
        songLabel = statusMessage
        artistLabel = manager.currentStation?.name
        
        //        if animate {
        //            songLabel.animation = "flash"
        //            songLabel.repeatCount = 2
        //            songLabel.animate()
        //        }
    }
    
    // Update track with new artwork
    func updateTrackArtwork() {
        guard let artworkURL = player.currentArtworkURL else {
            Task {
                self.albumImage = await manager.currentStation?.getImage()
            }
            //            manager.currentStation?.getImage { [weak self] image in
            //                self?.albumImageView.image = image
            //                self?.stationDescLabel.isHidden = false
            //            }
            return
        }
        
        //        albumImageView.load(url: artworkURL) { [weak self] in
        //            self?.albumImageView.animation = "wobble"
        //            self?.albumImageView.duration = 2
        //            self?.albumImageView.animate()
        //            self?.stationDescLabel.isHidden = true
        //
        //            // Force app to update display
        //            self?.view.setNeedsDisplay()
        //        }
    }
    
    
    func setupVolumeSlider() {
        
    }
    
}
