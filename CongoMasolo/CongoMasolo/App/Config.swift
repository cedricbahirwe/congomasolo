//
//  Config.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 05/09/2023.
//

import Foundation

struct Config {
    private init() { }
    
    #if DEBUG
    static let debugLog = true
    static let useLocalStations = true
    #else
    static let debugLog = false
    static let useLocalStations = false
    #endif

    static let stationsURL = "https://cedricbahirwe.github.io/html/radio/stations.json"

    // Set this to "true" to enable the search bar
    static let searchable = false

    // Set this to "false" to show the next/previous player buttons
    static let hideNextPreviousButtons = false
    
    // Contact infos
    static let email = "abc.incs.001@gmail.com"
    static let linkedIn =  "https://www.linkedin.com/in/cedricbahirwe"
    static let emailSubject = "From \(Bundle.main.appName) App"
    
    // RadioStation Requesting
    static let stationRequest = "https://forms.gle/cFYhU5qRTFxHcRRT6"
    
    // Handoff
    static let radioActivity = "com.abc.incs.cedricbahirwe.CongoMasolo.openRadio"
    
    // Acknowledgements
    static let aristoteInsta = "https://www.instagram.com/aristote_aml"
    static let sdkLink = "https://fethica.github.io/FRadioPlayer"
}

