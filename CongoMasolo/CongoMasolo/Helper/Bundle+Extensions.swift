//
//  Bundle+Extensions.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 05/09/2023.
//

import Foundation

extension Bundle {
    var appName: String {
        object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
        object(forInfoDictionaryKey: "CFBundleName") as? String ??
        ""
    }
    
    var appVersion: String? {
        object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    var buildVersion: String? {
        object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
}
