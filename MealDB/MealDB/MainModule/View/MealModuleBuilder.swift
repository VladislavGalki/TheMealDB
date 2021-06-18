//
//  MealModuleBuilder.swift
//  MealDB
//
//  Created by Владислав Галкин on 18.06.2021.
//

import UIKit

class MealModuleBuilder: ModuleBuilder {
    
    func build() -> UIViewController {
        let mealListView = ListMealVIewController()
        let menuView = MenuViewController()
        let networkService = MealNetworkService()
        let presenter = ListMealPresenter(view: mealListView, networkService: networkService)
        mealListView.presenter = presenter
        let controller = ContainerViewController(mealListView: mealListView, menuView: menuView)
        return controller
    }
}
