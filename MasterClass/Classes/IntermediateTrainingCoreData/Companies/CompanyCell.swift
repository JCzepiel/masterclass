//
//  CompanyCell.swift
//  IntermediateTrainingCoreData
//
//  Created by James Czepiel on 3/25/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class CompanyCell: UITableViewCell {
    
    var company: CompanyEntity? {
        didSet {
            guard let company = company else { return }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
    
            if let name = company.name, let founded = company.founded {
                let dateString = dateFormatter.string(from: founded)
                nameFoundeDateLabel.text = name + "- Founded: " + dateString + ", \(company.numberOfEmployees) Employees!"
    
            } else if let name = company.name {
                nameFoundeDateLabel.text = name + ", \(company.numberOfEmployees) Employees!"
            }
    
            if let hasData = company.imageData, let hasImage = UIImage(data: hasData) {
                companyImageView.image = hasImage
            }
    
        }
    }
    
    let companyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "select_photo_empty")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = UIColor.darkBlue.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    let nameFoundeDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Company Name"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .tealColor
        
        addSubview(companyImageView)
        companyImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        companyImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(nameFoundeDateLabel)
        nameFoundeDateLabel.leadingAnchor.constraint(equalTo: companyImageView.trailingAnchor, constant: 8).isActive = true
        nameFoundeDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        nameFoundeDateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
