//
//  DetailMealView.swift
//  MealDB
//
//  Created by Владислав Галкин on 18.06.2021.
//

import UIKit

class DetailMealView: UIViewController {
    
    var presenter: DetailMealPresenterProtocol!
    
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
    
    override func viewDidLoad() {
        presenter.getDetailMealById()
        configure()
    }
    
   private func configure(){
        scrollView.addSubview(mealImageView)
        scrollView.addSubview(instructionsMeallLabel)
        scrollView.addSubview(detailInstructionsMeallLabel)
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
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
            
            detailInstructionsMeallLabel.topAnchor.constraint(equalTo: instructionsMeallLabel.bottomAnchor, constant: 10),
            detailInstructionsMeallLabel.leadingAnchor.constraint(equalTo: instructionsMeallLabel.leadingAnchor, constant: 5),
            detailInstructionsMeallLabel.trailingAnchor.constraint(lessThanOrEqualTo: mealImageView.trailingAnchor, constant: -5),
            detailInstructionsMeallLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        mealImageView.layer.cornerRadius = 10
    }
}

extension DetailMealView: DetailMealViewProtocol {
    func succes() {
        titleMealLabel.text = presenter.detailMealViewModel?.nameMeal
        mealImageView.image = presenter.detailMealViewModel?.mealImage
        detailInstructionsMeallLabel.text = presenter.detailMealViewModel?.instructions
        self.navigationItem.titleView = titleMealLabel
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
}
