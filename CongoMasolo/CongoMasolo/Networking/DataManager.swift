//
//  DataManager.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 05/09/2023.
//

import Foundation

enum DataError: LocalizedError {
    case urlNotValid, dataNotValid, dataNotFound, fileNotFound, httpResponseNotValid
    
    var errorDescription: String? {
        switch self {
        case .urlNotValid:
            return "The provided URL is not valid. Please check the URL and try again."
        case .dataNotValid:
            return "The data received is not valid. Please try again later."
        case .dataNotFound:
            return "The requested data could not be found. Please check your connection and try again."
        case .fileNotFound:
            return "The file could not be found. Please make sure the file exists and try again."
        case .httpResponseNotValid:
            return "The server's response is not valid. Please try again later."
        }
    }
}


// MARK: - Helper struct to get either local or remote JSON
@MainActor
struct DataManager {
    static func getStations() async throws  -> [RadioStation] {
        if Config.useLocalStations {
            return try await decode(loadLocal())
        } else {
            return try await decode(loadHttp())
        }
    }
    
    private static func decode(_ data: Data?) async throws -> [RadioStation] {
        if Config.debugLog { print("Stations JSON Found") }
        
        guard let data = data else {
            throw DataError.dataNotFound
        }
        
        let jsonDictionary: [String: [RadioStation]]
        
        do {
            jsonDictionary = try JSONDecoder().decode([String: [RadioStation]].self, from: data)
        } catch let error {
            throw error
        }
        
        guard let stations = jsonDictionary["stations"] else {
            throw DataError.dataNotValid
        }
        
        return stations
    }
    
    // Load local JSON Data
    
    private static func loadLocal() async throws -> Data {
        guard let filePathURL = Bundle.main.url(forResource: "stations", withExtension: "json") else {
            if Config.debugLog { print("The local JSON file could not be found") }
            throw DataError.fileNotFound
        }
        
        do {
            let data = try Data(contentsOf: filePathURL, options: .uncached)
            return data
        } catch let error {
            throw error
        }
    }
        
    // Load http JSON Data
    private static func loadHttp() async throws -> Data {
        guard let url = URL(string: Config.stationsURL) else {
            if Config.debugLog { print("stationsURL not a valid URL") }
            throw DataError.urlNotValid
        }
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        let session = URLSession(configuration: config)
        
        // Use URLSession to get data from an NSURL
        do {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                if Config.debugLog { print("API: HTTP status code has unexpected value") }
                throw DataError.httpResponseNotValid
            }
            
            return data
            
        } catch {
            if Config.debugLog { print("API ERROR: \(error.localizedDescription)") }
            throw error
        }
    }
}
