//
//  ErrorHelperView.swift
//  MealDB
//
//  Created by Владислав Галкин on 09.07.2021.
//

import UIKit

protocol ErrorHelperViewDelegate: AnyObject {
    func refreshData()
}

final class ErrorHelperView: UIView {
    
    weak var delegate: ErrorHelperViewDelegate?
    
    //MARK: - UI
    
    let errorTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Kefa", size: 25)
        label.text = "Error, please try again"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let refreshDataButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 20), forImageIn: .normal)
        button.addTarget(self, action: #selector(didTapToRefreshButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    convenience init(backgroundColor color: UIColor) {
        self.init(frame: .zero)
        backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    func configureView() {
        backgroundColor = UIColor(red: 224/255, green: 234/255, blue: 245/255, alpha: 1)
        addSubview(errorTextLabel)
        addSubview(refreshDataButton)
        
        NSLayoutConstraint.activate([
            errorTextLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            refreshDataButton.centerXAnchor.constraint(equalTo: errorTextLabel.centerXAnchor),
            refreshDataButton.topAnchor.constraint(equalTo: errorTextLabel.bottomAnchor, constant: 10)
        ])
    }
    
    //MARK: - Private methods
    
    @objc func didTapToRefreshButton() {
        delegate?.refreshData()
    }
}


