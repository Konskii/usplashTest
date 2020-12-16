//
//  NetworkManager.swift
//  unsplashRMR
//
//  Created by Евгений Скрипкин on 16.12.2020.
//

import Foundation
class NetworkManager {
    //TODO
    private let standartHeaders = ["Content-Type" : "application/json",
                                   "Authorization" : "Client-ID zElSqab36FO-CJFLQnCBVHeat9toeSKivaWSoDFbqOU"]
    //MARK: - Paths
    private let hostPath = "https://api.unsplash.com/"
    private let photosPath = "/photos"
    private let randomPhotoPath = "/photos/random"
    private let searchPhotosPath = "/search/photos"
    private let collectionsPath = "/collections"
    
    //MARK: - Inits
    let shared = NetworkManager()
    init() {}
    
    
}
