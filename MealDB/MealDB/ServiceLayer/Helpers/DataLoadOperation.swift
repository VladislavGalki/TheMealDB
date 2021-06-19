//
//  DataLoadOperation.swift
//  MealDB
//
//  Created by Владислав Галкин on 19.06.2021.
//

import Foundation
import UIKit.UIImage

let cacheModel = NSCache<AnyObject, AnyObject>()

class DataLoadOperation: Operation {
    
    let networkService: MealNetworkServiceProtocol = MealNetworkService()
    var mealModel: MealViewModel?
    var loadingCompleteHandler: ((MealViewModel) -> Void)?
    private var _mealModel: MealViewModel
    
    init(_ mealModel: MealViewModel) {
        _mealModel = mealModel
    }
    
    override func main() {
        if isCancelled { return }
        
        guard let cachingUrl = URL(string: _mealModel.strMealImage) else { return }
        
        if let cachingImage = cacheModel.object(forKey: cachingUrl.absoluteString as NSString) {
            if self.isCancelled { return }
            self._mealModel.mealImage = cachingImage as? UIImage
            self.mealModel = self._mealModel
            self.loadingCompleteHandler?(self._mealModel)
        } else {
            if self.isCancelled { return }
            networkService.downloadImageFromUrl(from: _mealModel.strMealImage) { (image) in
                DispatchQueue.main.async() { [weak self] in
                    guard let self = self else { return }
                    self._mealModel.mealImage = image
                    self.mealModel = self._mealModel
                    cacheModel.setObject(image!, forKey: cachingUrl.absoluteString as NSString)
                    self.loadingCompleteHandler?(self._mealModel)
                }
            }
        }
    }
}
