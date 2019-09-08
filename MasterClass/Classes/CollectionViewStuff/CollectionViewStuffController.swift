//
//  CollectionViewStuffController.swift
//  MasterClass
//
//  Created by James Czepiel on 5/15/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class CollectionViewStuffController: UITableViewController {
    
    fileprivate let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .black
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
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
            let attributedString = NSMutableAttributedString(string: "1. CollectionViewScalingAlphaAndSize", attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
            attributedString.append(NSMutableAttributedString(string: "\nThis is a custom CV layout that scales the size and alpha of the cells as you swipe. I see a lot of apps do this and I wanted to replicate it.", attributes: [.font: UIFont.systemFont(ofSize: 14)]))
            cell.textLabel?.attributedText = attributedString
        case 1:
            let attributedString = NSMutableAttributedString(string: "2. CollectionViewSnappingAndAlphaAndSize", attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
            attributedString.append(NSMutableAttributedString(string: "\nThis is the same as #1 with additional layout code to perform a snapping behavior on swipe.", attributes: [.font: UIFont.systemFont(ofSize: 14)]))
            cell.textLabel?.attributedText = attributedString
        case 2:
            let attributedString = NSMutableAttributedString(string: "3. CollectionViewPanningControl", attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
            attributedString.append(NSMutableAttributedString(string: "\nThis mimics a cool control I encounted in the NBCSports 'MyTeams' app.", attributes: [.font: UIFont.systemFont(ofSize: 14)]))
            cell.textLabel?.attributedText = attributedString
        case 3:
            let attributedString = NSMutableAttributedString(string: "4. CollectionViewColorCodeTester", attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
            attributedString.append(NSMutableAttributedString(string: "\nThis isn't actually a CV oh well. It is code used to test some custom Color logic I wrote when learning about the HSB (Hue, Saturation, Brightness) color model. This code generates a random color and then makes it darker incrementally.", attributes: [.font: UIFont.systemFont(ofSize: 14)]))
            cell.textLabel?.attributedText = attributedString
        case 4:
            let attributedString = NSMutableAttributedString(string: "5. CollectionViewLegacyAlphaAndSize", attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
            attributedString.append(NSMutableAttributedString(string: "\nThis is an earlier implementation of #1 that I wrote from scratch for my first try. It is bad and worse than #1 but I'd like to keep it around. This is also a control I noticed from the NBCSports 'MyTeams' app and I wanted to replicate it.", attributes: [.font: UIFont.systemFont(ofSize: 14)]))
            cell.textLabel?.attributedText = attributedString
        default:
            cell.textLabel?.text = ""
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let newController = CollectionViewScalingAlphaAndSizeController()
            navigationController?.pushViewController(newController, animated: true)
        case 1:
            let newController = CollectionViewSnappingAndAlphaAndSizeController()
            navigationController?.pushViewController(newController, animated: true)
        case 2:
            let newController = CollectionViewPanningControl()
            navigationController?.pushViewController(newController, animated: true)
        case 3:
            let newController = CollectionViewColorCodeTester()
            navigationController?.pushViewController(newController, animated: true)
        case 4:
            let newController = CollectionViewLegacyAlphaAndSizeController()
            navigationController?.pushViewController(newController, animated: true)
        default:
            return
        }
    }
}
