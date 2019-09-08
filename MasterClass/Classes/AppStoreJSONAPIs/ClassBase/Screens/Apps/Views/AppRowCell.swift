//
//  AppRowCell.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/22/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class AppRowCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView(cornerRadius: 8)
        imageView.constrainWidth(constant: 64)
        imageView.constrainHeight(constant: 64)
        return imageView
    }()
    
    fileprivate let nameLabel = UILabel(text: "App Name", font: .systemFont(ofSize: 16))
    fileprivate let companyLabel = UILabel(text: "Company Name", font: .systemFont(ofSize: 14))

    fileprivate let getButton: UIButton = {
        let button = UIButton(title: "Get")
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.constrainWidth(constant: 80)
        button.constrainHeight(constant: 32)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return button
    }()
    
    var dataToDisplay: FeedResult? {
        didSet {
            guard let dataToDisplay = dataToDisplay else { return }
            
            nameLabel.text = dataToDisplay.name
            companyLabel.text = dataToDisplay.artistName
            imageView.sd_setImage(with: dataToDisplay.artworkUrl100)
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
        let stackView = UIStackView(arrangedSubviews: [imageView, VerticalStackView(arrangedSubviews: [nameLabel, companyLabel], spacing: 4), getButton])
        stackView.spacing = 16
        stackView.alignment = .center
        
        addSubview(stackView)
        
        stackView.fillSuperview()
    }
}
