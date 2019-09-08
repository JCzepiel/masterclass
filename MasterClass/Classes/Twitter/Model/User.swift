//
//  User.swift
//  TwitterLBTA
//
//  Created by James Czepiel on 9/16/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import Foundation
import UIKit

struct User: Decodable {
    let name: String
    let username: String
    let bio: String
    let profileImageUrl: String

}

struct UserCodable: Codable {
    let id: Int
    let name: String
    let username: String
    let bio: String
    let profileImageUrl: String
}
