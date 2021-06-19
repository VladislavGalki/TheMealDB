//
//  ListMealPresenter.swift
//  MealDB
//
//  Created by Владислав Галкин on 16.06.2021.
//

import Foundation
import UIKit

protocol ListMealViewProtocol: AnyObject {
    func succes()
    func failure(error: Error)
}

protocol ListMealPresenterProtocol: AnyObject {
    init(view: ListMealViewProtocol, networkService: MealNetworkServiceProtocol)
    var mealModel: [MealViewModel] { get set }
    func getPopularMeal()
    func getMealByCategory(for category: String)
}

final class ListMealPresenter: ListMealPresenterProtocol {
    
    var mealModel = [MealViewModel]()
    
    weak var view: ListMealViewProtocol?
    let networkService: MealNetworkServiceProtocol
    
    init(view: ListMealViewProtocol, networkService: MealNetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
        getPopularMeal()
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
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                self.convertToViewModel(data: data)
                self.view?.succes()
            case .failure(let error):
                self.view?.failure(error: error)
            }
        }
    }
    
    private func convertToViewModel(data: GetMealsResponse) {
        self.mealModel = data.meals.compactMap { item in
            return MealViewModel(id: item.idMeal, nameMeal: item.strMeal, strMealImage: item.strMealThumb, mealImage: .none)
        }
    }
}
