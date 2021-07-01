//
//  GetMealsDetailResponce.swift
//  MealDB
//
//  Created by Владислав Галкин on 25.06.2021.
//

import Foundation

struct GetMealsDetailResponse: Decodable {
    let meals: [GetMealsDetailDataResponse]
}

struct GetMealsDetailDataResponse: Decodable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    let strInstructions: String?
    let strYoutube: String?
}



