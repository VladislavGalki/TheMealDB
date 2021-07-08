//
//  VideoView.swift
//  MealDB
//
//  Created by Владислав Галкин on 08.07.2021.
//

import UIKit
import WebKit

final class VideoView: UIView {
    
    //MARK: - UI
    
    let videoView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    func configureView() {
        addSubview(videoView)
        
        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: topAnchor),
            videoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            videoView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    //MARK: - Private methods
    
    func loadVideo(with url: String) {
        let videoID = youtubeVideoId(url: url)
        if let id = videoID {
            guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(id)") else { return }
            videoView.load(URLRequest(url: youtubeURL))
        }
    }
    
    private func youtubeVideoId(url: String) -> String? {
        guard let url = URL(string: url) else { return .none}
        let pattern = #"(?<=(youtu\.be\/)|(v=)).+?(?=\?|\&|$)"#
        let testString = url.absoluteString
        
        if let matchRange = testString.range(of: pattern, options: .regularExpression) {
            let subStr = testString[matchRange]
            return String(subStr)
        } else {
            return .none
        }
    }
}
