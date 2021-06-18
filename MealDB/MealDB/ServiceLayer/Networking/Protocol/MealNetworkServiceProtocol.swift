//
//  MealNetworkServiceProtocol.swift
//  MealDB
//
//  Created by Владислав Галкин on 15.06.2021.
//

import UIKit

typealias GetMealAPIResponse = Result<GetMealsResponse, NetworkServiceError>

protocol MealNetworkServiceProtocol {
    func getPopularMeal(completion: @escaping (GetMealAPIResponse) -> Void)
    func getMealByCategory(with category: String , completion: @escaping (GetMealAPIResponse) -> Void)
    func downloadImageFromUrl(from url: String?, completion: @escaping (UIImage?) -> ())
}
