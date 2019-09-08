//
//  DismissMenuAnimator.swift
//  InteractiveSlideoutMenu
//
//  Created by James Czepiel on 3/4/19.
//  Copyright © 2019 Thorn Technologies, LLC. All rights reserved.
//

import UIKit

class UpDownSlideDismissMenuAnimator: NSObject {
    
}

extension UpDownSlideDismissMenuAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from), let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return }
        
        var finalFrameForVC = transitionContext.finalFrame(for: toViewController)
        
        finalFrameForVC = CGRect(x: 0, y: toViewController.view.bounds.height, width: toViewController.view.bounds.width, height: toViewController.view.bounds.height)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, animations: {
            fromViewController.view.frame = finalFrameForVC
        }, completion: { _ in
            transitionContext.completeTransition(true)
            
            //During presentation, the background view alpha was set lower than one. This resets it to 1 once the half screen view goes away
            toViewController.view.alpha = 1.0
        })
    }
}
