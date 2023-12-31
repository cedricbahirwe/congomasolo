//
//  RadioStation.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 05/09/2023.
//

import UIKit

struct RadioStation: Identifiable, Hashable, Codable {
    var id: String { streamURL }
    var name: String
    var streamURL: String
    var imageURL: String
    var desc: String
    var longDesc: String
    var wesbite: String?
    
    init(name: String, streamURL: String, imageURL: String, desc: String, longDesc: String = "", wesbite: String? = nil) {
        self.name = name
        self.streamURL = streamURL
        self.imageURL = imageURL
        self.desc = desc
        self.longDesc = longDesc
        self.wesbite = wesbite
    }
}

extension RadioStation {
    var shoutout: String {
        "J'écoute \(name) via l'application \(Bundle.main.appName)"
    }
}

extension RadioStation {
    func getImage() async -> UIImage {
        if imageURL.range(of: "http") != nil, let url = URL(string: imageURL) {
            // load current station image from network
            return await UIImage.image(from: url) ?? #imageLiteral(resourceName: "stationImage")
        } else {
            return UIImage(named: imageURL) ?? #imageLiteral(resourceName: "stationImage")
        }
    }
}

extension RadioStation {
    var trackName: String {
        FRadioPlayer.shared.currentMetadata?.trackName ?? name
    }
    
    var artistName: String {
        FRadioPlayer.shared.currentMetadata?.artistName ?? desc
    }
}

extension RadioStation {
    init?(dictionary: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) else { return nil }
        guard let decodedSelf = try? JSONDecoder().decode(Self.self, from: data) else { return nil }
        self = decodedSelf
    }
}

extension RadioStation {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
