//
//  CollectionViewLegacyAlphaAndSizeCell.swift
//  Apogei
//
//  Created by James Czepiel on 4/8/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class CollectionViewLegacyAlphaAndSizeCell: UICollectionViewCell {
    
    let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
    
    let circle: UIView = {
        let color = UIColor.random()
        
        let bigCircle = UIView()
        bigCircle.translatesAutoresizingMaskIntoConstraints = false
        bigCircle.backgroundColor = color
        bigCircle.widthAnchor.constraint(equalToConstant: 80).isActive = true
        bigCircle.heightAnchor.constraint(equalToConstant: 80).isActive = true
        bigCircle.layer.cornerRadius = 40
        bigCircle.clipsToBounds = true
        
        let smallCircle = UIView()
        smallCircle.translatesAutoresizingMaskIntoConstraints = false
        smallCircle.backgroundColor = .black
        smallCircle.widthAnchor.constraint(equalToConstant: 76).isActive = true
        smallCircle.heightAnchor.constraint(equalToConstant: 76).isActive = true
        smallCircle.layer.cornerRadius = 38
        smallCircle.clipsToBounds = true
        
        let label = UILabel()
        label.text = String(Int.random(in: 142...4289))
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        smallCircle.addSubview(label)
        label.centerYAnchor.constraint(equalTo: smallCircle.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: smallCircle.centerXAnchor).isActive = true
        
        bigCircle.addSubview(smallCircle)
        smallCircle.centerYAnchor.constraint(equalTo: bigCircle.centerYAnchor).isActive = true
        smallCircle.centerXAnchor.constraint(equalTo: bigCircle.centerXAnchor).isActive = true

        return bigCircle
    }()
    
    var topLabelRightAnchorConstraint: NSLayoutConstraint?
    let topLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        label.backgroundColor = UIColor.random()
        label.textColor = UIColor.random().makeLighter()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Shots"
        return label
    }()
    
    let bottomLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2.3 pg"
        label.alpha = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        
        animator.addAnimations {
            self.topLabelRightAnchorConstraint?.constant = -(self.circle.center.x - self.topLabel.frame.width/2)
            self.circle.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.bottomLabel.alpha = 1
            self.layoutIfNeeded()
        }
    }
    
    fileprivate func setupViews() {
        addSubview(circle)
        addSubview(topLabel)
        addSubview(bottomLabel)
        
        circle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        circle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        topLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topLabelRightAnchorConstraint = topLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        topLabelRightAnchorConstraint?.isActive = true
        
        bottomLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        bottomLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: -32).isActive = true
    }
    
    // Weird beavior was happening with the animator, seems like its removed during reuse
    override func prepareForReuse() {
        // Stop the animation since we will start over
        animator.stopAnimation(true)
        
        // Reset this constraint too so the animation works
        self.topLabelRightAnchorConstraint?.constant = 0

        super.prepareForReuse()
        
        // Then we have to re-add the animations
        animator.addAnimations {
            self.topLabelRightAnchorConstraint?.constant = -(self.circle.center.x - self.topLabel.frame.width/2)
            self.circle.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.bottomLabel.alpha = 1
            self.layoutIfNeeded()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
