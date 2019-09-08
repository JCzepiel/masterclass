//
//  MenuHelper.swift
//  InteractiveSlideoutMenu
//
//  Created by James Czepiel on 3/4/19.
//  Copyright © 2019 Thorn Technologies, LLC. All rights reserved.
//

import Foundation
import UIKit

enum UpDownSlideDirection {
    case up
    case down
    case left
    case right
}

struct UpDownSlideMenuHelper {
    static let menuWidth: CGFloat = 0.8
    static let percentThreshold: CGFloat = 0.3
    static let snapshotNumber = 12345
    
    static func calculateProgress(translationInView: CGPoint, viewBounds: CGRect, direction: UpDownSlideDirection) -> CGFloat {
        let pointOnAxis: CGFloat
        let axisLength: CGFloat
        
        switch direction {
        case .up, .down:
            pointOnAxis = translationInView.y
            axisLength = viewBounds.height/2 // Divide by 2 because when swiping up/down, the incoming/outgoing view is only have the size of the screen
        case .left, .right:
            pointOnAxis = translationInView.x
            axisLength = viewBounds.width
        }
        
        let movementOnAxis = pointOnAxis / axisLength
        let positiveMovementOnAxis: Float
        let positiveMovementOnAxisPercent: Float
        
        switch direction {
        case .right, .down: //Positive
            positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
            positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
            return CGFloat(positiveMovementOnAxisPercent)
        case .left, .up: // Negative
            positiveMovementOnAxis = fminf(Float(movementOnAxis), 0.0)
            positiveMovementOnAxisPercent = fmaxf(positiveMovementOnAxis, -1.0)
            return CGFloat(-positiveMovementOnAxisPercent)
        }
    }
    
    static func mapGestureStateToInteractor(gestureState: UIGestureRecognizer.State, progress: CGFloat, interactor: UpDownSlideInteractor?, triggerSegue: () -> Void) {
        guard let interactor = interactor else { return }
        
        switch gestureState {
        case .began:
            interactor.hasStarted = true
            triggerSegue()
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish ? interactor.finish() : interactor.cancel()
        case .possible:
            return
        case .failed:
            return 
        }
    }
}


