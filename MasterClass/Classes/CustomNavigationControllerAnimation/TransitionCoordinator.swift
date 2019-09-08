//
//  TransitionCoordinator.swift
//  Pong
//
//  Created by James Czepiel on 3/7/19.
//  Copyright © 2019 Luke Parham. All rights reserved.
//

import UIKit

class TransitionCoordinator: NSObject, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is CircleTransitionable && toVC is CircleTransitionable {
            return CircularTransition()
        } else {
            return nil
        }
    }
}
