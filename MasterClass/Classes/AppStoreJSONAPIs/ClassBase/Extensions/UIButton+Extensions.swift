//
//  UIButton+Extensions.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/22/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init(title: String) {
        self.init(type: .system)
        setTitle(title, for: .normal)
    }
}
