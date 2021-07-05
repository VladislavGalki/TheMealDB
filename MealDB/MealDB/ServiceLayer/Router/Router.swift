//
//  Router.swift
//  MealDB
//
//  Created by Владислав Галкин on 06.07.2021.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func launchScreenViewController()
    func mainMealViewController()
    func showDetailMeal(mealModel: MealViewModel)
}

final class Router: RouterProtocol {

    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func launchScreenViewController() {
        if let navigationController = navigationController {
            guard let mainViewController = assemblyBuilder?.createLaunchScreenModule(router: self) else { return }
            navigationController.viewControllers = [mainViewController]
        }
    }
    
    func mainMealViewController() {
        if let navigationController = navigationController {
            guard let mealViewController = assemblyBuilder?.createMainModule(router: self) else { return }
            navigationController.pushViewController(mealViewController, animated: true)
        }
    }
    
    func showDetailMeal(mealModel: MealViewModel) {
        if let navigationController = navigationController {
            guard let detailViewController = assemblyBuilder?.createDetailMealModule(mealModel: mealModel) else { return }
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
    
}
