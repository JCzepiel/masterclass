//
//  AppDetailScreenshotsCell.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/25/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class AppDetailScreenshotsCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let topBorder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(text: "Preview", font: .boldSystemFont(ofSize: 20))
        return label
    }()
    
    let horizontalController = AppDetailScreenshotsHorizontalController()
    
    var dataToDisplay: [URL]? = [] {
        didSet {
            guard dataToDisplay == dataToDisplay else { return }
            
            horizontalController.dataToDisplay = dataToDisplay
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
        addSubview(topBorder)
        addSubview(titleLabel)
        addSubview(horizontalController.view)
        
        topBorder.constrainHeight(constant: 1)
        topBorder.constrainWidth(constant: frame.width - 32)
        topBorder.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        titleLabel.anchor(top: topBorder.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 16, bottom: 0, right: 16))
        horizontalController.view.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
}
