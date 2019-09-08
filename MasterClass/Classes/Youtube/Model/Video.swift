//
//  Video.swift
//  youttube
//
//  Created by James Czepiel on 10/4/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit

struct Video: Decodable {
    var thumbnail_image_name: String?
    var title: String?
    var number_of_views: Double?
    var duration: Int?
    
    var channel: Channel?
}
