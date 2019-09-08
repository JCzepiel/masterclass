//
//  AppsHorizontalController.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/19/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class AppsHorizontalController: HorizontalSnappingController {
    
    // MARK: - Properties
    
    fileprivate let cellId = "cellId"
    
    fileprivate let topBottomPadding: CGFloat = 12
    fileprivate let lineSpacing: CGFloat = 10
    
    var didSelectHandler: ((FeedResult) -> ())?
    
    var dataToDisplay: [FeedResult]? {
        didSet {
            guard let _ = dataToDisplay else { return }
            
            self.collectionView.reloadData()
        }
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white

        collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: cellId)
        
        // We will set this because BetterSnappingLayout uses contentInset instead of section insets for its calculations
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

// MARK: - UICollectionViewDataSource

extension AppsHorizontalController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataToDisplay?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? AppRowCell else { return UICollectionViewCell() }
        cell.dataToDisplay = dataToDisplay?[indexPath.item] ?? nil
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegate

extension AppsHorizontalController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dataToDisplay = dataToDisplay else { return }
        
        let app = dataToDisplay[indexPath.item]
        
        didSelectHandler?(app)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AppsHorizontalController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.height - 2 * topBottomPadding - 2 * lineSpacing) / 3
        return CGSize(width: view.frame.width - 48, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: topBottomPadding, left: 0, bottom: topBottomPadding, right: 0)
    }
}
