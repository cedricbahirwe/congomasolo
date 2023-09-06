//
//  RadioPlayerManager.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 05/09/2023.
//

import MediaPlayer

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
    
    init(_ station: RadioStation?) {
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
                
        stationTitle = manager.currentStation?.name
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
            return
        }
        
        Task {
            let image = await UIImage.image(from: artworkURL)
            albumImage = image
            stationDescHidden = true
        }
    }
    
    @Published var playingButtonSelected = false
    private func isPlayingDidChange(_ isPlaying: Bool) {
        playingButtonSelected = isPlaying
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
            return
        }
                
        // Update UI only when it's not aleary updated
        guard songLabel != statusMessage else { return }
        
        songLabel = statusMessage
        artistLabel = manager.currentStation?.name
    }
    
    func shareButtonPressed() {
        guard let station = manager.currentStation else { return }
        ShareSheet.shareRadioStation(station: station, artworkURL: player.currentArtworkURL)
    }
    
    func handleCompanyButton() {
        showAboutView = true
    }
    
    // MARK: - Present Sheets
    @Published var showAboutView = false
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
