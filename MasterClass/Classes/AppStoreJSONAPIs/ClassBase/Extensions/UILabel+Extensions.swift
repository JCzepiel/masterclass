//
//  UILabel+Extensions.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/19/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
    }
}
