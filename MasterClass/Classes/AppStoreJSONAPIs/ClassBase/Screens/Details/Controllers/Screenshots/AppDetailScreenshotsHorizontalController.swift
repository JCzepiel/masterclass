//
//  AppDetailScreenshotsHorizontalController.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/25/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class AppDetailScreenshotsHorizontalController: HorizontalSnappingController {
    
    // MARK: - Properties
    
    fileprivate let cellId = "cellId"
    
    fileprivate let topBottomPadding: CGFloat = 12
    fileprivate let lineSpacing: CGFloat = 10
    
    var dataToDisplay: [URL]? {
        didSet {
            guard let _ = dataToDisplay else { return }
            
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionViewLayout = collectionViewLayout as? BetterSnappingLayout {
            collectionViewLayout.shouldSnap = false
        }
        
        collectionView.backgroundColor = .white
        
        collectionView.register(AppScreenshotCell.self, forCellWithReuseIdentifier: cellId)
        
        // We will set this because BetterSnappingLayout uses contentInset instead of section insets for its calculations
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

// MARK: - UICollectionViewDataSource

extension AppDetailScreenshotsHorizontalController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataToDisplay?.count ?? 6
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? AppScreenshotCell else { return UICollectionViewCell() }
        cell.dataToDisplay = dataToDisplay?[indexPath.item]
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegate

extension AppDetailScreenshotsHorizontalController {

}

// MARK: - UICollectionViewDelegateFlowLayout

extension AppDetailScreenshotsHorizontalController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: view.frame.height - 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: topBottomPadding, left: 0, bottom: topBottomPadding, right: 0)
    }
}
