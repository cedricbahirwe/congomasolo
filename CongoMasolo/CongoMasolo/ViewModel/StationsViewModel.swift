//
//  StationsViewModel.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 05/09/2023.
//

import Foundation


@MainActor
final class StationsViewModel: ObservableObject {
    @Published var stations: [RadioStation] = []
    
    @Published var activityIndicator = ActivityIndicator()
    
    @Published var errorMessage: String?
    
    private let manager = StationsManager.shared
    private let player = FRadioPlayer.shared
    
    var currentStation: RadioStation? { manager.currentStation }
    
    init() {
        player.addObserver(self)
        manager.addObserver(self)
    }
    
    func fetchStations() async {
        activityIndicator.start()
        
        do {
            let resultStations = try await manager.fetch()
            activityIndicator.stop()
            
            self.stations = resultStations
            //            self.delegate?.didFinishLoading(self, stations: stations)
        } catch {
            self.activityIndicator.stop()
            self.handle(error)
        }
    }
    
    private func handle(_ error: Error) {
        errorMessage = error.localizedDescription
    }
    
    func handleRetrial() {
        Task {
            await fetchStations()
        }
    }
    
    @Published var stationNowPlayingButtonTitle = "Sélectionnez une station pour commencer"
    @Published var stationNowPlayingButtonEnabled = false
    
    // Reset all properties to default
    private func resetCurrentStation() {
//        nowPlayingAnimationImageView.stopAnimating()
        stationNowPlayingButtonTitle = "Sélectionnez une station pour commencer"
        stationNowPlayingButtonEnabled = false
    }
    
    // Update the now playing button title
    private func updateNowPlayingButton(station: RadioStation?) {
        
        guard let station = station else {
            return
        }
        
        var playingTitle = station.name + ": "
        
        if player.currentMetadata == nil {
            playingTitle += "Now playing ..."
        } else {
            playingTitle += station.trackName + " - " + station.artistName
        }
        
        stationNowPlayingButtonTitle = playingTitle
        stationNowPlayingButtonEnabled = true
    }
}

// MARK: - FRadioPlayerObserver
extension StationsViewModel: FRadioPlayerObserver {
    
    func radioPlayer(_ player: FRadioPlayer, playbackStateDidChange state: FRadioPlayer.PlaybackState) {
//        startNowPlayingAnimation(player.isPlaying)
    }
    
    func radioPlayer(_ player: FRadioPlayer, metadataDidChange metadata: FRadioPlayer.Metadata?) {
        updateNowPlayingButton(station: manager.currentStation)
//        updateHandoffUserActivity(userActivity, station: manager.currentStation)
    }
}

// MARK: - StationsManagerObserver
extension StationsViewModel: StationsManagerObserver {
    func stationsManager(_ manager: StationsManager, stationDidChange station: RadioStation?) {
        guard let station = station else {
            resetCurrentStation()
            return
        }
        
        updateNowPlayingButton(station: station)
    }
}
