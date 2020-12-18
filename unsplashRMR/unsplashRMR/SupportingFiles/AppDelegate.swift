//
//  AppDelegate.swift
//  unsplashRMR
//
//  Created by Артём Скрипкин on 16.12.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.bounds = UIScreen.main.bounds
        window?.makeKeyAndVisible()
        return true
    }
}

