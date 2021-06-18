//
//  WebImageView.swift
//  MealDB
//
//  Created by Владислав Галкин on 16.06.2021.
//

import UIKit

class WebImageView: UIImageView {
    
    let cacheImage = NSCache<AnyObject, AnyObject>()
    
    func downloadImage(withURL imageUrl: String?) {
        
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else { return }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        
        session.dataTask(with: request ) { [weak self] (data, response, error) in
            var downloadImage : UIImage?
            guard let data = data else { return }
            downloadImage = UIImage(data: data)
            DispatchQueue.main.async {
                if downloadImage != nil {
                    self!.cacheImage.setObject(downloadImage!, forKey: url.absoluteString as NSString)
                    self?.image = downloadImage
                }
            }
        }.resume()
    }
    
    func setImage(withURL imageUrl: String?) {
        
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else { return }
        
        if let image = cacheImage.object(forKey: url.absoluteString as NSString) {
            self.image = image as? UIImage
        } else {
            downloadImage(withURL: imageUrl)
        }
    }
}
