//
//  SettingCell.swift
//  youttube
//
//  Created by James Czepiel on 10/5/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit

class SettingCell: BaseCell {
    
    var setting: Setting? {
        didSet {
            guard let setting = setting else { return }
            nameLabel.text = setting.name.rawValue
            imageIconView.image = UIImage(named: setting.imageName)?.withRenderingMode(.alwaysTemplate)
            imageIconView.tintColor = .darkGray
        }
    }
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Setting"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    var imageIconView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "settings")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(nameLabel)
        addSubview(imageIconView)

        
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]-8-[v1]|", view: imageIconView, nameLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", view: nameLabel)
        addConstraintsWithFormat(format: "V:[v0(30)]", view: imageIconView)

        addConstraint(NSLayoutConstraint(item: imageIconView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .darkGray : .white
            nameLabel.textColor = isHighlighted ? .white : .black
            imageIconView.tintColor = isHighlighted ? .white : .darkGray
        }
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .darkGray : .white
            nameLabel.textColor = isSelected ? .white : .black
            imageIconView.tintColor = isSelected ? .white : .darkGray
        }
    }
}
