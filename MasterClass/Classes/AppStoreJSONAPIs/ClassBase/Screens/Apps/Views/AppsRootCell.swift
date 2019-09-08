//
//  AppsRootCell.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/19/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class AppsRootCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    fileprivate let titleLabel = UILabel(text: "App Section", font: .boldSystemFont(ofSize: 30))
        
    fileprivate let horizontalController = AppsHorizontalController()
    
    var dataToDisplay: Feed? {
        didSet {
            guard let dataToDisplay = dataToDisplay else { return }
            
            titleLabel.text = dataToDisplay.title
            
            horizontalController.dataToDisplay = dataToDisplay.results
        }
    }
    
    var didSelectHandler: ((FeedResult) -> ())? {
        didSet {
            horizontalController.didSelectHandler = didSelectHandler
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
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        
        addSubview(horizontalController.view)
        horizontalController.view.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
}
