//
//  SnappingLayout.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/24/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class SnappingLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)}
        let parent = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        let itemWidth = collectionView.frame.width - 48 // Comes from AppsHorizontalController
        let itemSpace = itemWidth + minimumInteritemSpacing
        var pageNumber = round(collectionView.contentOffset.x / itemSpace)
        
        let velocityX = velocity.x
        if velocityX > 0 {
            pageNumber += 1
        } else if velocityX < 0 {
            pageNumber -= 1
        }
        
        let nearestPageOffset = pageNumber * itemSpace
        return CGPoint(x: nearestPageOffset, y: parent.y)
    }
}
