//
//  CongoMasoloApp.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 04/09/2023.
//

import SwiftUI

@main
struct CongoMasoloApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var stationsVM = StationsViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(stationsVM)
        }
    }
}
