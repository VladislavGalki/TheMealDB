//
//  UIImageExtension.swift
//  MealDB
//
//  Created by Владислав Галкин on 16.07.2021.
//

import UIKit

extension UIImage {
    func imageResized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
