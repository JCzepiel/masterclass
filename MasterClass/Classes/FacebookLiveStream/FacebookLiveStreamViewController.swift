//
//  FacebookLiveStreamViewController.swift
//  FacebookLiveStreamLBTA
//
//  Created by James Czepiel on 11/29/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit

class FacebookLiveStreamViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = .white

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc func handleTap() {
        (0...10).forEach { (_) in
            generateAnimatedViews()
        }
    }
    
    func generateAnimatedViews() {
        let image = drand48() > 0.5 ? #imageLiteral(resourceName: "thumbs_up") : #imageLiteral(resourceName: "heart")
        let imageView = UIImageView(image: image)
        let dimension = 20 + drand48() * 10
        imageView.frame = CGRect(x: 0, y: 0, width: dimension, height: dimension)
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = customPath().cgPath
        let randomDuration = 2 + drand48() * 3
        animation.duration = randomDuration
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        imageView.layer.add(animation, forKey: nil)
        
        view.addSubview(imageView)
    }
    
    func customPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 400))
        
        let endPoint = CGPoint(x: 400, y: 200)
        
        let randomYShift = 200 + drand48() * 300
        let cp1 = CGPoint(x: 100, y: 100 - randomYShift)
        let cp2 = CGPoint(x: 200, y: 300 + randomYShift)
        path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
        
        return path
    }
}


