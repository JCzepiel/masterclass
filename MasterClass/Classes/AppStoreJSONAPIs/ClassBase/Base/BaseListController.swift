//
//  BaseListController.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/19/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class BaseListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Init
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
