//
//  VideoMealPresenter.swift
//  MealDB
//
//  Created by Владислав Галкин on 09.07.2021.
//

import Foundation

protocol VideoMealViewProtocol: AnyObject {
    func loadVideo(url: String)
    func failure(error: Error)
}

protocol VideoMealPresenterProtocol: AnyObject {
    init(view: VideoMealViewProtocol, urlVideo: String )
    func getUrlYouToubeVideo()
}

final class VideoMealPresenter: VideoMealPresenterProtocol {
    
    weak var view: VideoMealViewProtocol?
    let urlVideo: String
    
    init(view: VideoMealViewProtocol, urlVideo: String) {
        self.view = view
        self.urlVideo = urlVideo
    }
    
    func getUrlYouToubeVideo() {
        view?.loadVideo(url: urlVideo)
    }
}
