//
//  DetailMealCoreDataService.swift
//  MealDB
//
//  Created by Владислав Галкин on 07.07.2021.
//

import Foundation
import CoreData

protocol DetailMealCoreDataServiceProtocol: AnyObject {
    func create(detailMealModel: [DetailMealViewModel])
    func getModelMeal(with predicate: NSPredicate) -> [DetailMealDTO]
    init(coreDataStack: CoreDataStack)
}

final class DetailMealCoreDataService: DetailMealCoreDataServiceProtocol {
    
    private var coreDataStack: CoreDataStack
    
    required init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    private func fetchRequest(for meal: DetailMealViewModel) -> NSFetchRequest<DetailMeal> {
        let request = NSFetchRequest<DetailMeal>(entityName: "DetailMeal")
        request.predicate = .init(format: "id == %@", meal.id)
        return request
    }
    
    func create(detailMealModel: [DetailMealViewModel]) {
        let context = coreDataStack.backgroundContext
        context.performAndWait {
            detailMealModel.forEach  {
                if let modelMeal = try? self.fetchRequest(for: $0).execute().first {
                    modelMeal.id = $0.id
                    modelMeal.nameMeal = $0.nameMeal
                    modelMeal.strMealImage = $0.strMealImage
                    modelMeal.instructions = $0.instructions
                    modelMeal.youtubeVideo = $0.youtubeVideo
                } else {
                    let modelMeal = DetailMeal(context: context)
                    modelMeal.id = $0.id
                    modelMeal.nameMeal = $0.nameMeal
                    modelMeal.strMealImage = $0.strMealImage
                    modelMeal.instructions = $0.instructions
                    modelMeal.youtubeVideo = $0.youtubeVideo
                }
            }
            try? context.save()
        }
    }
    
    func getModelMeal(with predicate: NSPredicate) -> [DetailMealDTO] {
        let context = coreDataStack.mainContext
        var result = [DetailMealDTO]()
        
        let request = NSFetchRequest<DetailMeal>(entityName: "DetailMeal")
        request.predicate = predicate
        context.performAndWait {
            guard let modelMeal = try? request.execute() else { return }
            result = modelMeal.map { DetailMealDTO(with: $0) }
        }
        return result
    }
}
