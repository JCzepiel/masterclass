//
//  RegistrationPageTextField.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by James Czepiel on 12/21/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit

class RegistrationPageTextField: UITextField {
    
    let padding: CGFloat
    
    init(padding: CGFloat) {
        self.padding = padding
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = intrinsicContentSize.height / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: 50)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
}
