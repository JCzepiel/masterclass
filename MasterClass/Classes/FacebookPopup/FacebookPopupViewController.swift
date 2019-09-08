//
//  FacebookPopupViewController.swift
//  FacebookPopUp
//
//  Created by James Czepiel on 11/30/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit

class FacebookPopupViewController: UIViewController {
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "fb_core_data_bg"))
        return iv
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white

        let iconHeight: CGFloat = 38
        let padding: CGFloat = 6
        
        let images = [#imageLiteral(resourceName: "blue_like"), #imageLiteral(resourceName: "red_heart"), #imageLiteral(resourceName: "surprised"), #imageLiteral(resourceName: "cry_laugh"), #imageLiteral(resourceName: "cry"), #imageLiteral(resourceName: "angry")]
        
        let arrangedSubviews =  images.map({ (image) -> UIView in
            let v = UIImageView(image: image)
            v.layer.cornerRadius = iconHeight / 2
            v.isUserInteractionEnabled = true
            return v
        })
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.distribution = .fillEqually
        
        stackView.spacing = padding
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        view.addSubview(stackView)
        
        let numberIcons = CGFloat(arrangedSubviews.count)
        let viewWidth = numberIcons * iconHeight + (numberIcons + 1) * padding
        
        view.frame = CGRect(x: 0, y: 0, width: viewWidth, height: iconHeight + 2 * padding)
        view.layer.cornerRadius = view.frame.height / 2
        view.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        stackView.frame = view.frame
        
        return view
    }()
    
    override var prefersStatusBarHidden: Bool { return true }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(backgroundImageView)
        backgroundImageView.fillSuperview()
        
        setupLongPress()
        
    }
    
    fileprivate func setupLongPress() {
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
    @objc fileprivate func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            handleGestureBegan(gesture: gesture)
            
        } else if gesture.state == .ended {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let stackView = self.containerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                
                self.containerView.transform = self.containerView.transform.translatedBy(x: 0, y: 50)
                self.containerView.alpha = 0
                
            }, completion: { (_) in
                self.containerView.removeFromSuperview()
            })
            
            
        } else if gesture.state == .changed {
            handleGestureChanged(gesture: gesture)
        }
    }
    
    fileprivate func handleGestureChanged(gesture: UILongPressGestureRecognizer) {
        let pressedLocation = gesture.location(in: self.containerView)
        let fixedYLocation = CGPoint(x: pressedLocation.x, y: self.containerView.frame.height / 2)
        let hitTestview = containerView.hitTest(fixedYLocation, with: nil)
        
        if hitTestview is UIImageView {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let stackView = self.containerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                
                hitTestview?.transform = CGAffineTransform(translationX: 0, y: -50)
            }, completion: nil)
        }
    }
    
    fileprivate func handleGestureBegan(gesture: UILongPressGestureRecognizer) {
        view.addSubview(containerView)
        
        let pressedLocation = gesture.location(in: view)
        let centeredX = (view.frame.width - containerView.frame.width) / 2
        containerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y)
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.containerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y - self.containerView.frame.height)
            self.containerView.alpha = 1
        })
    }
}

