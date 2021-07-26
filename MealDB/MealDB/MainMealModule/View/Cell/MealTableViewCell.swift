//
//  MealTableViewCell.swift
//  MealDB
//
//  Created by Владислав Галкин on 13.06.2021.
//

import UIKit

final class MealTableViewCell: UITableViewCell {
    
    static let identifier = "MealCell"
    static let labelFont = UIFont(name: "Kefa", size: 20)!
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    let backView: UIView = {
        let backView = UIView(frame: .zero)
        backView.backgroundColor = UIColor(red: 255/255, green: 201/255, blue: 201/255, alpha: 1)
        backView.layer.cornerRadius = 8
        backView.translatesAutoresizingMaskIntoConstraints = false
        return backView
    }()
    
    lazy var imageMeal: UIImageView = {
        let imageMeal = UIImageView()
        imageMeal.contentMode = .scaleAspectFill
        imageMeal.clipsToBounds = true
        imageMeal.backgroundColor = backView.backgroundColor
        imageMeal.translatesAutoresizingMaskIntoConstraints = false
        return imageMeal
    }()
    
    lazy var nameMealLabel: UILabel = {
        let nameMealLabel = UILabel()
        nameMealLabel.numberOfLines = 0
        nameMealLabel.textAlignment = .left
        nameMealLabel.font = Self.labelFont
        nameMealLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameMealLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        backView.addSubview(nameMealLabel)
        imageMeal.addSubview(loadingIndicator)
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
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    override func updateConstraints() {
        let backwardViewConstraint = [
            backView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            imageMeal.widthAnchor.constraint(equalToConstant: 55),
            imageMeal.topAnchor.constraint(equalTo: backView.topAnchor, constant: 8),
            imageMeal.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10),
            imageMeal.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -8),
            
            loadingIndicator.leadingAnchor.constraint(equalTo: imageMeal.leadingAnchor, constant: 15),
            loadingIndicator.topAnchor.constraint(equalTo: imageMeal.topAnchor, constant: 15),
            
            nameMealLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 14),
            nameMealLabel.leadingAnchor.constraint(equalTo: imageMeal.trailingAnchor, constant: 10),
            nameMealLabel.trailingAnchor.constraint(lessThanOrEqualTo: backView.trailingAnchor, constant: -5),
        ]
        NSLayoutConstraint.activate(backwardViewConstraint)
        imageMeal.layer.cornerRadius = 10
        
        super.updateConstraints()
    }
    
    func updateAppearanceFor(_ model: MealViewModel?) {
        DispatchQueue.main.async {
            self.displayImage(model)
        }
    }
    
    private func displayImage(_ model: MealViewModel?) {
        if let model = model, let image = model.mealImage {
            imageMeal.image = image
            nameMealLabel.text = model.nameMeal
            loadingIndicator.stopAnimating()
        } else {
            loadingIndicator.startAnimating()
            imageMeal.image = .none
            nameMealLabel.text = .none
        }
    }
    
    static func heighForCell (_ text: String, width: CGFloat) -> CGFloat {
        
        let attributedString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: labelFont])
        let rect = attributedString.boundingRect(with:
                                                    CGSize(width: width, height: .greatestFiniteMagnitude),
                                                 options: .usesLineFragmentOrigin,
                                                 context: nil)
        return ceil(rect.size.height + (rect.height + 10))
    }
}


