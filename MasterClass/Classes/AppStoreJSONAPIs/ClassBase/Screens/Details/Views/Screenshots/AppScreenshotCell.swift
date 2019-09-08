//
//  AppScreenshotCell.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/25/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class AppScreenshotCell: UICollectionViewCell {
    
    // MARK: - Properties

    let imageView: UIImageView = {
        let imageView = UIImageView(cornerRadius: 8)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var dataToDisplay: URL? {
        didSet {
            guard dataToDisplay == dataToDisplay else { return }
            
            imageView.sd_setImage(with: dataToDisplay)
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
        addSubview(imageView)
        imageView.fillSuperview()
    }
}
