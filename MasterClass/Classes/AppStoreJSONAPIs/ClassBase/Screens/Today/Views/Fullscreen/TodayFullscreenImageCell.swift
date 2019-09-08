//
//  TodayFullscreenImageCell.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/26/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class TodayFullscreenImageCell: UITableViewCell {
    
    let todayCell = TodayCell()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        addSubview(todayCell)
        todayCell.fillSuperview()
    }
}
