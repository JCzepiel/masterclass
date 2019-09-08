//
//  SnappingAndScalingAndAlphaLayout.swift
//  MasterClass
//
//  Created by James Czepiel on 5/15/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class SnappingAndScalingAndAlphaLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        collectionView.contentInset = .init(top: 128, left: 48, bottom: 128, right: 0)
        scrollDirection = .horizontal
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return super.layoutAttributesForElements(in: rect) }
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        var allItems: [UICollectionViewLayoutAttributes] = []
        
        layoutAttributes?.forEach { itemAttributes in
            let itemAttributesCopy = itemAttributes.copy() as! UICollectionViewLayoutAttributes
            
            let frame = itemAttributesCopy.frame
            
            // Set the scaling factor for the size and alpha of the cells. This will determine how drastically the cells get smaller+disappear during scroll
            let minScale: CGFloat = 0.50
            let minAlpha: CGFloat = 0.2
            
            // Calculate the distance between the Cell and the center of the screen.
            let distance = abs(collectionView.contentOffset.x + collectionView.contentInset.left - frame.origin.x)
            let ratio = (itemAttributesCopy.frame.width - distance) / itemAttributesCopy.frame.width
            
            // Scale the Cell between a factor of minScale% and 100% depending on the distance of the center
            let scale = max(minScale, ratio * (1 - minScale) + minScale)
            itemAttributesCopy.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            // Set alpha of the Cell between a factor of minAlpha% and 100% depending on the distance of the center
            let alpha = max(minAlpha, ratio * (1 - minAlpha) + minAlpha)
            itemAttributesCopy.alpha = alpha
            
            allItems.append(itemAttributesCopy)
        }
        
        return allItems
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    var shouldSnap: Bool = true
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView, self.shouldSnap == true else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }
        
        let nextX: CGFloat
        
        if proposedContentOffset.x <= 0 || collectionView.contentOffset == proposedContentOffset {
            nextX = proposedContentOffset.x
        } else {
            nextX = collectionView.contentOffset.x + (velocity.x > 0 ? collectionView.bounds.size.width : -collectionView.bounds.size.width)
        }
        
        let targetRect = CGRect(x: nextX, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left
        
        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)
        
        layoutAttributesArray?.forEach({ (layoutAttributes) in
            let itemOffset = layoutAttributes.frame.origin.x
            if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        })
        
        print(CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y))
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
