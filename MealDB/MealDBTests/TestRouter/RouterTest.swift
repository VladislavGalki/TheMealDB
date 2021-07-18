//
//  RouterTest.swift
//  MealDBTests
//
//  Created by Владислав Галкин on 18.07.2021.
//

import XCTest
@testable import MealDB

class MockNavigationController: UINavigationController {
    var presentedVC: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.presentedVC = viewController
        super.pushViewController(viewController, animated: animated)
    }
}

class RouterTest: XCTestCase {

    var router: RouterProtocol!
    var navigationController = MockNavigationController()
    var assembly = AssemblyBuilder(coreDataStack: CoreDataStack())
    
    override func setUpWithError() throws {
        router = Router(navigationController: navigationController, assemblyBuilder: assembly)
    }

    override func tearDownWithError() throws {
        router = nil
    }
    
    func testThatRouterPresentedDetailViewCorrectly() {
        let model = MealViewModel(id: "0123", nameMeal: "Foo", strMealImage: "Bar", mealImage: .none)
        router.showDetailMealController(mealModel: model)
        
        let detailScreenVC = navigationController.presentedVC
        
        XCTAssertTrue(detailScreenVC is DetailMealView)
    }
    
}
