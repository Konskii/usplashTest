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
        createDataTask(path: .randomPhotoPath, completion: completion)
    }
    
    public func getPhotoList(page: Int, completion: @escaping (Result<PhotosModel, Error>) -> Void) {
        createDataTask(path: .photosPath, page: page, completion: completion)
    }
    
    private func createDataTask<T: Codable>(path: Paths, page: Int? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        guard var request = createBaseRequest(path: path) else { completion(.failure("Request Error")); return }
        if let page = page {
            guard var url = request.url?.absoluteString else { return }
            url.append("?page=\(page)")
            request.url = URL(string: url)
        }
        
        netwrokSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure("\(error)"))
                return
            }
            
            guard let response = response as? HTTPURLResponse else { completion(.failure("response can not be casted")); return }
            
            if response.statusCode == 200 {
                guard let data = data else { completion(.failure("data is nil")); return }
                guard let parsedData = try? JSONDecoder().decode(T.self, from: data) else { completion(.failure("parsing error")); return }
                completion(.success(parsedData))
            } else {
                switch response.statusCode {
                case 400:
                    completion(.failure("400 - Bad Request"))
                case 401:
                    completion(.failure("401 - Unauthorized"))
                case 403:
                    completion(.failure("403 - Forbidden"))
                case 404:
                    completion(.failure("404 - Not Found"))
                case 500, 503:
                    completion(.failure("Server Error"))
                default:
                    completion(.failure("uncommented error"))
                }
            }
        }.resume()
    }
}
