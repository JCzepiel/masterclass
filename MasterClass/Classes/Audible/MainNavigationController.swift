//
//  MainNavigationController.swift
//  audible
//
//  Created by James Czepiel on 10/2/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
                
        if isLoggedIn() {
            let homeController = AudibleHomeController()
            viewControllers = [homeController]
        } else {
            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
        }
    }
    
    fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.isLoggedIn()
    }
    
    @objc func showLoginController() {
        let loginController = AudibleLoginController()
        present(loginController, animated: true, completion: { })
    }
}

