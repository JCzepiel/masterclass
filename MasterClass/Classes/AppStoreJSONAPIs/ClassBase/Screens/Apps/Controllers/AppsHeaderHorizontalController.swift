//
//  AppsHeaderHorizontalController.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/23/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class AppsHeaderHorizontalController: HorizontalSnappingController {
    
    // MARK: - Properties
    
    fileprivate let cellId = "cellId"
    
    var dataToDisplay: [SocialApp] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: cellId)
        
        // We will set this because BetterSnappingLayout uses contentInset instead of section insets for its calculations
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

// MARK: - UICollectionViewDataSource

extension AppsHeaderHorizontalController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataToDisplay.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? AppsHeaderCell else { return UICollectionViewCell() }
        cell.dataToDisplay = dataToDisplay[indexPath.item]
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegate

extension AppsHeaderHorizontalController {
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AppsHeaderHorizontalController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 48, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
