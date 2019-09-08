//
//  UIViewPropertyAnimatorBasicsViewController.swift
//  UIViewPropertyAnimatorBasicsLBTA
//
//  Created by James Czepiel on 11/27/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//  https://www.letsbuildthatapp.com/course_video?id=4142

import UIKit

class UIViewPropertyAnimatorBasicsViewController: UIViewController {
    
    var imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
    
    let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
    
    let visualEffectView = UIVisualEffectView(effect: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupImageView()
        setupVisualBlurEffectView()
        setupSlider()
        
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.black.cgColor
        
        animator.addAnimations {
            self.imageView.transform = CGAffineTransform(scaleX: 4, y: 4)
            let blurEffect = UIBlurEffect(style: .regular)
            self.visualEffectView.effect = blurEffect
        }
    }
    
    /// Added during MasterClass implementation. This page was crashing when pressing back because the Animator was still in progress.
    /// So we will get our header, and stop the animation before we leave this page
    override func viewWillDisappear(_ animated: Bool) {
        animator.stopAnimation(true)
    }

    fileprivate func setupSlider() {
        let slider = UISlider()
        view.addSubview(slider)
        slider.anchor(top: imageView.bottomAnchor, leading: imageView.leadingAnchor, bottom: nil, trailing: imageView.trailingAnchor)
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
    }
    
    @objc fileprivate func handleSliderChange(sender: UISlider) {
        animator.fractionComplete = CGFloat(sender.value)
    }
    
    fileprivate func setupVisualBlurEffectView() {
        view.addSubview(visualEffectView)
        visualEffectView.fillSuperview()
    }
    
    fileprivate func setupImageView() {
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.centerInSuperview(size: .init(width: 200, height: 200))
    }

}

