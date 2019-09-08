//
//  TypingLabel.swift
//  CADisplayLinkLBTA
//
//  Created by James Czepiel on 11/28/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import Foundation
import UIKit

class TypingLabel: UILabel {
    
    fileprivate let desiredEndString: String
    fileprivate let animationDuration: Double
    fileprivate let animationStartDate = Date()
    fileprivate var displayLinkWords = CADisplayLink()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(desiredEndString: String, animationDuration: Double) {
        self.desiredEndString = desiredEndString
        self.animationDuration = animationDuration
        
        super.init(frame: .zero)
        
        numberOfLines = 0
        textAlignment = .left
        font = UIFont.boldSystemFont(ofSize: 18)
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .lightGray
        
        displayLinkWords = CADisplayLink(target: self, selector: #selector(handleUpdateWords))
        displayLinkWords.add(to: .main, forMode: .default)
    }
    
    @objc func handleUpdateWords() {
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStartDate)
        
        if elapsedTime > animationDuration {
            text = desiredEndString
            //We reached the end value, now we can remove the display link
            displayLinkWords.remove(from: .main, forMode: .default)
        } else {
            let percentage = elapsedTime / animationDuration
            let indexForPercentage = Double(desiredEndString.count) * percentage
            
            let lowerBound = String.Index(encodedOffset: 0)
            let upperBound = String.Index(encodedOffset: Int(indexForPercentage))
            
            let value = desiredEndString[lowerBound..<upperBound]
            text = "\(value)"
        }
    }
}
