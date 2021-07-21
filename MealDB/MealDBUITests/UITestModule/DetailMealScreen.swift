//
//  DetailMealScreen.swift
//  MealDBUITests
//
//  Created by Владислав Галкин on 21.07.2021.
//

import XCTest

struct DetailMealScreen: Screen {
    
    var app: XCUIApplication
    
    func goBackToTheListMeal() {
        let navgationBar = app.navigationBars.firstMatch
        let backButton = navgationBar.buttons["Back"]
        backButton.tap()
    }
}
