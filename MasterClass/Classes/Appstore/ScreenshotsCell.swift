//
//  ScreenshotsCell.swift
//  appstore1
//
//  Created by James Czepiel on 9/21/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit

class ScreenshotsCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var allScreenshots: [String]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let cellId = "cellId"
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ScreenshotImageCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        addSubview(dividerLineView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        
        addConstraintsWithFormat(format: "H:|-14-[v0]|", views: dividerLineView)
        
        addConstraintsWithFormat(format: "V:|[v0][v1(1)]|", views: collectionView, dividerLineView)
        

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allScreenshots?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ScreenshotImageCell
        
        if let hasImage = allScreenshots?[indexPath.row] {
            cell.imageName = hasImage
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240, height: frame.height - 28)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    private class ScreenshotImageCell: BaseCell {
        
        var imageName: String? {
            didSet {
                guard let name = imageName else { return }
                
                imageView.image = UIImage(named: name)
            }
        }

        let imageView: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleToFill
            return iv
        }()
        
        override func setupViews() {
            super.setupViews()
            backgroundColor = .yellow
            addSubview(imageView)
            
            addConstraintsWithFormat(format: "H:|[v0]|", views: imageView)
            addConstraintsWithFormat(format: "V:|[v0]|", views: imageView)
        }
    }
}


