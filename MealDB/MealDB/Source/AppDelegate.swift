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
    var coreDataStack = CoreDataStack()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let navigationController = UINavigationController()
        let assemblyBuilder = AssemblyBuilder(coreDataStack: coreDataStack)
        let router = Router(navigationController: navigationController, assemblyBuilder: assemblyBuilder)
        router.launchScreenViewController()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        try? coreDataStack.mainContext.save()
    }
}

