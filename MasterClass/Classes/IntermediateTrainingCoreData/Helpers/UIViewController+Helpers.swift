//
//  UIViewController+Helpers.swift
//  IntermediateTrainingCoreData
//
//  Created by James Czepiel on 3/25/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func setupPlusButtonInNavigationBar(selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: selector)
    }
    
    func setupCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelModal))
    }
    
    @objc fileprivate func handleCancelModal() {
        dismiss(animated: true, completion: nil)
    }
    
    @discardableResult func setupLightBlueBackgroundView(height: CGFloat) -> UIView {
        let lightBlueBackgroundView = UIView()
        lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        lightBlueBackgroundView.backgroundColor = .lightBlue
        view.addSubview(lightBlueBackgroundView)
        lightBlueBackgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        lightBlueBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        lightBlueBackgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: height).isActive = true
        return lightBlueBackgroundView
    }
}
