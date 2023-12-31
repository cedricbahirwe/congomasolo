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
    @Published var stationNowPlayingButtonTitle = "Sélectionnez une station pour commencer"
    @Published var stationNowPlayingButtonEnabled = false
    
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
            let resultStations = try await manager.fetchStations()
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
    
    // Reset all properties to default
    private func resetCurrentStation() {
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
            playingTitle += "En cours de lecture ..."
        } else {
            playingTitle += station.trackName + " - " + station.artistName
        }
        
        DispatchQueue.main.async { [weak self] in
            
            
            self?.stationNowPlayingButtonTitle = playingTitle
            self?.stationNowPlayingButtonEnabled = true
        }
    }
}

// MARK: - FRadioPlayerObserver
extension StationsViewModel: FRadioPlayerObserver {
    
    func radioPlayer(_ player: FRadioPlayer, playbackStateDidChange state: FRadioPlayer.PlaybackState) {
    }
    
    func radioPlayer(_ player: FRadioPlayer, metadataDidChange metadata: FRadioPlayer.Metadata?) {
        updateNowPlayingButton(station: manager.currentStation)
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
