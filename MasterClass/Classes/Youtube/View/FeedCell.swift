//
//  FeedCell.swift
//  youttube
//
//  Created by James Czepiel on 10/8/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit

class FeedCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let videoCellId = "videoCellId"

    var videos: [Video] = []
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .clear
        return cv
    }()
    
    override func setupViews() {
        super.setupViews()
        
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: videoCellId)

        addSubview(collectionView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", view: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", view: collectionView)
        
        loadData()
    }
    
    func loadData() {
        DataLoader.shared.loadVideos(for: SectionType.home) { videos in
            if videos.count > 0 {
                self.videos = videos
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: videoCellId, for: indexPath) as! VideoCell
            cell.video = videos[indexPath.item]
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let height = (frame.width - 16 - 16) * 9 / 16
            //return CGSize(width: view.frame.width, height: height + 16 + 8 + 44 + 16)
            return CGSize(width: frame.width, height: height + 100)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoLauncher = VideoLauncher()
        videoLauncher.showVideoPlayer()
    }
}
