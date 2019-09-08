//
//  BlankViewController.swift
//  MasterClass
//
//  Created by James Czepiel on 2/18/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class BlankViewController: UIViewController {

    var controllerTitle = "No title Given"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        title = controllerTitle
    }
}
