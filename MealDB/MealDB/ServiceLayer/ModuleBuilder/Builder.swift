//
//  AssemblyBuilder.swift
//  MealDB
//
//  Created by Владислав Галкин on 22.06.2021.
//

import UIKit

protocol BuilderProtocol {
   static func createMainModule() -> UIViewController
   static func createDetailMealModule(mealModel: MealViewModel) -> UIViewController
}

final class Builder: BuilderProtocol {

    static func createMainModule() -> UIViewController {
        let mealListView = ListMealVIewController()
        let menuView = MenuViewController()
        let networkService = MealNetworkService()
        let presenter = ListMealPresenter(view: mealListView, networkService: networkService)
        mealListView.presenter = presenter
        let controller = ContainerViewController(mealListView: mealListView, menuView: menuView)
        controller.centerController = UINavigationController(rootViewController: mealListView)
        return controller
    }
    
    static func createDetailMealModule(mealModel: MealViewModel) -> UIViewController {
        let mealListView = DetailMealView()
        let networkService = MealNetworkService()
        let pressenter = DetailMealPresenter(view: mealListView, networkService: networkService, mealModel: mealModel)
        mealListView.presenter = pressenter
        return mealListView
    }
}
