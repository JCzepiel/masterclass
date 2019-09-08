//
//  CollectionViewLegacyAlphaAndSize.swift
//  Apogei
//
//  Created by James Czepiel on 4/8/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class CollectionViewLegacyAlphaAndSizeController: UIViewController {
    
    fileprivate let cellId = "cellId"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CollectionViewLegacyAlphaAndSizeCell.self, forCellWithReuseIdentifier: cellId)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    lazy var centerXStartingPoint = view.frame.width/2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.random().makeDarker()
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let firstIndexPath = IndexPath(row: 0, section: 0)

        guard let firstCell = collectionView.cellForItem(at: firstIndexPath) as? CollectionViewLegacyAlphaAndSizeCell else { return }

        firstCell.animator.fractionComplete = 1
    }
    
    fileprivate func setupViews() {
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let xLocationInView = offset.x + centerXStartingPoint
        
        //So what we really need is the % of distance to the center of the NEXT cell from the LAST cell. Meanwhile the PREVIOUS cell will get the opposite of that % applied to it.
        //For example - we are 30% from Cell 1's center to Cell 2's center. That means Cell 1s animation complete is 70% while Cell 2s animation complete is 30%.
        
        let cellsInBetweenScreenCenterPoint = getIndexPathsForTwoCellsBetweenCurrentScreenCenter()
        
        // Check if we have two cells like we need to do the calculation
        if let hasFirstIndex = cellsInBetweenScreenCenterPoint.0, let hasFirstCell = collectionView.cellForItem(at: hasFirstIndex) as? CollectionViewLegacyAlphaAndSizeCell {
            if let hasSecondIndex = cellsInBetweenScreenCenterPoint.1, let hasSecondCell = collectionView.cellForItem(at: hasSecondIndex) as? CollectionViewLegacyAlphaAndSizeCell {
                
                // The % is the % distance from the center of the first cell to the center of the second cell
                let percentageThroughToNextCell = (xLocationInView - hasFirstCell.center.x) / (hasSecondCell.center.x - hasFirstCell.center.x)
                
                // Apply the value to the second cell, and the opposite of the value to the first cell
                hasSecondCell.animator.fractionComplete = percentageThroughToNextCell
                hasFirstCell.animator.fractionComplete = 1 - percentageThroughToNextCell
                
            }
        }

    }
    
    fileprivate func getIndexPathsForTwoCellsBetweenCurrentScreenCenter() -> (IndexPath?, IndexPath?) {
        // get center
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        // get all visisble cells - make sure to order
        let allCells = self.collectionView.indexPathsForVisibleItems
            .sorted { $0.section < $1.section || $0.row < $1.row }
            .compactMap { self.collectionView.cellForItem(at: $0) }
        
        var firstIndexPath: IndexPath? = nil
        var secondIndexPath: IndexPath? = nil
        
        //find the two cells that have center points between the screen center
        for aCell in allCells {
            if aCell.center.x <= visiblePoint.x {
                if let alreadyHasAFirstPath = firstIndexPath, let alreadyHasAFirstCell = collectionView.cellForItem(at: alreadyHasAFirstPath) {
                    if aCell.center.x > alreadyHasAFirstCell.center.x {
                        // Since we could have more than 1 cell to the left, we need to make sure we get the SMALLEST value of the center.x. This cell is the one that is imediatly to the left
                        firstIndexPath = collectionView.indexPath(for: aCell)
                    }
                } else {
                    firstIndexPath = collectionView.indexPath(for: aCell)
                }
            }

            if aCell.center.x >= visiblePoint.x && secondIndexPath == nil {
                // Like the first cell, we need logic to prevent overwriting valid values. In the case of the second cell, we may have more than 1 cell to the right of the screen.
                // This will make sure we only save the value for secondIndexPath the first time, which corresponds to the first cell on the right
                secondIndexPath = collectionView.indexPath(for: aCell)
            }
        }
        
        return (firstIndexPath, secondIndexPath)
    }
    
    /// Added during MasterClass implementation. This page was crashing when pressing back because the Animator was still in progress.
    /// So we will get our header, and stop the animation before we leave this page
    override func viewWillDisappear(_ animated: Bool) {
        // This is overkill, but it's the only way that works. Normally we would call cell.stopAnimator(true) on all collectionView.visibleCells - but even that didn't work. I imagine its because all non-visible cells were still hanging around with their animator and I can't think of another way to stop them besides removing the entire collectionView.
        collectionView.removeFromSuperview()
    }
}

extension CollectionViewLegacyAlphaAndSizeController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? CollectionViewLegacyAlphaAndSizeCell else { return UICollectionViewCell() }
        return cell
    }
}

extension CollectionViewLegacyAlphaAndSizeController: UICollectionViewDelegate {
    
}

extension CollectionViewLegacyAlphaAndSizeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2, height: view.frame.height/2 - 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: view.frame.width/4, bottom: 16, right: view.frame.width/4)
    }
}
