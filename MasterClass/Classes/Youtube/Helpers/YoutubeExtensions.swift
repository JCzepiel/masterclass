//
//  YoutubeExtensions.swift
//  youttube
//
//  Created by James Czepiel on 10/4/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit

extension UIView {
    func addConstraintsWithFormat(format: String, view: UIView...) {
        var allViews = [String: UIView]()
        for (index, object) in view.enumerated() {
            let key = "v\(index)"
            object.translatesAutoresizingMaskIntoConstraints = false
            allViews[key] = object
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: allViews))
    }
}
