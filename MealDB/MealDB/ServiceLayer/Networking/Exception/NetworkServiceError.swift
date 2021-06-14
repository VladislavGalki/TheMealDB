//
//  NetworkServiceError.swift
//  MealDB
//
//  Created by Владислав Галкин on 15.06.2021.
//

import Foundation

enum NetworkServiceError: Error {
    case networkError
    case decodableError
    case unknownError
}
