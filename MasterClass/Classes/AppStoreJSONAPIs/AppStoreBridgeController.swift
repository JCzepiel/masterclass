//
//  AppStoreBridgeController.swift
//  MasterClass
//
//  Created by James Czepiel on 5/3/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class AppStoreBridgeController: UITableViewController {
    
    fileprivate let cellId = "cellId"
    fileprivate let introMessage = "This lesson uses a tabbarcontroller for navigation. since we can't copy that implementation for this app I just made this tableview to link into each viewcontroller from the lesson. Otherwise all functionality is the same."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = .black
        
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}

extension AppStoreBridgeController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .black
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = introMessage
            cell.textLabel?.textAlignment = .center
            cell.isUserInteractionEnabled = false
        case 1:
            cell.textLabel?.text = "Today"
        case 2:
            cell.textLabel?.text = "Music"
        case 3:
            cell.textLabel?.text = "Apps"
        case 4:
            cell.textLabel?.text = "Search"
        default:
            cell.textLabel?.text = ""
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            let newController = TodayController()
            navigationController?.pushViewController(newController, animated: true)
        case 2:
            let newController = MusicController()
            navigationController?.pushViewController(newController, animated: true)
        case 3:
            let newController = AppsPageController()
            navigationController?.pushViewController(newController, animated: true)
        case 4:
            let newController = SearchController()
            navigationController?.pushViewController(newController, animated: true)
        default:
            return
        }
    }
}
