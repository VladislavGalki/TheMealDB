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
        let mealListView = ListMealVIewController()
        let menuView = MenuViewController()
        let networkService = MealNetworkService()
        let presenter = ListMealPresenter(view: mealListView, networkService: networkService)
        mealListView.presenter = presenter
        
        window?.rootViewController = ContainerViewController(mealListView: mealListView, menuView: menuView)
        window?.makeKeyAndVisible()
        return true
    }
}

