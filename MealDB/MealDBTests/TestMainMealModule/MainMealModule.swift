//
//  MainMealModule.swift
//  MealDBTests
//
//  Created by Владислав Галкин on 18.07.2021.
//

import XCTest
@testable import MealDB

class MockViewMeal: ListMealViewProtocol {
    func succes() {
    }
    
    func failure(error: NetworkServiceError) {
    }
}

class MockNetworkService: MealNetworkServiceProtocol {
    
    var mealModel: GetMealsResponse!
    var detailMealModel: GetMealsDetailResponse!
    var downloadImage: UIImage!
    
    init() {}
    
    convenience init(model: GetMealsResponse?) {
        self.init()
        self.mealModel = model
    }
    
    convenience init(detailMeal: GetMealsDetailResponse?) {
        self.init()
        self.detailMealModel = detailMeal
    }
    
    convenience init(image: UIImage?) {
        self.init()
        self.downloadImage = image
    }
    
    func getPopularMeal(completion: @escaping (GetMealAPIResponse) -> Void) {
        if let model = mealModel {
            completion(.success(model))
        }else {
            completion(.failure(NetworkServiceError.networkError))
        }
    }
    
    func getMealByCategory(with category: String, completion: @escaping (GetMealAPIResponse) -> Void) {
        if let model = mealModel {
            completion(.success(model))
        }else {
            completion(.failure(NetworkServiceError.networkError))
        }
    }
    
    func getMealById(with id: String, completion: @escaping (GetMealDetailAPIResponse) -> Void) {
        if let model = detailMealModel {
            completion(.success(model))
        }else {
            completion(.failure(NetworkServiceError.networkError))
        }
    }
    
    func downloadImageFromUrl(from url: String?, completion: @escaping (UIImage?) -> ()) {
        if let image = downloadImage {
            completion(image)
        } else {
            completion(.none)
        }
    }
}


class MainMealModule: XCTestCase {
    
    var nav: UINavigationController!
    var assembly: AssemblyBuilder!
    var view: MockViewMeal!
    var networkService: MockNetworkService!
    var presenter: ListMealPresenter!
    var router: RouterProtocol!
    var coreDataStack: CoreDataStack!
    
    override func setUpWithError() throws {
        coreDataStack = CoreDataStack()
        nav = UINavigationController()
        assembly = AssemblyBuilder(coreDataStack: coreDataStack)
        router = Router(navigationController: nav, assemblyBuilder: assembly)
    }
    
    override func tearDownWithError() throws {
        nav = nil
        assembly = nil
        view = nil
        presenter = nil
        router = nil
        coreDataStack = nil
    }
    
    func testGetPopularMealResponseSucces() {
        let mealModel = GetMealsResponse(meals: [GetMealsDataResponse(idMeal: "0", strMeal: "Foo", strMealThumb: "Bar")])
        
        view = MockViewMeal()
        networkService = MockNetworkService(model: mealModel)
        presenter = ListMealPresenter(view: view, networkService: networkService, router: router)
        var catchMeal: GetMealsResponse?
        
        networkService.getPopularMeal { result in
            switch result {
            case .success(let data):
                catchMeal = data
            case .failure(let error):
                print(error)
            }
        }
        XCTAssertNotEqual(catchMeal?.meals.count, 0)
    }
    
    func testGetPolularMealResponseFailure() {
        
        view = MockViewMeal()
        networkService = MockNetworkService()
        presenter = ListMealPresenter(view: view, networkService: networkService, router: router)
        var catchError: NetworkServiceError?
        
        networkService.getPopularMeal { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                catchError = error
            }
        }
        XCTAssertNotNil(catchError)
    }
    
    func testGetMealByCategoryResponseSucces() {
        let mealModel = GetMealsResponse(meals: [GetMealsDataResponse(idMeal: "0", strMeal: "Foo", strMealThumb: "Bar")])
        let category = "Seafood"
        
        view = MockViewMeal()
        networkService = MockNetworkService(model: mealModel)
        presenter = ListMealPresenter(view: view, networkService: networkService, router: router)
        var catchMeal: GetMealsResponse?
        
        networkService.getMealByCategory(with: category) { result in
            switch result {
            case .success(let data):
                catchMeal = data
            case .failure(let error):
                print(error)
            }
        }
        XCTAssertNotEqual(catchMeal?.meals.count, 0)
    }
    
    func testGetMealByCategoryResponseFailure() {
        
        view = MockViewMeal()
        networkService = MockNetworkService()
        presenter = ListMealPresenter(view: view, networkService: networkService, router: router)
        let category = "Seafood"
        var catchError: NetworkServiceError?
        
        networkService.getMealByCategory(with: category) { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                catchError = error
            }
        }
        XCTAssertNotNil(catchError)
    }
    
    func testThatImageIsLoaded() {
        let image = UIImage(systemName: "pencil")
        let url = "www.google.com"
        
        view = MockViewMeal()
        networkService = MockNetworkService(image: image)
        presenter = ListMealPresenter(view: view, networkService: networkService, router: router)
        var downloadImage: UIImage?
        
        networkService.downloadImageFromUrl(from: url) { result in
            guard let result = result else { return }
            downloadImage = result
        }
        XCTAssertNotNil(downloadImage)
    }
    
    func testThatImageIsLoadedFalse() {
        let url = "www.google.com"
        
        view = MockViewMeal()
        networkService = MockNetworkService()
        presenter = ListMealPresenter(view: view, networkService: networkService, router: router)
        var downloadImage: UIImage?
        
        networkService.downloadImageFromUrl(from: url) { result in
            guard let result = result else { return }
            downloadImage = result
        }
        XCTAssertNil(downloadImage)
    }
    
    func testGetMealByIdResponseSucces() {
        let mealModel = GetMealsDetailResponse(meals: [GetMealsDetailDataResponse(idMeal: "0", strMeal: "Foo", strMealThumb: "Bar", strInstructions: "Baz", strYoutube: "youtoube.com")])
        let id = "0123"
        
        view = MockViewMeal()
        networkService = MockNetworkService(detailMeal: mealModel)
        presenter = ListMealPresenter(view: view, networkService: networkService, router: router)
        var catchMeal: GetMealsDetailResponse?
        
        networkService.getMealById(with: id) { result in
            switch result {
            case .success(let data):
                catchMeal = data
            case .failure(let error):
                print(error)
            }
        }
        XCTAssertNotEqual(catchMeal?.meals.count, 0)
    }
    
    func testGetMealByIdResponseFailure() {
        
        view = MockViewMeal()
        networkService = MockNetworkService()
        presenter = ListMealPresenter(view: view, networkService: networkService, router: router)
        let id = "0123"
        var catchError: NetworkServiceError?
        
        networkService.getMealById(with: id) { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                catchError = error
            }
        }
        XCTAssertNotNil(catchError)
    } 
}
