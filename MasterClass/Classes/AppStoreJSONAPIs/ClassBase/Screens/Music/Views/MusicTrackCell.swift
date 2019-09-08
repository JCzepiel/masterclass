//
//  MusicTrackCell.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 5/2/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class MusicTrackCell: UICollectionViewCell {
    
    var dataToDisplay: Result? {
        didSet {
            guard let dataToDisplay = dataToDisplay else { return }
            
            imageView.sd_setImage(with: dataToDisplay.artworkUrl100)
            headerLabel.text = dataToDisplay.nameText
            descriptionLabel.text = "\(dataToDisplay.trackName)•\(dataToDisplay.artistName ?? "")•\(dataToDisplay.collectionName ?? "")"
        }
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView(cornerRadius: 16)
        imageView.constrainWidth(constant: 80)
        imageView.constrainWidth(constant: 80)
        imageView.image = #imageLiteral(resourceName: "garden")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let headerLabel = UILabel(text: "Title Track Here", font: .boldSystemFont(ofSize: 16))
    let descriptionLabel = UILabel(text: "Description Track Here", font: .systemFont(ofSize: 16))

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        descriptionLabel.numberOfLines = 2
        
        let labelStackView = VerticalStackView(arrangedSubviews: [headerLabel, descriptionLabel], spacing: 8)
        
        let stackView = UIStackView(arrangedSubviews: [imageView, labelStackView])
        stackView.spacing = 16
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
}
