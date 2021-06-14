//
//  ViewController.swift
//  MealDB
//
//  Created by Владислав Галкин on 12.06.2021.
//

import UIKit

enum MenuState {
    case opened
    case closed
}

final class ContainerViewController: UIViewController {
    
    // MARK: - Dependencies
    
    let mealView: ListMealVIewController
    let menuView: MenuViewController
    var centerController: UINavigationController!
    
    // MARK: - Init
    
    init(mealListView: ListMealVIewController, menuView: MenuViewController) {
        self.mealView = mealListView
        self.menuView = menuView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Properties
    
    private var menuState: MenuState = .closed
    private var isExpanded = false
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return isExpanded
    }
    
    // MARK: - Private methods
    
    private func configureController() {
        addChild(menuView)
        view.addSubview(menuView.view)
        didMove(toParent: self)
        menuView.delegate = self
        
        centerController = UINavigationController(rootViewController: mealView)
        view.addSubview(centerController.view)
        addChild(centerController)
        didMove(toParent: self)
        mealView.delegate = self
    }
    
    private func animateStatusBar() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
}

// MARK: - MealVIewControllerDelegate

extension ContainerViewController: MealVIewControllerDelegate {
    
    func didTapMenuButton(category: MenuOptions?) {
        switch menuState {
        case .closed:
            isExpanded = true
            animateStatusBar()
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.centerController.view.frame.origin.x = self.mealView.view.frame.size.width - 100
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .opened
                }
            }
        case .opened:
            isExpanded = false
            animateStatusBar()
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.centerController.view.frame.origin.x = 0
                self.mealView.backView.isHidden = true
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .closed
                    guard let selectedCategory = category else { return }
                    self?.mealView.selectedCategory = selectedCategory.description
                }
            }
        }
    }
}
