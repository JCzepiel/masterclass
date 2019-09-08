//
//  StretchyHeaderController.swift
//  StretchyHeaderLBTA
//
//  Created by James Czepiel on 2/13/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class StretchyHeaderController: UICollectionViewController {

    fileprivate let cellId = "cellID"
    fileprivate let headerId = "cellID"
    fileprivate let padding: CGFloat = 16
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }
    
    /// Added during MasterClass implementation. This page was crashing when pressing back because the Animator was still in progress.
    /// So we will get our header, and stop the animation before we leave this page
    override func viewWillDisappear(_ animated: Bool) {
        guard let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: 0)) as? HeaderView else { return }
        
        header.animator.stopAnimation(true)
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .black
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
        return header
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: 0)) as? HeaderView else { return }
        let contentOffsetY = scrollView.contentOffset.y
        let fraction = abs(contentOffsetY) / 100
        
        if contentOffsetY > 0 {
            header.animator.fractionComplete = 0
            return
        }
        
        header.animator.fractionComplete = fraction
    }
}

extension StretchyHeaderController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - padding * 2, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 340)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        return sectionInset
    }
}
