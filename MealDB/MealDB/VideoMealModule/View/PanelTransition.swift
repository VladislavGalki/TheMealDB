//
//  PanelTransition.swift
//  MealDB
//
//  Created by Владислав Галкин on 09.07.2021.
//

import UIKit

class PanelTransition: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting ?? source)
    }
}
