//
//  LaunchScreenView.swift
//  MealDB
//
//  Created by Владислав Галкин on 04.07.2021.
//

import UIKit

final class LaunchScreenView: UIViewController {
    
    // MARK: - Dependencies
    
    var presenter: LaunchScreenPresenterProtocol!
    
    // MARK: - UI
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "The Meal"
        label.textAlignment = .center
        label.font = UIFont(name: "Kefa", size: 34)!
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageMeal: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "imageLogo")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        return image
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your name"
        textField.textAlignment = .center
        textField.textColor = .black
        textField.backgroundColor = UIColor(red: 255/255, green: 201/255, blue: 201/255, alpha: 1)
        textField.layer.opacity = 0
        textField.isHidden = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = UIFont(name: "Kefa", size: 25)!
        label.textColor = .black
        label.textAlignment = .center
        label.layer.opacity = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 224/255, green: 234/255, blue: 245/255, alpha: 1)
        configure()
        presenter.getUserName()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func configure() {
        view.addSubview(imageMeal)
        view.addSubview(titleLabel)
        view.addSubview(textField)
        view.addSubview(userNameLabel)
        
        let viewConstraint = [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            imageMeal.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageMeal.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageMeal.widthAnchor.constraint(equalToConstant: view.frame.width),
            imageMeal.heightAnchor.constraint(equalToConstant: view.frame.height),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            textField.widthAnchor.constraint(equalToConstant: 280),
            textField.heightAnchor.constraint(equalToConstant: 35),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            userNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            userNameLabel.widthAnchor.constraint(equalToConstant: 280),
            userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(viewConstraint)
        textField.layer.cornerRadius = 5
    }
    
    //MARK: - private func
    
    private func presentMainView() {
        presenter.presentMealViewController()
    }
    
    private func presentationWithAnimation(userNameExist: Bool ,userName: String) {
        if userNameExist {
            UIView.animate(withDuration: 2, delay: 0.5, options: .curveEaseInOut) { [self] in
                userNameLabel.text = "Welcome \(userName)"
                userNameLabel.isHidden = false
                userNameLabel.layer.opacity = 1
            } completion: { done in
                self.presentMainView()
            }
        }else{
            UIView.animate(withDuration: 1.5, delay: 0.2, options: .curveEaseInOut, animations: { [self] in
                textField.isHidden = false
                textField.layer.opacity = 1
            }, completion: nil)
        }
    }
}

//MARK: - LaunchScreenViewProtocol
extension LaunchScreenView: LaunchScreenViewProtocol {
    func presentAnimationUser(is userNameExist: Bool, userName: String) {
        presentationWithAnimation(userNameExist: userNameExist, userName: userName)
    }
}

//MARK: - UITextFieldDelegate
extension LaunchScreenView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let userName = textField.text else { return }
        presenter.saveUserName(for: userName)
        presentMainView()
    }
}
