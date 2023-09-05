//
//  RadioPlayerManager.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 05/09/2023.
//

import Foundation
import UIKit
import MediaPlayer
import Combine

@MainActor class RadioPlayerManager: ObservableObject {
    private let manager = StationsManager.shared
    private let player = FRadioPlayer.shared
    
    var currentStation: RadioStation? {
        manager.currentStation
    }
    
    @Published var isNewStation: Bool = false
    @Published var albumImage: UIImage?
    @Published var stationDesc: String?
    @Published var stationDescHidden: Bool = true
    
    @Published var songLabel: String?
    @Published var artistLabel: String?
    @Published var stationTitle: String?
    @Published var previousButtonHidden = false
    @Published var nextButtonHidden = false
    
    init(_ station: RadioStation) {
        self.isNewStation = isNewStation
        
        isNewStation = station != manager.currentStation
        
        if isNewStation {
            manager.set(station: station)
        }
    
        performSetup()

    }
    
    @Published var mpVolumSliderValue: UISlider?
    
    
    func performSetup() {
        player.addObserver(self)
        manager.addObserver(self)
        
        // Create Now Playing BarItem
        createNowPlayingAnimation()
        
        // Set View Title
        stationTitle = manager.currentStation?.name
        
        // Set UI
        stationDesc = manager.currentStation?.desc
        stationDescHidden = player.currentMetadata != nil
        
        // Check for station change
        if isNewStation {
            stationDidChange()
        } else {
            updateTrackArtwork()
            playerStateDidChange(player.state, animate: false)
        }
        
        // Setup volumeSlider
        setupVolumeSlider()
        
        
        // Hide / Show Next/Previous buttons
        previousButtonHidden = Config.hideNextPreviousButtons
        nextButtonHidden = Config.hideNextPreviousButtons
        
        isPlayingDidChange(player.isPlaying)
    }
    
    // MARK: - Setup
    
    func setupVolumeSlider() {
        // Note: This slider implementation uses a MPVolumeView
        // The volume slider only works in devices, not the simulator.
        for subview in MPVolumeView().subviews {
            guard let volumeSlider = subview as? UISlider else { continue }
            mpVolumSliderValue = volumeSlider
        }
    }
   
    func stationDidChange() {
        albumImage = nil
        
        Task {
            self.albumImage = await manager.currentStation?.getImage()
        }
        
        stationDesc = manager.currentStation?.desc
        stationDescHidden = player.currentArtworkURL != nil
        stationTitle = manager.currentStation?.name
        updateLabels()
    }
    
    // Update track with new artwork
    func updateTrackArtwork() {
        guard let artworkURL = player.currentArtworkURL else {
            Task {
                self.albumImage = await manager.currentStation?.getImage()
                self.stationDescHidden = false
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
    
    @Published var playingButtonSelected = false
    private func isPlayingDidChange(_ isPlaying: Bool) {
        playingButtonSelected = isPlaying
        startNowPlayingAnimation(isPlaying)
    }
    
    func playbackStateDidChange(_ playbackState: FRadioPlayer.PlaybackState, animate: Bool) {
        
        let message: String?
        
        switch playbackState {
        case .paused:
            message = "Station Paused..."
        case .playing:
            message = nil
        case .stopped:
            message = "Station Stopped..."
        }
        
        updateLabels(with: message, animate: animate)
        isPlayingDidChange(player.isPlaying)
    }
    
    
    func playerStateDidChange(_ state: FRadioPlayer.State, animate: Bool) {
        
        let message: String?
        
        switch state {
        case .loading:
            message = "Loading Station ..."
        case .urlNotSet:
            message = "Station URL not valide"
        case .readyToPlay, .loadingFinished:
            playbackStateDidChange(player.playbackState, animate: animate)
            return
        case .error:
            message = "Error Playing"
        }
        
        updateLabels(with: message, animate: animate)
    }
    
    
    func updateLabels(with statusMessage: String? = nil, animate: Bool = true) {
        
        guard let statusMessage = statusMessage else {
            // Radio is (hopefully) streaming properly
            songLabel = manager.currentStation?.trackName
            artistLabel = manager.currentStation?.artistName
            shouldAnimateSongLabel(animate)
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
    
    
    // MARK: - Animations
    func shouldAnimateSongLabel(_ animate: Bool) {
        // Animate if the Track has album metadata
        guard animate, player.currentMetadata != nil else { return }
        
        // songLabel animation
//        songLabel.animation = "zoomIn"
//        songLabel.duration = 1.5
//        songLabel.damping = 1
//        songLabel.animate()
    }
    
    
    func createNowPlayingAnimation() {
//        // Setup ImageView
//        nowPlayingImageView = UIImageView(image: UIImage(named: "NowPlayingBars-3"))
//        nowPlayingImageView.autoresizingMask = []
//        nowPlayingImageView.contentMode = UIView.ContentMode.center
//
//        // Create Animation
//        nowPlayingImageView.animationImages = AnimationFrames.createFrames()
//        nowPlayingImageView.animationDuration = 0.7
//
//        // Create Top BarButton
//        let barButton = UIButton(type: .custom)
//        barButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//        barButton.addSubview(nowPlayingImageView)
//        nowPlayingImageView.center = barButton.center
//
//        let barItem = UIBarButtonItem(customView: barButton)
//        self.navigationItem.rightBarButtonItem = barItem
    }
    
    
    
    func startNowPlayingAnimation(_ animate: Bool) {
        //        animate ? nowPlayingImageView.startAnimating() : nowPlayingImageView.stopAnimating()
    }
    
    func infoButtonPressed() {
        guard let station = manager.currentStation else { return }
        goToInfoView = true
    }
    
    
    func shareButtonPressed() {
//        guard let station = manager.currentStation else { return }
        //        delegate?.didTapShareButton(self, station: station, artworkURL: player.currentArtworkURL)
    }
    
    func handleCompanyButton() {
        //        delegate?.O(self)
    }
    
    @Published var goToInfoView = false
    
}

extension RadioPlayerManager: FRadioPlayerObserver {
    
    func radioPlayer(_ player: FRadioPlayer, playerStateDidChange state: FRadioPlayer.State) {
        playerStateDidChange(state, animate: true)
    }
    
    func radioPlayer(_ player: FRadioPlayer, playbackStateDidChange state: FRadioPlayer.PlaybackState) {
        playbackStateDidChange(state, animate: true)
    }
    
    func radioPlayer(_ player: FRadioPlayer, metadataDidChange metadata: FRadioPlayer.Metadata?) {
        updateLabels()
    }
    
    func radioPlayer(_ player: FRadioPlayer, artworkDidChange artworkURL: URL?) {
        updateTrackArtwork()
    }
}


extension RadioPlayerManager: StationsManagerObserver {
    
    func stationsManager(_ manager: StationsManager, stationDidChange station: RadioStation?) {
        stationDidChange()
    }
}


extension RadioPlayerManager {
    func playingPressed() {
        player.togglePlaying()
    }
    
    func stopPressed() {
        player.stop()
    }
    
    func nextPressed() {
        manager.setNext()
    }
    
    func previousPressed() {
        manager.setPrevious()
    }
}
