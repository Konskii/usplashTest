//
//  Alert.swift
//  unsplashRMR
//
//  Created by Артём Скрипкин on 16.12.2020.
//

import UIKit
class Alert {
    enum alertTypes: String {
        case succes = "Успешно!"
        case error = "Ошибка"
    }
    
    class func showAlert(vc: UIViewController, title: alertTypes, message: String) {
        let alertController = UIAlertController(title: title.rawValue, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        DispatchQueue.main.async {
            vc.present(alertController, animated: true, completion: nil)
        }
    }
}
