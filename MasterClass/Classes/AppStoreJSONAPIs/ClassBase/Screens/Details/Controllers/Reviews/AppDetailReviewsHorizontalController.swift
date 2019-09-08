//
//  AppDetailReviewsHorizontalController.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/25/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class AppDetailReviewsHorizontalController: HorizontalSnappingController {
    
    // MARK: - Properties
    
    fileprivate let cellId = "cellId"
    
    fileprivate let topBottomPadding: CGFloat = 12
    fileprivate let lineSpacing: CGFloat = 10
    
    var dataToDisplay: [Entry]? {
        didSet {
            guard let _ = dataToDisplay else { return }
            
            collectionView.reloadData()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        collectionView.register(AppReviewCell.self, forCellWithReuseIdentifier: cellId)
        
        // We will set this because BetterSnappingLayout uses contentInset instead of section insets for its calculations
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

// MARK: - UICollectionViewDataSource

extension AppDetailReviewsHorizontalController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataToDisplay?.count ?? 6
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? AppReviewCell else { return UICollectionViewCell() }
        cell.dataToDisplay = dataToDisplay?[indexPath.item]
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegate

extension AppDetailReviewsHorizontalController {
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AppDetailReviewsHorizontalController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 32, height: view.frame.height - 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: topBottomPadding, left: 0, bottom: topBottomPadding, right: 0)
    }
}
