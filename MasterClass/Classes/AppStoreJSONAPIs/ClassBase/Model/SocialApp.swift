//
//  SocialApp.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/24/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import Foundation

struct SocialApp: Decodable {
    let id: String
    let name: String
    let imageUrl: URL
    let tagline: String
}
