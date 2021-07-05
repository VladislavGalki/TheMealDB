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
    
    let mealListView: ListMealVIewController
    let menuView: MenuViewController
    
    // MARK: - Init
    
    init(mealListView: ListMealVIewController, menuView: MenuViewController) {
        self.mealListView = mealListView
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
        configureMealController()
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return isExpanded
    }
    
    // MARK: - Private methods
    
    private func configureMealController() {
        view.addSubview(mealListView.view)
        addChild(mealListView)
        mealListView.didMove(toParent: self)
        mealListView.delegate = self
    }
    
    private func configureMenuController() {
            view.insertSubview(menuView.view, at: 0)
            addChild(menuView)
            menuView.didMove(toParent: self)
            menuView.delegate = self
    }
    
    private func destroyMenuController(){
        menuView.willMove(toParent: nil)
        menuView.view.removeFromSuperview()
        menuView.removeFromParent()
    }

    private func animateStatusBar() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
}

// MARK: - MealVIewControllerDelegate

extension ContainerViewController: MealViewControllerDelegate {
    
    func didTapMenuButton(category: MenuOptions?) {
        
        if !isExpanded {
            configureMenuController()
        }
        
        isExpanded = !isExpanded
        showMenuController(shouldExpand: isExpanded, category: category)
    }
    
    func showMenuController(shouldExpand: Bool, category: MenuOptions?) {
        if shouldExpand {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.mealListView.view.frame.origin.x = self.mealListView.view.frame.size.width - 100
            }, completion: nil)
        }else{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.mealListView.view.frame.origin.x = 0
            } completion: { [weak self] done in
                if done {
                    self?.destroyMenuController()
                    self?.mealListView.backView.isHidden = true
                    guard let selectedCategory = category else { return }
                    self?.mealListView.selectedCategory = selectedCategory.description
                }
            }
        }
        animateStatusBar()
    }
}
