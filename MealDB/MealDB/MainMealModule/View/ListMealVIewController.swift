//
//  HomeView.swift
//  MealDB
//
//  Created by Владислав Галкин on 12.06.2021.
//

import UIKit

protocol MealViewControllerDelegate: AnyObject {
    func didTapMenuButton(category: MenuOptions?)
}

final class ListMealVIewController: UIViewController {
    
    // MARK: - Dependencies
    
    weak var delegate: MealViewControllerDelegate?
    var presenter: ListMealPresenterProtocol!
    private lazy var loadingQueue = OperationQueue()
    private lazy var loadingOperations = [IndexPath : DataLoadOperation]()
    
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
        titleLabel.text = selectedCategory
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
        tableView.prefetchDataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var errorView: ErrorHelperView = {
        let view = ErrorHelperView(backgroundColor: .white)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let loadIndicator: UIActivityIndicatorView = {
       let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Internal Properties
    
    var selectedCategory: String = "Popular dishes" {
        willSet {
            if selectedCategory != newValue {
                presenter.getMealByCategory(for: newValue)
            }
        }
    }
    
    var dataIsLoaded: Bool = false
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureIndicatorView()
        configure()
        presenter.getPopularMeal()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Private methods
    
    func configure() {
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        headerView.addSubview(buttonMenu)
        headerView.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(backView)
        
        backView.frame = .init(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        let topViewConstraint = [
            headerView.heightAnchor.constraint(equalToConstant: 220),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: -35),
            
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
    
    @objc func didTapMenuButton() {
        backView.isHidden = false
        delegate?.didTapMenuButton(category: nil)
    }
    
    @objc func didTapView() {
        delegate?.didTapMenuButton(category: nil)
    }
}

//MARK: - ListMealViewProtocol

extension ListMealVIewController: ListMealViewProtocol {
    
    func succes() {
        dataIsLoaded = true
        configureErrorView()
        titleLabel.text = selectedCategory
        tableView.reloadData()
    }
    
    func failure(error: NetworkServiceError) {
        dataIsLoaded = false
        switch error {
        case .networkError:
            configureErrorView()
        case .decodableError:
            configureErrorView()
        case .unknownError:
            print("Error unknownError")
        }
    }
}

//MARK: - ErrorHelperViewDelegate

extension ListMealVIewController: ErrorHelperViewDelegate {
    func refreshData() {
        if selectedCategory != "Popular dishes" {
            presenter.getMealByCategory(for: selectedCategory)
        } else {
            presenter.getPopularMeal()
        }
    }
    
    private func configureErrorView() {
        if dataIsLoaded {
            errorView.removeFromSuperview()
            configureIndicatorView()
        } else {
            view.addSubview(errorView)
            NSLayoutConstraint.activate([
                errorView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }
    
    private func configureIndicatorView() {
        if dataIsLoaded {
            loadIndicator.stopAnimating()
            loadIndicator.removeFromSuperview()
        } else {
            tableView.addSubview(loadIndicator)
            loadIndicator.startAnimating()
            NSLayoutConstraint.activate([
                loadIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
                loadIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
            ])
        }
    }
}

//MARK: - UITableViewDelegate

extension ListMealVIewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = presenter.mealModel[indexPath.row]
        var height = MealTableViewCell.heighForCell(item.nameMeal, width: tableView.frame.width)
        if height < 80 {
            height = 80
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = presenter.mealModel[indexPath.row]
        presenter.showDetailMeal(mealModel: model)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let cell = cell as? MealTableViewCell else { return }
        
        let item = presenter.mealModel[indexPath.row]
        
        let updateCellClosure: (MealViewModel?) -> () = { [weak self] model in
            guard let self = self else { return }
            cell.updateAppearanceFor(model)
            self.loadingOperations.removeValue(forKey: indexPath)
        }
        
        if let dataLoader = loadingOperations[indexPath] {
            if let model = dataLoader.mealModel {
                cell.updateAppearanceFor(model)
                loadingOperations.removeValue(forKey: indexPath)
            } else {
                dataLoader.loadingCompleteHandler = updateCellClosure
            }
        } else {
            let dataLoader = DataLoadOperation(item)
            dataLoader.loadingCompleteHandler = updateCellClosure
            loadingQueue.addOperation(dataLoader)
            loadingOperations[indexPath] = dataLoader
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let dataLoader = loadingOperations[indexPath] {
            dataLoader.cancel()
            loadingOperations.removeValue(forKey: indexPath)
        }
    }
}

//MARK: - UITableViewDataSource

extension ListMealVIewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.mealModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MealTableViewCell.identifier, for: indexPath) as? MealTableViewCell else { return UITableViewCell() }
        cell.updateAppearanceFor(.none)
        return cell
    }
}

//MARK: - UITableViewDataSourcePrefetching
extension ListMealVIewController: UITableViewDataSourcePrefetching{
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let item = presenter.mealModel[indexPath.row]
            
            let dataLoader = DataLoadOperation(item)
            loadingQueue.addOperation(dataLoader)
            loadingOperations[indexPath] = dataLoader
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let dataLoader = loadingOperations[indexPath] {
                dataLoader.cancel()
                loadingOperations.removeValue(forKey: indexPath)
            }
        }
    }
}
