//
//  AppsHeaderCell.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/23/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class AppsHeaderCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    fileprivate let companyLabel: UILabel = {
        let label = UILabel(text: "Facebook", font: .boldSystemFont(ofSize: 12))
        label.textColor = .blue
        return label
    }()
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel(text: "Keeping up with friends is faster than ever", font: .systemFont(ofSize: 24))
        label.numberOfLines = 2
        return label
    }()
    
    fileprivate let imageView = UIImageView(cornerRadius: 8)
    
    var dataToDisplay: SocialApp? {
        didSet {
            guard let dataToDisplay = dataToDisplay else { return }
            
            companyLabel.text = dataToDisplay.name
            titleLabel.text = dataToDisplay.tagline
            imageView.sd_setImage(with: dataToDisplay.imageUrl)
        }
    }
    
    // MARK: - Properties

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    fileprivate func setupViews() {
        let stackView = VerticalStackView(arrangedSubviews: [companyLabel, titleLabel, imageView], spacing: 8)
        
        addSubview(stackView)
        stackView.fillSuperview(padding: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0))
    }
}
