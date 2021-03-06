//
//  LaunchScreenTest.swift
//  MealDBTests
//
//  Created by Владислав Галкин on 18.07.2021.
//

import XCTest
@testable import MealDB

class MockUserDefaults {
    
    static let standart = MockUserDefaults()
    private init() {}
    
    
}

class MockViewLaunch: LaunchScreenViewProtocol {
    func presentUserWithAnimation(is userNameExist: Bool, userName: String) {
    }
}

class LaunchScreenTest: XCTestCase {
    
    var nav: UINavigationController!
    var assembly: AssemblyBuilder!
    var view: MockViewLaunch!
    var presenter: LaunchScreenPresenter!
    var router: RouterProtocol!
    var coreDataStack: CoreDataStack!
    var userDefaults: UserDefaults!
    var userNameKey: String!
    
    override func setUpWithError() throws {
        coreDataStack = CoreDataStack()
        nav = UINavigationController()
        assembly = AssemblyBuilder(coreDataStack: coreDataStack)
        router = Router(navigationController: nav, assemblyBuilder: assembly)
        view = MockViewLaunch()
        presenter = LaunchScreenPresenter(view: view, router: router)
        userNameKey = "userName"
    }

    override func tearDownWithError() throws {
        nav = nil
        assembly = nil
        view = nil
        presenter = nil
        router = nil
        coreDataStack = nil
        userDefaults = nil
    }
    
    func testThatUserNameIsSaved() {
        let user = "Foo"
        presenter.saveUserName(for: user)

        let userName = (UserDefaults.standard.object(forKey: userNameKey) as! String)
        
        XCTAssertEqual(user, userName)
    }
}
