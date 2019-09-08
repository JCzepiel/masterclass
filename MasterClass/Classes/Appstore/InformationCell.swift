//
//  InformationCell.swift
//  appstore1
//
//  Created by James Czepiel on 9/24/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit

class InformationCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allInformationNodes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: informationCellId, for: indexPath) as! InformationCellKeyValuePair
        cell.informationNode = allInformationNodes?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellId, for: indexPath) as! InformationCellHeader
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: frame.width, height: 40)
    }
    
    var allInformationNodes: [AppDetailResponse.AppInformation]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()
    
    let informationCellId = "InformationCellId"
    let headerCellId = "headerCellId"

    override func setupViews() {
        super.setupViews()
        
        addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(InformationCellKeyValuePair.self, forCellWithReuseIdentifier: informationCellId)
        collectionView.register(InformationCellHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
    }
    
    class InformationCellHeader: BaseCell {
        
        let headerLabel: UILabel = {
            let label = UILabel()
            label.text = "Information"
            label.font = UIFont.systemFont(ofSize: 14)
            return label
        }()
        
        override func setupViews() {
            super.setupViews()
            
            addSubview(headerLabel)
            
            addConstraintsWithFormat(format: "H:|-14-[v0]", views: headerLabel)
            addConstraintsWithFormat(format: "V:|[v0]|", views: headerLabel)
            
        }
    }
    
    class InformationCellKeyValuePair: BaseCell {
        
        var informationNode: AppDetailResponse.AppInformation? {
            didSet {
                guard let hasInfo = informationNode else { return }
                
                self.keyLabel.text = hasInfo.Name ?? ""
                self.valueLabel.text = hasInfo.Value ?? ""
            }
        }
        
        let keyLabel: UILabel = {
            let label = UILabel()
            label.text = "KEY:"
            label.textColor = .darkGray
            label.font = UIFont.systemFont(ofSize: 11)
            label.textAlignment = .right
            return label
        }()
        
        let valueLabel: UILabel = {
            let label = UILabel()
            label.text = "VALUE"
            label.font = UIFont.systemFont(ofSize: 11)
            return label
        }()
        
        override func setupViews() {
            super.setupViews()
            
            addSubview(keyLabel)
            addSubview(valueLabel)
            
            addConstraintsWithFormat(format: "H:[v0]-8-[v1]", views: keyLabel, valueLabel)
            addConstraintsWithFormat(format: "V:|[v0]|", views: keyLabel)
            
            addConstraintsWithFormat(format: "H:|-98-[v0]", views: valueLabel)
            addConstraintsWithFormat(format: "V:|[v0]|", views: valueLabel)
            
        }
        
    }
}
