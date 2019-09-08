//
//  Tweet.swift
//  TwitterLBTA
//
//  Created by James Czepiel on 9/17/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import Foundation

struct Tweet: Decodable {
    let user: User
    let message: String
}

struct TweetCodable: Codable {
    let user: UserCodable
    let image: ImageCodable
    let message: String
}

struct ImageCodable: Codable {
    let width: Int
    let height: Int
    let imageUrl: String
}
