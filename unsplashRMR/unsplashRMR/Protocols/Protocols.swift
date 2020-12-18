//
//  Protocols.swift
//  unsplashRMR
//
//  Created by Артём Скрипкин on 17.12.2020.
//

import Foundation
import UIKit
//MARK: - MainCellServiceProtocol
protocol MainCellServiceProtocol: class {
    func showAlert(type: Alert.alertTypes, message: String)
    func showDetailVC(photoModel: PhotoModel, image: UIImage)
}

//MARK: - PhotoDetailsHeaderServiceProtocol
protocol PhotoDetailsHeaderServiceProtocol: class {
    func showAlert(type: Alert.alertTypes, message: String)
}
