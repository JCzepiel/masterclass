//
//  MenuViewController.swift
//  InteractiveSlideoutMenu
//
//  Created by Robert Chen on 2/7/16.
//  Copyright © 2016 Thorn Technologies, LLC. All rights reserved.
//

import UIKit

class UpDownSlideMenuViewController : UIViewController {
    
    let closeMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Close", for: .normal)
        button.addTarget(self, action: #selector(closeMenu), for: .touchUpInside)
        return button
    }()
    
    var interactor: UpDownSlideInteractor? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = 12
        
        view.backgroundColor = .green
        
        view.addSubview(closeMenuButton)
        closeMenuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        closeMenuButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleGesture(sender:))))
    }
    
    @objc fileprivate func closeMenu() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let progress = UpDownSlideMenuHelper.calculateProgress(translationInView: translation, viewBounds: view.bounds, direction: .down)
        UpDownSlideMenuHelper.mapGestureStateToInteractor(gestureState: sender.state, progress: progress, interactor: interactor) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
