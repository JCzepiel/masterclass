//
//  APIResponseModel.swift
//  MasterClass
//
//  Created by James Czepiel on 2/25/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import Foundation

struct APIResponseModel: Decodable {
    let users: [User]
    let tweets: [Tweet]
}
