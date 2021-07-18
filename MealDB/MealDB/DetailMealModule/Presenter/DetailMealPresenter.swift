//
//  DetailMealPresenter.swift
//  MealDB
//
//  Created by Владислав Галкин on 22.06.2021.
//

import UIKit

protocol DetailMealViewProtocol: AnyObject {
    func succes()
    func failure(error: NetworkServiceError)
}

protocol DetailMealPresenterProtocol: AnyObject {
    init(view: DetailMealViewProtocol, networkService: MealNetworkServiceProtocol, mealModel: MealViewModel, coreDataService: DetailMealCoreDataServiceProtocol, router: RouterProtocol)
    var detailMealViewModel: [DetailMealViewModel] { get set }
    func getDetailMealById()
    func presentVideoMealController()
}

final class DetailMealPresenter: DetailMealPresenterProtocol {
    
    weak var view: DetailMealViewProtocol?
    let networkService: MealNetworkServiceProtocol
    let coreDataService: DetailMealCoreDataServiceProtocol
    var detailMealViewModel = [DetailMealViewModel]()
    var router: RouterProtocol?
    
    var mealModel: MealViewModel
    var downloadImage: UIImage?
    
    required init(view: DetailMealViewProtocol, networkService: MealNetworkServiceProtocol, mealModel: MealViewModel, coreDataService: DetailMealCoreDataServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.mealModel = mealModel
        self.coreDataService = coreDataService
        self.router = router
    }
    
    func getDetailMealById() {
        let result = coreDataService.getModelMeal(with: NSPredicate.init(format: "id == %@", mealModel.id))
        if !result.isEmpty {
            convertDataToViewModel(data: result)
            self.view?.succes()
        }else {
            networkService.getMealById(with: mealModel.id) { [weak self] response in
                guard let self = self else { return }
                self.process(response: response)
            }
        }
    }
    
    private func process(response: GetMealDetailAPIResponse){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                self.prepareToPresent(data: data.meals)
            case .failure(let error):
                self.view?.failure(error: error)
            }
        }
    }
    
    private func prepareToPresent(data: [GetMealsDetailDataResponse]) {
        let group = DispatchGroup()
        
        self.detailMealViewModel = data.compactMap { item in
            group.enter()
            networkService.downloadImageFromUrl(from: item.strMealThumb) { [weak self] image in
                guard let self = self else { return }
                self.downloadImage = image
                group.leave()
            }
            
            group.wait()
            let resizebleImage = downloadImage?.imageResized(to: CGSize(width: 400, height: 400))
            return DetailMealViewModel(id: item.idMeal, nameMeal: item.strMeal, strMealImage: item.strMealThumb, mealImage: resizebleImage, instructions: item.strInstructions ?? "", youtubeVideo: item.strYoutube ?? "")
        }
        DispatchQueue.global().async {
            self.coreDataService.create(detailMealModel: self.detailMealViewModel)
        }
        self.view?.succes()
    }
    
    private func convertDataToViewModel(data: [DetailMealDTO]) {
        let group = DispatchGroup()
        
        self.detailMealViewModel = data.compactMap { item in
            
            group.enter()
            networkService.downloadImageFromUrl(from: item.strMealImage) { [weak self] image in
                guard let self = self else { return }
                self.downloadImage = image
                group.leave()
            }
            
            group.wait()
            let resizebleImage = downloadImage?.imageResized(to: CGSize(width: 400, height: 400))
            return DetailMealViewModel(id: item.id, nameMeal: item.nameMeal, strMealImage: item.strMealImage, mealImage: resizebleImage, instructions: item.instructions, youtubeVideo: item.youtubeVideo)
        }
    }
    
    func presentVideoMealController() {
        let urlPath = detailMealViewModel[0].youtubeVideo
        if !urlPath.isEmpty {
            router?.showVideoMealController(videoUrlPath: urlPath)
        }
    }
    
    private func resizeImage() -> UIImage {
        let scaledImageSize = CGSize(width: 350, height: 180)
        let render = UIGraphicsImageRenderer(size: scaledImageSize)
        let scaledImage = render.image { _ in
            downloadImage?.draw(in: CGRect(origin: .zero, size: scaledImageSize))
        }
        return scaledImage
    }
}
