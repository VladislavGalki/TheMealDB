//
//  DetailMealPresenter.swift
//  MealDB
//
//  Created by Владислав Галкин on 22.06.2021.
//

import Foundation

protocol DetailMealViewProtocol: AnyObject {
    func succes()
    func failure(error: Error)
}

protocol DetailMealPresenterProtocol: AnyObject {
    init(view: DetailMealViewProtocol, networkService: MealNetworkServiceProtocol, mealModel: MealViewModel)
    var detailMealViewModel: DetailMealViewModel? { get set }
    func getDetailMealById()
}

final class DetailMealPresenter: DetailMealPresenterProtocol {
    
    weak var view: DetailMealViewProtocol?
    let networkService: MealNetworkServiceProtocol
    var detailMealViewModel: DetailMealViewModel? = nil
    
    var mealModel: MealViewModel
    
    required init(view: DetailMealViewProtocol, networkService: MealNetworkServiceProtocol, mealModel: MealViewModel) {
        self.view = view
        self.networkService = networkService
        self.mealModel = mealModel
    }
    
    func getDetailMealById() {
        networkService.getMealById(with: mealModel.id) { [weak self] response in
            guard let self = self else { return }
            self.process(response: response)
        }
    }
    
    private func process(response: GetMealDetailAPIResponse){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                self.convertToViewModel(data: data.meals)
                self.view?.succes()
            case .failure(let error):
                self.view?.failure(error: error)
            }
        }
    }
    
    private func convertToViewModel(data: [GetMealsDetailDataResponse]) {
        let group = DispatchGroup()
        
        data.forEach { item in
            group.enter()
            networkService.downloadImageFromUrl(from: item.strMealThumb) { [weak self] image in
                guard let self = self else { return }
                self.mealModel.mealImage = image
                group.leave()
            }
            
            group.wait()
            
            self.detailMealViewModel = DetailMealViewModel(id: item.idMeal, nameMeal: item.strMeal, strMealImage: item.strMealThumb, mealImage: self.mealModel.mealImage, instructions: item.strInstructions!)
        }
    }
}
