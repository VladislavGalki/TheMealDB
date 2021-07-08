//
//  VideoMealView.swift
//  MealDB
//
//  Created by Владислав Галкин on 08.07.2021.
//

import UIKit

final class VideoMealView: UIViewController {
    
    var presenter: VideoMealPresenterProtocol!
    
    let videoView: VideoView = {
        let view = VideoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
        presenter.getUrlYouToubeVideo()
    }
    
    func configure() {
        view.addSubview(videoView)
        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: view.topAnchor),
            videoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension VideoMealView: VideoMealViewProtocol {
    func loadVideo(url: String) {
        videoView.loadVideo(with: url)
    }
    
    func failure(error: Error) {
        
    }
}

