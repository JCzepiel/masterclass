//
//  CollectionViewSnappingAndAlphaAndSizeController.swift
//  MasterClass
//
//  Created by James Czepiel on 5/15/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class CollectionViewSnappingAndAlphaAndSizeController: UICollectionViewController {
    fileprivate let cellId = "cellId"
    
    init() {
        let layout = SnappingAndScalingAndAlphaLayout()
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .black
        collectionView.decelerationRate = .fast

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    }
}

extension CollectionViewSnappingAndAlphaAndSizeController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = UIColor.random().makeLighter(by: 0.25)
        cell.layer.cornerRadius = 300 / 2
        return cell
    }
}

extension CollectionViewSnappingAndAlphaAndSizeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 300, height: 300)
    }
}


