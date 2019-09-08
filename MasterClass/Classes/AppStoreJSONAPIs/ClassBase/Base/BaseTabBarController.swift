//
//  BaseTabBarController.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/18/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
                            createNavigationController(viewController: TodayController(), title: "Today", imageName: "today"),
                            createNavigationController(viewController: MusicController(), title: "Music", imageName: "music"),
                            createNavigationController(viewController: AppsPageController(), title: "Apps", imageName: "apps"),
                            createNavigationController(viewController: SearchController(), title: "Search", imageName: "search"),
        ]
    }
    
    fileprivate func createNavigationController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = UIImage(named: imageName)
        
        viewController.view.backgroundColor = .white
        viewController.navigationItem.title = title
        
        return navigationController
    }
}
