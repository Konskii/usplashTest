//
//  NetworkManager.swift
//  unsplashRMR
//
//  Created by Артём Скрипкин on 16.12.2020.
//

import Foundation
extension String: Error {}
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
    
    //MARK: - createBaseRequest
    /// - Parameter path: путь по которому будет проходить запрос относительно хоста
    private func createBaseRequest(path: Paths) -> URLRequest? {
        guard var url = URL(string: Paths.hostPath.rawValue) else { return nil }
        url.appendPathComponent(path.rawValue)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = standartHeaders
        return request
    }
    
    //MARK: - getRandomPhoto:
    /// - Parameter completion: замыкание, в котоое возвращается либо ошибка в случае неудачи и модель фотографии в случаее успеха
    public func getRandomPhoto(completion: @escaping (Result<PhotoModel, Error>) -> Void) {
        guard let request = createBaseRequest(path: .randomPhotoPath) else { return }
        netwrokSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else { completion(.failure("response couldn't be casted")); return }
            
            if response.statusCode == 200 {
                guard let data = data else { completion(.failure("data is nil")); return }
                guard let photoModel = try? JSONDecoder().decode(PhotoModel.self, from: data) else { completion(.failure("parsing error")); return }
                completion(.success(photoModel))
            } else {
                completion(.failure("\(response.statusCode)"))
            }
        }.resume()
    }
}
