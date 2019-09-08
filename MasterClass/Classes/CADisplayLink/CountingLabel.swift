//
//  CountingLabel.swift
//  CADisplayLinkLBTA
//
//  Created by James Czepiel on 11/28/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import Foundation
import UIKit

class CountingLabel: UILabel {
    
    fileprivate var startValue: Double
    fileprivate var displayLink = CADisplayLink()
    fileprivate let endValue: Double
    fileprivate let animationDuration: Double
    fileprivate let animationStartDate = Date()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(startValue: Double, endValue: Double, animationDuration: Double) {
        self.startValue = startValue
        self.endValue = endValue
        self.animationDuration = animationDuration
        
        super.init(frame: .zero)
    
        backgroundColor = .white
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        text = String(startValue)
        textAlignment = .center
        font = UIFont.boldSystemFont(ofSize: 18)
        translatesAutoresizingMaskIntoConstraints = false
        
        displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
        displayLink.add(to: .main, forMode: .default)
    }
    
    @objc func handleUpdate() {
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStartDate)
        
        if elapsedTime > animationDuration {
            setTextFromDouble(doubleText: endValue)
            //We reached the end value, now we can remove the display link
            displayLink.remove(from: .main, forMode: .default)
        } else {
            let percentage = elapsedTime / animationDuration
            let value = startValue + percentage * (endValue - startValue)
            setTextFromDouble(doubleText: value)
        }
    }
    
    fileprivate func setTextFromDouble(doubleText: Double) {
        self.text = String(format: "%.2f", doubleText)
    }
}
