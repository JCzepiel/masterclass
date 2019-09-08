//
//  CollectionViewPanningControl.swift
//  Apogei
//
//  Created by James Czepiel on 4/8/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class CollectionViewPanningControl: UIViewController {
    
    let fakeTopView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    let testContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    fileprivate let buttonWidth: CGFloat = 60
    fileprivate let leftAndRightOffset: CGFloat = 16

    var slideButtonViewCenterXConstraint: NSLayoutConstraint?
    var slideButtonViewCenterXConstraintStartingConstant: CGFloat = 0.0
    lazy var slideButtonView: UIView = {
        let slide = UIView()
        slide.translatesAutoresizingMaskIntoConstraints = false
        slide.backgroundColor = UIColor.random()
        slide.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        slide.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        slide.layer.cornerRadius = 20
        slide.clipsToBounds = true
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        slide.addGestureRecognizer(gesture)
        return slide
    }()
    
    fileprivate let cellId = "cellId"
    
    var collectionViewStartingXOffset: CGFloat = 0.0
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isScrollEnabled = false
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let firstIndexPath = IndexPath(row: 0, section: 0)
        guard let cell = collectionView.cellForItem(at: firstIndexPath) else { return }
        
        collectionView.backgroundColor = cell.backgroundColor
    }
    
    fileprivate func setupViews() {
        view.addSubview(testContainerView)
        testContainerView.fillSuperview()
        
        testContainerView.addSubview(collectionView)
        collectionView.fillSuperview()
        
        view.addSubview(fakeTopView)
        fakeTopView.fillSuperview()
        
        view.addSubview(slideButtonView)
        
        slideButtonViewCenterXConstraintStartingConstant = (-view.frame.width/2) + buttonWidth/2 + leftAndRightOffset
        let centerYOffset: CGFloat = view.frame.height / 3
        slideButtonView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: centerYOffset).isActive = true
        slideButtonViewCenterXConstraint = slideButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: slideButtonViewCenterXConstraintStartingConstant)
        slideButtonViewCenterXConstraint?.isActive = true

    }
    
    
    @objc fileprivate func handlePan(sender: UIPanGestureRecognizer) {
        guard let centerXConstraint = slideButtonViewCenterXConstraint else { return }
        
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        // Keep track of when we don't want the button to move anymore, because we still want to go through the switch even when the button is at the end of its track
        var shouldMoveButton = true
        if (slideButtonView.frame.maxX >= (self.view.frame.width - leftAndRightOffset) && velocity.x >= 0) ||
           (slideButtonView.frame.minX <= leftAndRightOffset && velocity.x < 0) {
            shouldMoveButton = false
        }
        
        switch sender.state {
        case .began:
            //Do the animation to show the collection view now
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.fakeTopView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }, completion: { (_) in
            })
            
            slideButtonViewCenterXConstraintStartingConstant = centerXConstraint.constant
            collectionViewStartingXOffset = collectionView.contentOffset.x
        case .changed:
            if shouldMoveButton {
                centerXConstraint.constant = slideButtonViewCenterXConstraintStartingConstant + translation.x
                collectionView.contentOffset = CGPoint(x: collectionViewStartingXOffset + (translation.x * 2.3), y: 0)
                updateBackgroundColor()
            }
        case .ended:
            handlePanEnded()
        case .cancelled:
            break
        case .failed:
            break
        case .possible:
            break
        }
    }
    
    fileprivate func handlePanEnded() {
        guard let indexPath = getIndexPathForCurrentScreenCenterPoint(), let cell = collectionView.cellForItem(at: indexPath)  else {
            // If we get no cell back, we still need to transition, just without changing the background color
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.fakeTopView.transform = .identity
            })
            return
        }
        
        self.fakeTopView.backgroundColor = cell.backgroundColor
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.fakeTopView.transform = .identity
        })
    }
    
    fileprivate func updateBackgroundColor() {
        guard let indexPath = getIndexPathForCurrentScreenCenterPoint(), let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        collectionView.backgroundColor = cell.backgroundColor
    }
    
    fileprivate func getIndexPathForCurrentScreenCenterPoint() -> IndexPath? {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        return collectionView.indexPathForItem(at: visiblePoint)
    }
}

extension CollectionViewPanningControl: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = UIColor.random()
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 5, height: 5)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 1
        cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
        return cell
    }
}

extension CollectionViewPanningControl: UICollectionViewDelegate {
    
}


extension CollectionViewPanningControl: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2, height: view.frame.height/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}
