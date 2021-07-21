//
//  ListMealScreen.swift
//  MealDBUITests
//
//  Created by Владислав Галкин on 21.07.2021.
//

import XCTest

struct ListMealScreen: Screen {
    
    var app: XCUIApplication
    
    func tapToTheCell() -> DetailMealScreen{
        let firstCell = app.cells.element(boundBy: 0)
        firstCell.tap()
        return DetailMealScreen(app: app)
    }
}
