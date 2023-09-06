//
//  Config.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 05/09/2023.
//

import Foundation

struct Config {
    private init() { }
    
    static let debugLog = true

    // If this is set to "true", it will use the JSON file in the app
    // Set it to "false" to use the JSON file at the stationDataURL
    static let useLocalStations = false
    static let stationsURL = "https://cedricbahirwe.github.io/html/radio/stations.json"

    // Set this to "true" to enable the search bar
    static let searchable = false

    // Set this to "false" to show the next/previous player buttons
    static let hideNextPreviousButtons = true
    
    // Contact infos
    static let email = "abc.incs.001@gmail.com"
    static let linkedIn =  "https://www.linkedin.com/in/cedricbahirwe"
    static let emailSubject = "From \(Bundle.main.appName) App"
    
    static let stationRequest = "https://forms.gle/cFYhU5qRTFxHcRRT6"
    
    static let radioActivity = "com.abc.incs.cedricbahirwe.CongoMasolo.openRadio"
    
    // Acknowledgements
    static let aristoteInsta = "https://www.instagram.com/aristote_aml"
    static let sdkLink = "https://fethica.github.io/FRadioPlayer"
}

