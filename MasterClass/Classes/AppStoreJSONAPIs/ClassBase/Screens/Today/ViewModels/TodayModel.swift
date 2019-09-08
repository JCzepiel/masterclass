//
//  TodayModel.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/26/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

struct TodayModel {
    
    enum CellType: String {
        case single
        case multiple
    }
    
    let cellType: CellType
    
    let category: String
    let title: String
    let image: UIImage
    let description: String
    let backgroundColor: UIColor
    
    let apps: [FeedResult]
}
