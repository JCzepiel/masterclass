//
//  StoriesScrollView.swift
//  CubeAnimation
//
//  Created by James Czepiel on 7/15/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class StoriesScrollView: UIScrollView {

    var stories = [UIView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isPagingEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataSource(with stories: [UIView]) {
        self.stories = stories
        for i in 0..<self.stories.count {
            let story = self.stories[i]
            let width = frame.width
            let height = frame.height
            let xOffset = width * CGFloat(i)
            story.frame = CGRect(x: xOffset, y: 0, width: width, height: height)
            addSubview(story)
            contentSize = CGSize(width: xOffset + width, height: height)
        }
    }
    
    func visibleViews() -> [UIView] {
        let visibleRect = CGRect(x: contentOffset.x, y: 0, width: frame.width, height: frame.height)
        var views = [UIView]()
        
        for view in stories {
            if view.frame.intersects(visibleRect) {
                views.append(view)
            }
        }
        
        return views
    }
}
