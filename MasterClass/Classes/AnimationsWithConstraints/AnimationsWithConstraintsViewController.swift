//
//  AnimationsWithConstraintsViewController.swift
//  AnimationsWithConstraintsLBTA
//
//  Created by James Czepiel on 11/29/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit

class AnimationsWithConstraintsViewController: UIViewController {
    
    enum Positions: CaseIterable {
        case topLeft
        case topRight
        case bottomRight
        case bottomLeft
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "steve-jobs"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var currentImagePosition: Positions = .topLeft
    
    var leftAnchor: NSLayoutConstraint?
    var rightAnchor: NSLayoutConstraint?
    var topAnchor: NSLayoutConstraint?
    var bottomAnchor: NSLayoutConstraint?
    
    var widthAnchor: NSLayoutConstraint?
    var heightAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

        topAnchor = imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        leftAnchor = imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
        rightAnchor = imageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        bottomAnchor = imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        widthAnchor = imageView.widthAnchor.constraint(equalToConstant: 100)
        widthAnchor?.isActive = true
        heightAnchor = imageView.heightAnchor.constraint(equalToConstant: 100)
        heightAnchor?.isActive = true
        
        // On start, set the position
        changeImagePosition(newPosition: currentImagePosition)
    }
    
    func changeImagePosition(newPosition: Positions) {
        // Note to self: Turn off the old ones FIRST or else you get warnings because of possible conflicts that overlap
        switch newPosition {
            case .topLeft:
                self.bottomAnchor?.isActive = false
                self.rightAnchor?.isActive = false

                self.leftAnchor?.isActive = true
                self.topAnchor?.isActive = true
        
            case .topRight:
                self.leftAnchor?.isActive = false
                self.bottomAnchor?.isActive = false

                self.rightAnchor?.isActive = true
                self.topAnchor?.isActive = true
            case .bottomRight:
                self.leftAnchor?.isActive = false
                self.topAnchor?.isActive = false

                self.rightAnchor?.isActive = true
                self.bottomAnchor?.isActive = true
            case .bottomLeft:
                self.rightAnchor?.isActive = false
                self.topAnchor?.isActive = false

                self.leftAnchor?.isActive = true
                self.bottomAnchor?.isActive = true
        }
        
        randomizeDimensions()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
            
        }, completion: { (_) in
            self.currentImagePosition = newPosition
        })
    }
    
    func randomizeDimensions() {
        let newDimension = CGFloat.random(in: 50...100)
        widthAnchor?.constant = newDimension
        heightAnchor?.constant = newDimension
    }
    
    @objc func handleTap() {
        if currentImagePosition == .topLeft {
            changeImagePosition(newPosition: .topRight)
        } else if currentImagePosition == .topRight {
            changeImagePosition(newPosition: .bottomRight)
        } else if currentImagePosition == .bottomRight {
            changeImagePosition(newPosition: .bottomLeft)
        } else if currentImagePosition == .bottomLeft {
            changeImagePosition(newPosition: .topLeft)
        }
    }
}

