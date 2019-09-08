//
//  TrendingCell.swift
//  youttube
//
//  Created by James Czepiel on 10/9/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit

class TrendingCell: FeedCell {
    override func loadData() {
        DataLoader.shared.loadVideos(for: SectionType.trending) { videos in
            if videos.count > 0 {
                self.videos = videos
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}
