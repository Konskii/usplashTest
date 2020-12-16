//
//  Alert.swift
//  unsplashRMR
//
//  Created by Евгений Скрипкин on 16.12.2020.
//

import UIKit
class Alert {
    class func showAlert(vc: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        vc.present(alertController, animated: true, completion: nil)
    }
}
