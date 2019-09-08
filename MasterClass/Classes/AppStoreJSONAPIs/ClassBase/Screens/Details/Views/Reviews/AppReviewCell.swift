//
//  AppReviewCell.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/25/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit
import Cosmos

class AppReviewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let titleLabel: UILabel = {
        let label = UILabel(text: "", font: .boldSystemFont(ofSize: 16))
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel(text: "", font: .systemFont(ofSize: 16))
        label.textAlignment = .right
        return label
    }()
    
    let ratingsView: CosmosView = {
        let ratingsView = CosmosView()
        ratingsView.settings.starSize = 22
        ratingsView.settings.starMargin = 1
        ratingsView.settings.filledColor = UIColor(red: 255/255, green: 153/255, blue: 0/255, alpha: 1)
        ratingsView.settings.emptyBorderColor = .clear
        ratingsView.settings.filledBorderColor = .clear
        ratingsView.settings.emptyColor = .clear
        ratingsView.settings.fillMode = .precise
        ratingsView.isUserInteractionEnabled = false
        ratingsView.constrainHeight(constant: 20)
        return ratingsView
    }()
    
    let reviewTextView: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    var dataToDisplay: Entry? {
        didSet {
            guard let dataToDisplay = dataToDisplay else { return }
            
            reviewTextView.text = dataToDisplay.content.label
            titleLabel.text = dataToDisplay.title.label
            authorLabel.text = dataToDisplay.author.name.label
            ratingsView.rating = Double(dataToDisplay.rating.label) ?? 0
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
        layer.cornerRadius = 8
        backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 0.05)
        
        let topLabelsStackView = UIStackView(arrangedSubviews: [titleLabel, authorLabel])
        topLabelsStackView.distribution = .fillEqually
        topLabelsStackView.spacing = 8

        let overallStackView = VerticalStackView(arrangedSubviews: [topLabelsStackView, ratingsView, reviewTextView, UIView()], spacing: 8)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        addSubview(overallStackView)
        overallStackView.fillSuperview()
    }
}
