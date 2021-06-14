//
//  MealTableViewCell.swift
//  MealDB
//
//  Created by Владислав Галкин on 13.06.2021.
//

import UIKit

final class MealTableViewCell: UITableViewCell {
    
    static let identifier = "MealCell"
    
    lazy var backView: UIView = {
        let backView = UIView(frame: .zero)
        backView.backgroundColor = UIColor(red: 255/255, green: 201/255, blue: 201/255, alpha: 1)
        backView.layer.cornerRadius = 8
        backView.translatesAutoresizingMaskIntoConstraints = false
        return backView
    }()
    
    lazy var imageMeal: UIImageView = {
        let imageMeal = UIImageView()
        imageMeal.translatesAutoresizingMaskIntoConstraints = false
        return imageMeal
    }()
    
    lazy var nameMealLabel: UILabel = {
        let nameMealLabel = UILabel()
        nameMealLabel.textAlignment = .left
        nameMealLabel.font = UIFont(name: "Kefa", size: 20)
        nameMealLabel.text = "Arrabiata"
        nameMealLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameMealLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        backView.addSubview(nameMealLabel)
        backView.addSubview(imageMeal)
        contentView.addSubview(backView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = UIColor.white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let backwardViewConstraint = [
            backView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            imageMeal.widthAnchor.constraint(equalToConstant: 55),
            imageMeal.topAnchor.constraint(equalTo: backView.topAnchor, constant: 8),
            imageMeal.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10),
            imageMeal.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -8),
            
            nameMealLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 16),
            nameMealLabel.leadingAnchor.constraint(equalTo: imageMeal.trailingAnchor, constant: 10),
        ]
        
        NSLayoutConstraint.activate(backwardViewConstraint)
        imageMeal.layer.cornerRadius = 10
    }
    
//    func configureCell(model: ) {
//
//    }
}
