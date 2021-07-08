//
//  DetailMealDTO.swift
//  MealDB
//
//  Created by Владислав Галкин on 07.07.2021.
//

import Foundation
import UIKit

struct DetailMealDTO {
    let id: String
    let nameMeal: String
    let strMealImage: String
    let mealImage: UIImage
    let instructions: String
    let youtubeVideo: String
    
    init(with MO: DetailMeal) {
        self.id = MO.id ?? ""
        self.nameMeal = MO.nameMeal ?? ""
        self.strMealImage = MO.strMealImage ?? ""
        self.mealImage = UIImage()
        self.instructions = MO.instructions ?? ""
        self.youtubeVideo = MO.youtubeVideo ?? ""
    }
}
