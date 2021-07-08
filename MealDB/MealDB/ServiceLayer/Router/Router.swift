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
    func showDetailMealController(mealModel: MealViewModel)
    func showVideoMealController(videoUrlPath: String)
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
    
    func showDetailMealController(mealModel: MealViewModel) {
        if let navigationController = navigationController {
            guard let detailViewController = assemblyBuilder?.createDetailMealModule(mealModel: mealModel, router: self) else { return }
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
    
    func showVideoMealController(videoUrlPath: String) {
        if let navigationController = navigationController {
            guard let videoViewController = assemblyBuilder?.createVideoMealModule(videoUrlPath: videoUrlPath) else { return }
            let transition = PanelTransition()
            videoViewController.modalPresentationStyle = .custom
            videoViewController.transitioningDelegate = transition
            navigationController.present(videoViewController, animated: true, completion: nil)
        }
    }
}
