//
//  VideoCell.swift
//  youttube
//
//  Created by James Czepiel on 10/4/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VideoCell: BaseCell {

    var video: Video? {
        didSet {
            guard let video = video else { return }
            
            if let imageName = video.thumbnail_image_name {
                DataLoader.shared.loadImage(using: imageName) { image in
                    DispatchQueue.main.async {
                        self.thumbNailImageView.image = image
                    }
                }
            }
            
            if let title = video.title {
                titleLabel.text = title
            }
            
            guard let channel = video.channel else { return }
            
            if let profileImage = channel.profile_image_name {
                DataLoader.shared.loadImage(using: profileImage) { image in
                    DispatchQueue.main.async {
                        self.profileImageView.image = image
                    }
                }
            }
            
            if let name = channel.name, let views = video.number_of_views {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                let properViews = numberFormatter.string(from: NSNumber(floatLiteral: views)) ?? "nil"
                subtitleLabel.text = name + " • " + properViews + "• 2 years ago"
            }
        }
    }
    
    let thumbNailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    let subtitleLabel: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        textView.textColor = .lightGray
        return textView
    }()
    
    override func setupViews() {
        addSubview(thumbNailImageView)
        addSubview(seperatorView)
        addSubview(profileImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", view: thumbNailImageView)
        addConstraintsWithFormat(format: "H:|-16-[v0(44)]", view: profileImageView)
        addConstraintsWithFormat(format: "V:|-16-[v0]-8-[v1(44)]-32-[v2(2)]|", view: thumbNailImageView, profileImageView, seperatorView)
        addConstraintsWithFormat(format: "H:|[v0]|", view: seperatorView)
        
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: thumbNailImageView, attribute: .bottom, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: profileImageView, attribute: .right, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: thumbNailImageView, attribute: .right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .height, multiplier: 0, constant: 20))
        
        addConstraint(NSLayoutConstraint(item: subtitleLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4))
        addConstraint(NSLayoutConstraint(item: subtitleLabel, attribute: .left, relatedBy: .equal, toItem: profileImageView, attribute: .right, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: subtitleLabel, attribute: .right, relatedBy: .equal, toItem: thumbNailImageView, attribute: .right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: subtitleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30))
    }
}

