//
//  AppDelegate.swift
//  MealDB
//
//  Created by Владислав Галкин on 12.06.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainController = MealModuleBuilder()
        window?.rootViewController = mainController.build()
        window?.makeKeyAndVisible()
        return true
    }
}

