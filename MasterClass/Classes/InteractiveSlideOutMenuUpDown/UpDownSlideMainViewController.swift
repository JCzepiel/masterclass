//
//  MainViewController.swift
//  InteractiveSlideoutMenu
//
//  Created by Robert Chen on 2/7/16.
//  Copyright © 2016 Thorn Technologies, LLC. All rights reserved.
//
//  From https://www.thorntech.com/2016/03/ios-tutorial-make-interactive-slide-menu-swift/

import UIKit

class UpDownSlideMainViewController: UIViewController {
    
    let interactor = UpDownSlideInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(openMenu))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        view.backgroundColor = .blue
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(sender:))))
    }
    
    @objc fileprivate func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func openMenu() {
        let menuController = UpDownSlideMenuViewController()
        menuController.transitioningDelegate = self
        menuController.interactor = interactor
        menuController.modalPresentationStyle = .custom // This causes the fromVC to NOT disappear after the animation is complete. Interesting...
        navigationController?.present(menuController, animated: true, completion: nil)
    }
    
    @objc fileprivate func handlePanGesture(sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let progress = UpDownSlideMenuHelper.calculateProgress(translationInView: translation, viewBounds: view.bounds, direction: .up)
        
        UpDownSlideMenuHelper.mapGestureStateToInteractor(gestureState: sender.state, progress: progress, interactor: interactor) {
            self.openMenu()
        }
    }

}

extension UpDownSlideMainViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return UpDownSlidePresentMenuAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return UpDownSlideDismissMenuAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
