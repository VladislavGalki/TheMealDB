//
//  HomeView.swift
//  MealDB
//
//  Created by Владислав Галкин on 12.06.2021.
//

import UIKit

protocol MealVIewControllerDelegate: AnyObject {
    func didTapMenuButton(category: MenuOptions?)
}

final class ListMealVIewController: UIViewController {
    
    // MARK: - Dependencies
    
    weak var delegate: MealVIewControllerDelegate?
    
    var it: [GetMealsDataResponse] = []
    
    // MARK: - UI
    
    lazy var backView: UIView = {
        let backView = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        backView.addGestureRecognizer(tapGesture)
        backView.backgroundColor = .white
        backView.alpha = 0.2
        backView.isHidden = true
        backView.isUserInteractionEnabled = true
        return backView
    }()
    
    lazy var buttonMenu: UIButton = {
        let buttonMenu = UIButton()
        buttonMenu.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        buttonMenu.tintColor = .black
        buttonMenu.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 25), forImageIn: .normal)
        buttonMenu.addTarget(self, action: #selector(didTapMenuButton), for: .touchUpInside)
        buttonMenu.translatesAutoresizingMaskIntoConstraints = false
        return buttonMenu
    }()

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.font = UIFont(name: "Kefa", size: 30)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.text = "Popular dishes"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    lazy var headerView: TopHeaderView = {
        let view = TopHeaderView(cornerRadius: 40, backgroundColor: UIColor(red: 254/255, green: 154/255, blue: 153/255, alpha: 1))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(MealTableViewCell.self, forCellReuseIdentifier: MealTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = view.backgroundColor
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Internal Properties
    
    let network = MealNetworkService()
    
    var selectedCategory: String = String() {
        willSet {
            prepareForFetchData(name: newValue)
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        headerView.addSubview(buttonMenu)
        headerView.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(backView)
        network.getPopularMeal(after: "") { result in
            self.process(result)
        }
       
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        backView.frame = .init(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        let topViewConstraint = [
            headerView.heightAnchor.constraint(equalToConstant: 220),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: -20),
           
            buttonMenu.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            buttonMenu.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            buttonMenu.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -15),
            
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -30)
        ]
        
        let tableViewConstraint = [
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(topViewConstraint)
        NSLayoutConstraint.activate(tableViewConstraint)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func process (_ response: GetMealAPIResponse) {
        DispatchQueue.main.async {
            switch response {
            case .success(let data):
                self.it.append(contentsOf: data.meals)
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Private methods
    
    private func prepareForFetchData(name: String){
        print(name)
    }
    
    @objc func didTapMenuButton() {
        backView.isHidden = false
        delegate?.didTapMenuButton(category: nil)
    }
    
    @objc func didTapView() {
        delegate?.didTapMenuButton(category: nil)
    }
}

//MARK: - UITableViewDelegate
extension ListMealVIewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}

//MARK: - UITableViewDataSource

extension ListMealVIewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return it.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MealTableViewCell.identifier, for: indexPath) as? MealTableViewCell else { return UITableViewCell() }
        cell.nameMealLabel.text = it[indexPath.row].strMeal
        return cell
    }
}
