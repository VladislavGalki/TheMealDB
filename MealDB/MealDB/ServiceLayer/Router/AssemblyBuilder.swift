//
//  AssemblyBuilder.swift
//  MealDB
//
//  Created by Владислав Галкин on 22.06.2021.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createLaunchScreenModule(router: RouterProtocol) -> UIViewController
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createDetailMealModule(mealModel: MealViewModel, router: RouterProtocol) -> UIViewController
    func createVideoMealModule(videoUrlPath: String) -> UIViewController
    init(coreDataStack: CoreDataStack)
}

final class AssemblyBuilder: AssemblyBuilderProtocol {
    
    var coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func createLaunchScreenModule(router: RouterProtocol) -> UIViewController {
        let controller = LaunchScreenView()
        let presenter = LaunchScreenPresenter(view: controller, router: router)
        controller.presenter = presenter
        return controller
    }
    
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let mealListView = ListMealVIewController()
        let menuView = MenuViewController()
        let networkService = MealNetworkService()
        let presenter = ListMealPresenter(view: mealListView, networkService: networkService, router: router)
        mealListView.presenter = presenter
        let controller = ContainerViewController(mealListView: mealListView, menuView: menuView)
        return controller
    }
    
    func createDetailMealModule(mealModel: MealViewModel, router: RouterProtocol) -> UIViewController {
        let mealListView = DetailMealView()
        let networkService = MealNetworkService()
        let dataService = DetailMealCoreDataService(coreDataStack: coreDataStack)
        let presenter = DetailMealPresenter(view: mealListView, networkService: networkService, mealModel: mealModel, coreDataService: dataService, router: router)
        mealListView.presenter = presenter
        return mealListView
    }
    
    func createVideoMealModule(videoUrlPath: String) -> UIViewController {
        let videoMealView = VideoMealView()
        let presenter = VideoMealPresenter(view: videoMealView, urlVideo: videoUrlPath)
        videoMealView.presenter = presenter
        return videoMealView
    }
}



