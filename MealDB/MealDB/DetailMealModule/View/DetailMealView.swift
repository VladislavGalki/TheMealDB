//
//  DetailMealView.swift
//  MealDB
//
//  Created by Владислав Галкин on 18.06.2021.
//

import UIKit

class DetailMealView: UIViewController {
    
    // MARK: - Dependencies
    
    var presenter: DetailMealPresenterProtocol!
   
    // MARK: - UI
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 0
        scrollView.maximumZoomScale = 0
        scrollView.backgroundColor = UIColor(red: 224/255, green: 234/255, blue: 245/255, alpha: 1)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let titleMealLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont(name: "Kefa", size: 18)!
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    let mealImageView: UIImageView = {
        let mealImage = UIImageView()
        mealImage.backgroundColor = UIColor(red: 224/255, green: 234/255, blue: 245/255, alpha: 1)
        mealImage.translatesAutoresizingMaskIntoConstraints = false
        mealImage.layer.masksToBounds = true
        return mealImage
    }()
    
    let instructionsMeallLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "Instructions:"
        label.font = UIFont(name: "Kefa", size: 24)!
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let detailInstructionsMeallLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont(name: "Kefa", size: 20)!
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let watchVideoButton: UIButton = {
       let button = UIButton()
        button.setTitle("(Watch video)", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(didTapToWatchVideo), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        presenter.getDetailMealById()
        configure()
    }
    
    func configure(){
        scrollView.addSubview(mealImageView)
        scrollView.addSubview(instructionsMeallLabel)
        scrollView.addSubview(watchVideoButton)
        scrollView.addSubview(detailInstructionsMeallLabel)
        view.addSubview(scrollView)
        
        let scrollViewConstraint = [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            mealImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            mealImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            mealImageView.widthAnchor.constraint(equalToConstant: 350),
            mealImageView.heightAnchor.constraint(equalToConstant: 180),
            
            instructionsMeallLabel.topAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: 15),
            instructionsMeallLabel.leadingAnchor.constraint(equalTo: mealImageView.leadingAnchor, constant: 10),
            
            watchVideoButton.topAnchor.constraint(equalTo: instructionsMeallLabel.topAnchor),
            watchVideoButton.trailingAnchor.constraint(equalTo: mealImageView.trailingAnchor),
            watchVideoButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 83),
            
            detailInstructionsMeallLabel.topAnchor.constraint(equalTo: instructionsMeallLabel.bottomAnchor, constant: 10),
            detailInstructionsMeallLabel.leadingAnchor.constraint(equalTo: instructionsMeallLabel.leadingAnchor, constant: 5),
            detailInstructionsMeallLabel.trailingAnchor.constraint(lessThanOrEqualTo: mealImageView.trailingAnchor, constant: -5),
            detailInstructionsMeallLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(scrollViewConstraint)
        mealImageView.layer.cornerRadius = 10
    }
    
    //MARK: - Private methods
    
    @objc func didTapToWatchVideo() {
        presenter.presentVideoMealController()
    }
}

// MARK: - DetailMealViewProtocol

extension DetailMealView: DetailMealViewProtocol {
    func succes() {
        let model = presenter.detailMealViewModel[0]
        titleMealLabel.text = model.nameMeal
        mealImageView.image = model.mealImage
        detailInstructionsMeallLabel.text = model.instructions
        self.navigationItem.titleView = titleMealLabel
        
        if !model.youtubeVideo.isEmpty {
            watchVideoButton.isHidden = false
        }
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
}

extension DetailMealView: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
