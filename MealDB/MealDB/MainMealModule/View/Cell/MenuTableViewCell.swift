//
//  MenuTableViewCell.swift
//  MealDB
//
//  Created by Владислав Галкин on 14.06.2021.
//


import UIKit

final class MenuTableViewCell: UITableViewCell {
    
    static let identifier = "MenuCell"
    
    lazy var mealNameLabel: UILabel = {
        let mealNameLabel = UILabel()
        mealNameLabel.font = UIFont(name: "Kefa", size: 20)
        mealNameLabel.textAlignment = .left
        mealNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return mealNameLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(red: 224/255, green: 234/255, blue: 245/255, alpha: 1)
        contentView.addSubview(mealNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            mealNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            mealNameLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            mealNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configureCell(model: MenuOptions?) {
        guard let model = model else { return }
        mealNameLabel.text = model.description
    }
}
