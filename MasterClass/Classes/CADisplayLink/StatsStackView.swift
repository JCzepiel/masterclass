//
//  StatsStackView.swift
//  CADisplayLinkLBTA
//
//  Created by James Czepiel on 11/28/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import Foundation
import UIKit

class StatsStackView: UIStackView {
    
    let countingLabel1 = CountingLabel(startValue: 100, endValue: 150, animationDuration: 1.5)
    let countingLabel2 = CountingLabel(startValue: 5, endValue: 50, animationDuration: 2.0)
    let countingLabel3 = CountingLabel(startValue: 1, endValue: 10, animationDuration: 2.5)
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addArrangedSubview(countingLabel1)
        addArrangedSubview(countingLabel2)
        addArrangedSubview(countingLabel3)
        
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        distribution = .fillEqually
        //layoutMargins = UIEdgeInsets(top: 32, left: 32, bottom: 32, right: 32)
        //isLayoutMarginsRelativeArrangement = true
        backgroundColor = .purple
        
    }
}
