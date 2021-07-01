//
//  Constants.swift
//  MealDB
//
//  Created by Владислав Галкин on 15.06.2021.
//

import Foundation

enum Constants {
    
    enum MealAPIMethods {
        static let getPopularMeal = "https://themealdb.com/api/json/v1/1/random.php"
        static let getMealByCategory = "https://themealdb.com/api/json/v1/1/filter.php"
        static let getMealById = "https://themealdb.com/api/json/v1/1/lookup.php"
    }
    
}
