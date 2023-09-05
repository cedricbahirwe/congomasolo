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
}
