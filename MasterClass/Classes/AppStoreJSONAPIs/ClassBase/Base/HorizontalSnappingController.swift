//
//  HorizontalSnappingController.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/24/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class HorizontalSnappingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Init
    
    init() {
        let layout = BetterSnappingLayout()
        layout.scrollDirection = .horizontal
        super.init(collectionViewLayout: layout)
        collectionView.decelerationRate = .fast
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
