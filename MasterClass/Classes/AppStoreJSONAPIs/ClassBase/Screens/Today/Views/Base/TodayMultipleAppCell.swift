//
//  TodayMultipleAppCell.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/29/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class TodayMultipleAppCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let categoryLabel: UILabel = {
        let label = UILabel(text: "", font: .boldSystemFont(ofSize: 20))
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(text: "", font: .boldSystemFont(ofSize: 32))
        label.numberOfLines = 2
        return label
    }()
    
    let multipleAppsController = TodayMultipleAppsController(mode: .small)
    
    var dataToDisplay: TodayModel? {
        didSet {
            guard let dataToDisplay = dataToDisplay else { return }
            categoryLabel.text = dataToDisplay.category
            titleLabel.text = dataToDisplay.title
            backgroundColor = dataToDisplay.backgroundColor
            
            multipleAppsController.dataToDisplay = dataToDisplay.apps
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            var transform: CGAffineTransform = .identity
            if isHighlighted {
                transform = .init(scaleX: 0.9, y: 0.9)
            }
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.transform = transform
            }, completion: nil)
        }
    }
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // All this stuff is to prevent rasterization from messing up image quality
        // I'll only add this here and NOT to TodayCell because its messy and cause other issues
        backgroundView = UIView()
        guard let hasBackground = backgroundView else { return }
        
        addSubview(hasBackground)
        hasBackground.fillSuperview()
        hasBackground.backgroundColor = .white
        hasBackground.layer.cornerRadius = 16
        
        hasBackground.layer.shadowOpacity = 0.1
        hasBackground.layer.shadowRadius = 10
        hasBackground.layer.shadowOffset = CGSize(width: 0, height: 10)
        hasBackground.layer.shouldRasterize = true
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    fileprivate func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 16
        
        multipleAppsController.view.backgroundColor = .red
        
        let stackView = VerticalStackView(arrangedSubviews: [categoryLabel, titleLabel, multipleAppsController.view], spacing: 12)
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 24, left: 24, bottom: 24, right: 24))
    }
}
