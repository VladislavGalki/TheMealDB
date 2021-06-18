//
//  GetMealsResponse.swift
//  MealDB
//
//  Created by Владислав Галкин on 14.06.2021.
//

import UIKit

struct GetMealsResponse: Decodable {
    let meals: [GetMealsDataResponse]
}

struct GetMealsDataResponse: Decodable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
}
