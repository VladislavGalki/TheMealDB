//
//  ListMealPresenter.swift
//  MealDB
//
//  Created by Владислав Галкин on 16.06.2021.
//

import Foundation

protocol ListMealViewProtocol: AnyObject {
    func succes()
    func failure(error: Error)
}

protocol ListMealPresenterProtocol: AnyObject {
    init(view: ListMealViewProtocol, networkService: MealNetworkServiceProtocol)
    var mealModel: [GetMealsDataResponse] { get set }
    func getPopularMeal()
    func getMealByCategory(for category: String)
}

final class ListMealPresenter: ListMealPresenterProtocol {
    
    var mealModel = [GetMealsDataResponse]()
    
    weak var view: ListMealViewProtocol?
    let networkService: MealNetworkServiceProtocol
    
    init(view: ListMealViewProtocol, networkService: MealNetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
    }
    
    func getPopularMeal() {
        networkService.getPopularMeal { [weak self] response in
            guard let self = self else { return }
            self.process(response: response)
        }
    }
    
    func getMealByCategory(for category: String) {
        networkService.getMealByCategory(with: category) { [weak self] response in
            guard let self = self else { return }
            self.process(response: response)
        }
    }
    
    private func process(response: GetMealAPIResponse){
        DispatchQueue.main.async {
            switch response {
            case .success(let data):
                self.mealModel = data.meals
                self.view?.succes()
            case .failure(let error):
                self.view?.failure(error: error)
            }
        }
    }
}
