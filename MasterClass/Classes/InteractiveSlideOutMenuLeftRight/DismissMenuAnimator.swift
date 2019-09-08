//
//  DismissMenuAnimator.swift
//  InteractiveSlideoutMenu
//
//  Created by James Czepiel on 3/4/19.
//  Copyright © 2019 Thorn Technologies, LLC. All rights reserved.
//

import UIKit

class DismissMenuAnimator: NSObject {
    
}

extension DismissMenuAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        
        guard let snapshot = containerView.viewWithTag(MenuHelper.snapshotNumber) else { return }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            snapshot.frame = CGRect(origin: CGPoint.zero, size: UIScreen.main.bounds.size)
        }) { _ in
            let didTransitionComplete = !transitionContext.transitionWasCancelled
            if didTransitionComplete {
                containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
                snapshot.removeFromSuperview()
            }
            transitionContext.completeTransition(didTransitionComplete)
        }
    }
}
