//
//  StationsManager.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 05/09/2023.
//

import Foundation
import MediaPlayer

protocol StationsManagerObserver: AnyObject {
    func stationsManager(_ manager: StationsManager, stationsDidUpdate stations: [RadioStation])
    func stationsManager(_ manager: StationsManager, stationDidChange station: RadioStation?)
}

extension StationsManagerObserver {
    func stationsManager(_ manager: StationsManager, stationsDidUpdate stations: [RadioStation]) {}
}

class StationsManager {

    static let shared = StationsManager()

    private(set) var stations: [RadioStation] = [] {
        didSet {
            notifiyObservers { observer in
                observer.stationsManager(self, stationsDidUpdate: stations)
            }
        }
    }

    private(set) var currentStation: RadioStation? {
        didSet {
            notifiyObservers { observer in
                observer.stationsManager(self, stationDidChange: currentStation)
            }

            resetArtwork(with: currentStation)
        }
    }

    var searchedStations: [RadioStation] = []

    private var observations = [ObjectIdentifier : Observation]()
    private let player = FRadioPlayer.shared

    private init() {
        self.player.addObserver(self)
    }

    func fetchStations() async throws -> [RadioStation] {
        do {
            let result = try await DataManager.getStations()
            guard stations != result else {
                return result
            }
            
            self.stations = result
            
            // Reset everything if the new stations list doesn't have the current station
            if let currentStation = self.currentStation, self.stations.firstIndex(of: currentStation) == nil {
                self.reset()
            }
            
            return result
        } catch {
            throw error
        }
    }

    func set(station: RadioStation?) {
        guard let station = station else {
            reset()
            return
        }

        currentStation = station
        player.radioURL = URL(string: station.streamURL)
    }

    func setNext() {
        guard let index = getIndex(of: currentStation) else { return }
        let station = (index + 1 == stations.count) ? stations[0] : stations[index + 1]
        currentStation = station
        player.radioURL = URL(string: station.streamURL)
    }

    func setPrevious() {
        guard let index = getIndex(of: currentStation), let station = (index == 0) ? stations.last : stations[index - 1] else { return }
        currentStation = station
        player.radioURL = URL(string: station.streamURL)
    }

    func updateSearch(with filter: String) {
        searchedStations.removeAll(keepingCapacity: false)
        searchedStations = stations.filter { $0.name.range(of: filter, options: [.caseInsensitive]) != nil }
    }

    private func reset() {
        currentStation = nil
        player.radioURL = nil
    }

    private func getIndex(of station: RadioStation?) -> Int? {
        guard let station = station, let index = stations.firstIndex(of: station) else { return nil }
        return index
    }
}

// MARK: - StationsManager Observation

extension StationsManager {

    private struct Observation {
        weak var observer: StationsManagerObserver?
    }

    func addObserver(_ observer: StationsManagerObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = Observation(observer: observer)
    }

    func removeObserver(_ observer: StationsManagerObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }

    private func notifiyObservers(with action: (_ observer: StationsManagerObserver) -> Void) {
        for (id, observation) in observations {
            guard let observer = observation.observer else {
                observations.removeValue(forKey: id)
                continue
            }

            action(observer)
        }
    }
}

// MARK: - MPNowPlayingInfoCenter (Lock screen)

extension StationsManager {

    private func resetArtwork(with station: RadioStation?) {

        guard let station = station else {
            updateLockScreen(with: nil)
            return
        }

        Task {
            updateLockScreen(with: await station.getImage())
        }
    }

    private func updateLockScreen(with artworkImage: UIImage?) {

        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()

        if let image = artworkImage {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { size -> UIImage in
                return image
            })
        }

        if let artistName = currentStation?.artistName {
            nowPlayingInfo[MPMediaItemPropertyArtist] = artistName
        }

        if let trackName = currentStation?.trackName {
            nowPlayingInfo[MPMediaItemPropertyTitle] = trackName
        }

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}

// MARK: - FRadioPlayerObserver

extension StationsManager: FRadioPlayerObserver {

    func radioPlayer(_ player: FRadioPlayer, metadataDidChange metadata: FRadioPlayer.Metadata?) {
        resetArtwork(with: currentStation)
    }

    func radioPlayer(_ player: FRadioPlayer, artworkDidChange artworkURL: URL?) async {

        guard let artworkURL = artworkURL else {
            resetArtwork(with: currentStation)
            return
        }

        
        if let image = await UIImage.image(from: artworkURL) {
            self.updateLockScreen(with: image)
        } else {
            self.resetArtwork(with: currentStation)
            return
        }
    }
}
