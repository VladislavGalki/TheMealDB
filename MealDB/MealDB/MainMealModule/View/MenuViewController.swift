//
//  MenuView.swift
//  MealDB
//
//  Created by Владислав Галкин on 12.06.2021.
//

import UIKit

final class MenuViewController: UIViewController {
    
    // MARK: - Dependencies
    
    weak var delegate: MealViewControllerDelegate?
    
    // MARK: - UI
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.font = UIFont(name: "Kefa", size: 30)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.text = "The Meal"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel(frame: .zero)
        descriptionLabel.font = UIFont(name: "Kefa", size: 19)
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .left
        descriptionLabel.text = "Recipes from around the world"
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    lazy var descriptionLabel1: UILabel = {
        let descriptionLabel = UILabel(frame: .zero)
        descriptionLabel.font = UIFont(name: "Kefa", size: 13)
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .left
        descriptionLabel.text = "Seafood"
        descriptionLabel.isUserInteractionEnabled = true
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = view.backgroundColor
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var headerView: TopHeaderView = {
        let view = TopHeaderView(cornerRadius: 40, backgroundColor: UIColor(red: 34/255, green: 37/255, blue: 41/255, alpha: 1))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 224/255, green: 234/255, blue: 245/255, alpha: 1)
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(descriptionLabel)
        view.addSubview(tableView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let topViewConstraint = [
            headerView.heightAnchor.constraint(equalToConstant: 220),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -4),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -97.5),
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: -20),
            
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 80),
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 70),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            descriptionLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 13),
        ]
        
        let tableViewConstraint = [
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -4),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -97.5),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(topViewConstraint)
        NSLayoutConstraint.activate(tableViewConstraint)
        headerView.layer.cornerRadius = 40
    }
}

// MARK: - UITableViewDelegate

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = MenuOptions(rawValue: indexPath.row)
        delegate?.didTapMenuButton(category: selectedCategory)
    }
}

// MARK: - UITableViewDataSource

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath) as? MenuTableViewCell else { return UITableViewCell() }
        let menuOptions = MenuOptions(rawValue: indexPath.row)
        cell.configureCell(model: menuOptions)
        return cell
    }
}
