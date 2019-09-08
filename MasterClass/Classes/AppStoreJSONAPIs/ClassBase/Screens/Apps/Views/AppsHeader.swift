//
//  AppsHeader.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/23/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class AppsHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    fileprivate let appHeaderHorizontalController = AppsHeaderHorizontalController()
    
    var dataToDisplay: [SocialApp] = [] {
        didSet {
            appHeaderHorizontalController.dataToDisplay = dataToDisplay
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    fileprivate func setupViews() {
        addSubview(appHeaderHorizontalController.view)
        appHeaderHorizontalController.view.fillSuperview()
    }
}
