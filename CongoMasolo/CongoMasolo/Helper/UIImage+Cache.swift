//
//  UIImage+Cache.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 05/09/2023.
//

import UIKit

extension UIImage {
    
    static func image(from url: URL?) async -> UIImage? {
        guard let url else { return nil }
        
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        
        if let data = cache.cachedResponse(for: request)?.data,
           let image = UIImage(data: data) {
            return image
        } else {
            do {
                let (data, response)  = try await URLSession.shared.data(from: url)
                if let httpResponse = response as? HTTPURLResponse,
                   200...299 ~= httpResponse.statusCode,
                   let image = UIImage(data: data) {
                    
                    let cachedData = CachedURLResponse(response: httpResponse, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    return image
                } else {
                    return nil
                }
                
            } catch {
                return nil
            }
            
        }
    }
    
//    static func image(from url: URL?, completion: @escaping (_ image: UIImage?) -> Void) {
//        guard let url = url else {
//            completion(nil)
//            return
//        }
//        
//        let cache = URLCache.shared
//        let request = URLRequest(url: url)
//        
//        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
//            DispatchQueue.main.async {
//                completion(image)
//            }
//        } else {
//            URLSession.shared.dataTask(with: request) { (data, response, error) in
//                guard let data = data, let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode, let image = UIImage(data: data) else {
//                    DispatchQueue.main.async { completion(nil) }
//                    return
//                }
//                
//                let cachedData = CachedURLResponse(response: httpResponse, data: data)
//                cache.storeCachedResponse(cachedData, for: request)
//                DispatchQueue.main.async { completion(image) }
//            }.resume()
//        }
//    }
}
