//
//  SearchResultCell.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/18/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit
import Cosmos

class SearchResultCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var appResult: SearchDisplayable? {
        didSet {
            guard let appResult = appResult else { return }
            
            nameLabel.text = appResult.nameText
            categoryLabel.text = appResult.categoryText
            
            appIconImageView.sd_setImage(with: appResult.appIconImageURL)
            
            ratingsView.rating = appResult.ratingValue
            ratingsView.text = appResult.ratingText
            
            // TODO: FIND A BETTER WAY TO DO THIS
            let allRealScreenshots = appResult.screenshotImageURLs.compactMap({ $0 })
            if allRealScreenshots.count > 0 && allRealScreenshots.count < 2 {
                screenshot1ImageView.sd_setImage(with: allRealScreenshots[0])
            } else if allRealScreenshots.count > 1 && allRealScreenshots.count < 3 {
                screenshot1ImageView.sd_setImage(with: allRealScreenshots[0])
                screenshot2ImageView.sd_setImage(with: allRealScreenshots[1])
            } else if  allRealScreenshots.count >= 3  {
                screenshot1ImageView.sd_setImage(with: allRealScreenshots[0])
                screenshot2ImageView.sd_setImage(with: allRealScreenshots[1])
                screenshot3ImageView.sd_setImage(with: allRealScreenshots[2])
            }
        }
    }
    
    let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(white: 0, alpha: 0.5)
        return label
    }()
    
    let ratingsView: CosmosView = {
        let ratingsView = CosmosView()
        ratingsView.settings.starSize = 12
        ratingsView.settings.starMargin = 1
        ratingsView.settings.filledColor = .lightGray
        ratingsView.settings.emptyBorderColor = .lightGray
        ratingsView.settings.filledBorderColor = .lightGray
        ratingsView.settings.textFont = .systemFont(ofSize: 12, weight: .regular)
        ratingsView.settings.textColor = UIColor(white: 0, alpha: 0.5)
        ratingsView.settings.fillMode = .precise
        ratingsView.isUserInteractionEnabled = false
        return ratingsView
    }()
    
    let getButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get", for: .normal)
        button.backgroundColor = UIColor(white: 0, alpha: 0.1)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.layer.cornerRadius = 16
        return button
    }()
    
    lazy var screenshot1ImageView = createScreenshotImageView()
    lazy var screenshot2ImageView = createScreenshotImageView()
    lazy var screenshot3ImageView = createScreenshotImageView()

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
        
        let infoTopStackView = UIStackView(arrangedSubviews: [appIconImageView,
                                                              VerticalStackView(arrangedSubviews: [nameLabel, categoryLabel, ratingsView], spacing: 4),
                                                              getButton])
        infoTopStackView.spacing = 12
        infoTopStackView.alignment = .center
        
        let screenshotsStackView = UIStackView(arrangedSubviews: [screenshot1ImageView, screenshot2ImageView, screenshot3ImageView])
        screenshotsStackView.spacing = 16
        screenshotsStackView.distribution = .fillEqually

        let overallStackView = VerticalStackView(arrangedSubviews: [infoTopStackView, screenshotsStackView], spacing: 16)
        
        addSubview(overallStackView)
        overallStackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        
    }
    
    fileprivate func createScreenshotImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
}
