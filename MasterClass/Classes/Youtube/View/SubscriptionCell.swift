//
//  SubscriptionCell.swift
//  youttube
//
//  Created by James Czepiel on 10/9/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit

class SubscriptionCell: FeedCell {
    override func loadData() {
        DataLoader.shared.loadVideos(for: SectionType.subscriptions) { videos in
            if videos.count > 0 {
                self.videos = videos
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}
