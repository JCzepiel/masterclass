//
//  ClassListingLayout.swift
//  MasterClass
//
//  Created by James Czepiel on 2/18/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//
//  Inspired by https://stackoverflow.com/questions/44187881/uicollectionview-full-width-cells-allow-autolayout-dynamic-height

import UIKit

class ClassListingLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
