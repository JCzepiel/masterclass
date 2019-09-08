//
//  PresentMenuAnimator.swift
//  InteractiveSlideoutMenu
//
//  Created by James Czepiel on 3/4/19.
//  Copyright © 2019 Thorn Technologies, LLC. All rights reserved.
//

import UIKit

class UpDownSlidePresentMenuAnimator: NSObject {
    
}

extension UpDownSlidePresentMenuAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from), let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return }
        
        var finalFrameForVC = transitionContext.finalFrame(for: toViewController)
        let containerView = transitionContext.containerView
        let bounds = UIScreen.main.bounds
        
        let statusBarHeight =  UIApplication.shared.statusBarFrame.height
        
        finalFrameForVC = CGRect(x: 0, y: fromViewController.view.center.y + statusBarHeight, width: toViewController.view.bounds.width, height: toViewController.view.bounds.height - fromViewController.view.center.y )
        
        toViewController.view.frame = finalFrameForVC.offsetBy(dx: 0, dy: bounds.size.height/2) // Divide by 2 because when swiping up/down, the incoming/outgoing view is only have the size of the screen
        containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, animations: {
            //The fromViewController's alpha with stay .5 during the duration the half screen view is on screen. It gets reset to 1 in our custom dismiss animation
            fromViewController.view.alpha = 0.5
            toViewController.view.frame = finalFrameForVC
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}
