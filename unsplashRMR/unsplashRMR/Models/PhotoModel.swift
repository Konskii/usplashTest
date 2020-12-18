//
//  PhotoModel.swift
//  unsplashRMR
//
//  Created by Артём Скрипкин on 16.12.2020.
//

import Foundation
struct PhotoModel: Codable {
    var id: String
    var width: Int
    var height: Int
    var description: String?
    var urls: UrlsModel
}
