//
//  CubeAnimationViewController.swift
//  CubeAnimation
//
//  Created by James Czepiel on 7/15/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class CubeAnimationViewController: UIViewController {
    
    var scrollView = StoriesScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        layout()
    }

    func layout() {
        let extraHeight = CGFloat(self.navigationController?.navigationBar.frame.height ?? 0) + CGFloat(UIApplication.shared.statusBarFrame.height)
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - extraHeight)
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        let story1 = UIView()
        story1.backgroundColor = .orange
        let story2 = UIView()
        story2.backgroundColor = .red
        let story3 = UIView()
        story3.backgroundColor = .blue
        let story4 = UIView()
        story4.backgroundColor = .green
        scrollView.setDataSource(with: [story1, story2, story3, story4])
    }
}

extension CubeAnimationViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleViews = self.scrollView.visibleViews().sorted(by: { $0.frame.origin.x > $1.frame.origin.x })
        let xOffset = scrollView.contentOffset.x
        
        let rightViewAnchorPoint = CGPoint(x: 0, y: 0.5)
        let leftViewAnchorPoint = CGPoint(x: 1, y: 0.5)
        
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / 1000
        
        let leftSideOriginalTransform = CGFloat(90 * Double.pi / 180.0)
        let rightSideOriginalTransform = CGFloat(90 * Double.pi / 180.0)
        
        if let viewFurthestRight = visibleViews.first, let viewFurthestLeft = visibleViews.last {
            let hasCompletedPaging = (xOffset / scrollView.frame.width).truncatingRemainder(dividingBy: 1) == 0
            var rightAnimationPercentComplete = hasCompletedPaging ? 0 : 1 - (xOffset / scrollView.frame.width).truncatingRemainder(dividingBy: 1)
            if xOffset < 0 {
                rightAnimationPercentComplete -= 1
            }
            viewFurthestRight.transform(to: rightSideOriginalTransform * rightAnimationPercentComplete, with: transform)
            viewFurthestRight.setAnchorPoint(rightViewAnchorPoint)

            if xOffset > 0 {
                let leftAnimationPercentComplete = (xOffset / scrollView.frame.width).truncatingRemainder(dividingBy: 1)
                viewFurthestLeft.transform(to: leftSideOriginalTransform * leftAnimationPercentComplete, with: transform)
                viewFurthestLeft.setAnchorPoint(leftViewAnchorPoint)
            }
        }
    }
}

extension UIView {
    func transform(to radians: CGFloat, with transform: CATransform3D) {
        layer.transform = CATransform3DRotate(transform, radians, 0, 1, 0.0)
    }
    
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = point
    }
}
