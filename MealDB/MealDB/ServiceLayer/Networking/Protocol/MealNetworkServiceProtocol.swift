//
//  MealNetworkServiceProtocol.swift
//  MealDB
//
//  Created by Владислав Галкин on 15.06.2021.
//

import Foundation

typealias GetMealAPIResponse = Result<GetMealsResponse, NetworkServiceError>

protocol MealNetworkServiceProtocol {
    func getPopularMeal(after cursor: String?, completion: @escaping (GetMealAPIResponse) -> Void)
    //func loadImage(imageUrl: String, completion: @escaping (Data?) -> Void)
}
