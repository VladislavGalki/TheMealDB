//
//  TopViewHeader.swift
//  MealDB
//
//  Created by Владислав Галкин on 12.06.2021.
//

import UIKit

final class TopHeaderView: UIView {
    convenience init(cornerRadius radius: CGFloat, backgroundColor color: UIColor) {
        self.init(frame: .zero)
        layer.cornerRadius = radius
        backgroundColor = color
    }
}
