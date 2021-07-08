//
//  CoreDataStack.swift
//  MealDB
//
//  Created by Владислав Галкин on 06.07.2021.
//

import Foundation
import CoreData

final class CoreDataStack {

    private let coordinator: NSPersistentStoreCoordinator
    let mainContext: NSManagedObjectContext
    let backgroundContext: NSManagedObjectContext

    private let objectModel: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "CoreDataMeal", withExtension: "momd") else {
            fatalError("CoreData MOMD is nil")
        }
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("CoreData MOMD is nil")
        }
        return model
    }()

    init() {

        guard let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            fatalError("Documents is nil")
        }
        let url = URL(fileURLWithPath: documentsPath).appendingPathComponent("CoreDataMeal.sqlite")
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel)

        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: url,
                                               options: [NSMigratePersistentStoresAutomaticallyOption: true,
                                                         NSInferMappingModelAutomaticallyOption: true])
        } catch {
            fatalError()
        }
        
        self.coordinator = coordinator
        self.mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.mainContext.persistentStoreCoordinator = coordinator

        self.backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.backgroundContext.parent = self.mainContext

    }

    func deleteAll() {

        let fetchRequest = NSFetchRequest<DetailMeal>(entityName: "DetailMeal")
        backgroundContext.performAndWait {
            let cards = try? fetchRequest.execute()
            cards?.forEach {
                backgroundContext.delete($0)
            }
            try? backgroundContext.save()
        }

    }
}
