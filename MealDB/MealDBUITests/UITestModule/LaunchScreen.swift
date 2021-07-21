//
//  LaunchScreen.swift
//  MealDBUITests
//
//  Created by Владислав Галкин on 21.07.2021.
//

import XCTest

protocol Screen {
    var app: XCUIApplication { get }
}

struct LoginScreen: Screen {
    var app: XCUIApplication
    
    private enum Identifier{
        static let userName = "Enter your name"
    }
    
    func typeUserName(userName: String ) -> Self {
        let user = app.textFields[Identifier.userName]
        user.tap()
        user.typeText(userName)
        return self
    }
    
    func tapKeyboardReturn() -> ListMealScreen {
        app.keyboards.buttons["Return"].tap()
        return ListMealScreen(app: app)
    }
}
