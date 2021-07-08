//
//  DetailMeal+CoreDataProperties.swift
//  MealDB
//
//  Created by Владислав Галкин on 09.07.2021.
//
//

import Foundation
import CoreData


extension DetailMeal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DetailMeal> {
        return NSFetchRequest<DetailMeal>(entityName: "DetailMeal")
    }

    @NSManaged public var id: String?
    @NSManaged public var instructions: String?
    @NSManaged public var nameMeal: String?
    @NSManaged public var strMealImage: String?
    @NSManaged public var youtubeVideo: String?

}

extension DetailMeal : Identifiable {

}
