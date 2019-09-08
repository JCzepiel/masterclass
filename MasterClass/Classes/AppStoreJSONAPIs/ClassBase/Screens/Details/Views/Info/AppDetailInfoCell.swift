//
//  AppDetailInfoCell.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/24/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class AppDetailInfoCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let imageView: UIImageView = {
        let imageView = UIImageView(cornerRadius: 16)
        imageView.constrainWidth(constant: 140)
        imageView.constrainHeight(constant: 140)
        imageView.backgroundColor = .red
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel(text: "App Name", font: .boldSystemFont(ofSize: 24))
        label.numberOfLines = 2
        return label
    }()
    
    let priceButton: UIButton = {
        let button = UIButton(title: "$4.99")
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.constrainWidth(constant: 80)
        return button
    }()
    
    let whatsNewLabel: UILabel = {
        let label = UILabel(text: "What's New", font: .boldSystemFont(ofSize: 24))
        return label
    }()
    
    let releaseNotesLabel: UILabel = {
        let label = UILabel(text: "Release Notes", font: .systemFont(ofSize: 16))
        label.numberOfLines = 0
        return label
    }()
    
    var dataToDisplay: Result? {
        didSet {
            guard let dataToDisplay = dataToDisplay else { return }
            
            nameLabel.text = dataToDisplay.trackName
            priceButton.setTitle(dataToDisplay.formattedPrice, for: .normal)
            
            imageView.sd_setImage(with: dataToDisplay.artworkUrl100)
            
            releaseNotesLabel.text = dataToDisplay.releaseNotes
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
        let priceButtonStackView = UIStackView(arrangedSubviews: [priceButton, UIView()])
        
        let nameLabelAndPriceSectionStackView = VerticalStackView(arrangedSubviews: [nameLabel, priceButtonStackView, UIView()], spacing: 12)
        
        let topHorizontalStackView = UIStackView(arrangedSubviews: [imageView, nameLabelAndPriceSectionStackView])
        topHorizontalStackView.spacing = 20
        topHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let completeStackView = VerticalStackView(arrangedSubviews: [topHorizontalStackView, whatsNewLabel, releaseNotesLabel], spacing: 16)
        addSubview(completeStackView)
        completeStackView.fillSuperview(padding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
    }

}
