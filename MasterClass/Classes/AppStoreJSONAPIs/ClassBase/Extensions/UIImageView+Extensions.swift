//
//  UIImageView+Extensions.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/22/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

extension UIImageView {
    convenience init(cornerRadius: CGFloat) {
        self.init(image: nil)
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        contentMode = .scaleAspectFill
    }
}
