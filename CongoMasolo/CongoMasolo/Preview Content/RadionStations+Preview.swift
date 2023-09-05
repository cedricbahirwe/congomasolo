//
//  RadionStations+Preview.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 05/09/2023.
//

import Foundation

#if DEBUG
extension RadioStation {
    static let example  = RadioStation(name: "Radio Okapi", streamURL: "http://rs1.radiostreamer.com:8000/listen.pls", imageURL: "radio-okapi.jpeg", desc: "Informations pour la paix et le développment de la RDC", longDesc: "Radio Okapi est la radio de la Mission des Nations Unies pour la stabilisation en République démocratique du Congo (MONUSCO)", wesbite: nil)
}
#endif
