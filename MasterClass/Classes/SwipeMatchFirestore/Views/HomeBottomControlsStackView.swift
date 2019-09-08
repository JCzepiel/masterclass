//
//  HomeBottomControlsStackView.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by James Czepiel on 12/17/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {
    
    // MARK: - View Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [#imageLiteral(resourceName: "refresh_circle"), #imageLiteral(resourceName: "dismiss_circle"), #imageLiteral(resourceName: "super_like_circle"), #imageLiteral(resourceName: "like_circle"), #imageLiteral(resourceName: "boost_circle")].forEach { (image)  in
            let button = UIButton(type: .custom)
            button.setImage(image, for: .normal)
            addArrangedSubview(button)
        }
        
        distribution = .fillEqually
        axis = .horizontal
        heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
