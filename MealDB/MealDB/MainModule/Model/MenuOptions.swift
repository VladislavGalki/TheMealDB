//
//  MenuOption.swift
//  MealDB
//
//  Created by Владислав Галкин on 14.06.2021.
//

import Foundation

enum MenuOptions: Int, CustomStringConvertible, CaseIterable {
    case Breakfast
    case Beef
    case Chiken
    case Pork
    case Pasta
    case Seafood
    case Vegetarian
    case Dessert
    
    var description: String {
        switch self {
        case .Breakfast:
            return "Breakfast"
        case .Beef:
            return "Beef"
        case .Chiken:
            return "Chiken"
        case .Pork:
            return "Pork"
        case .Pasta:
            return "Pasta"
        case .Seafood:
            return "Seafood"
        case .Vegetarian:
            return "Vegetarian"
        case .Dessert:
            return "Dessert"
        }
    }
}
