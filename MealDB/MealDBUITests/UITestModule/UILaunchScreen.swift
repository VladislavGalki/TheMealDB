//
//  UILaunchScreen.swift
//  MealDBUITests
//
//  Created by Владислав Галкин on 21.07.2021.
//

import XCTest

class UILaunchScreen: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testLoginFlow() {
       let listScreen = LoginScreen(app: app)
            .typeUserName(userName: "Foo")
            .tapKeyboardReturn()
        
        listScreen.tapToTheCell()
            .goBackToTheListMeal()
    }
}
