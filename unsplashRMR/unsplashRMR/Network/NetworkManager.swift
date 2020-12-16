//
//  NetworkManager.swift
//  unsplashRMR
//
//  Created by Евгений Скрипкин on 16.12.2020.
//

import Foundation
import UIKit

class NetworkManager {
    //TODO
    private let standartHeaders = ["Content-Type" : "application/json",
                                   "Authorization" : "Client-ID zElSqab36FO-CJFLQnCBVHeat9toeSKivaWSoDFbqOU"]
    //MARK: - Paths
    private enum Paths: String {
        case hostPath = "https://api.unsplash.com"
        case photosPath = "/photos"
        case randomPhotoPath = "/photos/random"
        case searchPhotosPath = "/search/photos"
        case collectionsPath = "/collections"
    }
    
    //MARK: - Inits
    static let shared = NetworkManager()
    private let netwrokSession = URLSession.shared
    private init() {}
    
    private func createBaseRequest(path: Paths) -> URLRequest? {
        guard var url = URL(string: Paths.hostPath.rawValue) else { return nil }
        url.appendPathComponent(path.rawValue)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = standartHeaders
        return request
    }
    
    //TODO Errors
    public func getRandomPhoto(completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let request = createBaseRequest(path: .randomPhotoPath) else { return }
        netwrokSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                guard let data = data else { print("getRandomData"); return }
                guard let parsedData = try? JSONDecoder().decode(PhotoModel.self, from: data) else { print("parse"); return }
                guard let url = URL(string: parsedData.urls.regular) else { print("url"); return }
                self.netwrokSession.dataTask(with: url) { data, response, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    if let data = data {
                        guard let image = UIImage(data: data) else { return }
                        completion(.success(image))
                    }
                }.resume()
            }
        }.resume()
    }
}
