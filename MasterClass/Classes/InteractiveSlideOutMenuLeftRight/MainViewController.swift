//
//  MainViewController.swift
//  InteractiveSlideoutMenu
//
//  Created by Robert Chen on 2/7/16.
//  Copyright © 2016 Thorn Technologies, LLC. All rights reserved.
//
//  From https://www.thorntech.com/2016/03/ios-tutorial-make-interactive-slide-menu-swift/

import UIKit

class MainViewController: UIViewController {
    
    let interactor = Interactor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(openMenu))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        view.backgroundColor = .blue
        
        let edgePanRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePanGesture(sender:)))
        edgePanRecognizer.edges = .left
        view.addGestureRecognizer(edgePanRecognizer)
    }
    
    @objc fileprivate func goBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc fileprivate func openMenu() {
        let menuController = MenuViewController()
        menuController.transitioningDelegate = self
        menuController.interactor = interactor
        navigationController?.present(menuController, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleEdgePanGesture(sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let progress = MenuHelper.calculateProgress(translationInView: translation, viewBounds: view.bounds, direction: .right)
        
        MenuHelper.mapGestureStateToInteractor(gestureState: sender.state, progress: progress, interactor: interactor) {
            self.openMenu()
        }
    }

}

extension MainViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
