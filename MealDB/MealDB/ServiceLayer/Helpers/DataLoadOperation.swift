//
//  DataLoadOperation.swift
//  MealDB
//
//  Created by Владислав Галкин on 19.06.2021.
//

import Foundation
import UIKit.UIImage

class DataLoadOperation: Operation {
    
    let networkService: MealNetworkServiceProtocol = MealNetworkService()
    
    var image: UIImage?
    var loadingCompleteHandler: ((UIImage?) -> ())?
    private var url: String?
    
    init(url: String?) {
        self.url = url!
    }
    
    override func main() {
        if isCancelled { return }
        
        guard let imageUrl = url else { return }
        networkService.downloadImageFromUrl(from: imageUrl) { (image) in
            DispatchQueue.main.async() { [weak self] in
                guard let self = self else { return }
                if self.isCancelled { return }
                self.image = image
                self.loadingCompleteHandler?(self.image)
            }
        }
    }
}
