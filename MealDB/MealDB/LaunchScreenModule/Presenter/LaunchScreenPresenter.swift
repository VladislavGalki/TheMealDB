//
//  LaunchScreenPresenter.swift
//  MealDB
//
//  Created by Владислав Галкин on 04.07.2021.
//

import Foundation

protocol LaunchScreenViewProtocol: AnyObject {
    func presentAnimationUser(is userNameExist: Bool, userName: String)
}

protocol LaunchScreenPresenterProtocol: AnyObject {
    init(view: LaunchScreenViewProtocol, router: RouterProtocol)
    func presentMealViewController()
    func getUserName()
    func saveUserName(for name: String)
}

final class LaunchScreenPresenter: LaunchScreenPresenterProtocol {
    
    weak var view: LaunchScreenViewProtocol?
    var router: RouterProtocol?
    private var userNameKey = "userName"
    
    init(view: LaunchScreenViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func presentMealViewController() {
        router?.mainMealViewController()
    }
    
    func getUserName() {
        if let userName = UserDefaults.standard.object(forKey: userNameKey) {
            view?.presentAnimationUser(is: true, userName: (userName as! String))
        }else {
            view?.presentAnimationUser(is: false, userName: "")
        }
    }
    
    func saveUserName(for name: String) {
        UserDefaults.standard.setValue(name, forKey: userNameKey)
    }
}
