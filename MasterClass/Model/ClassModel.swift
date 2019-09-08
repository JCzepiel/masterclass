//
//  ClassModel.swift
//  MasterClass
//
//  Created by James Czepiel on 2/18/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import Foundation

struct ClassModel: Codable {
    let id: Int
    let creator: String
    let title: String
    let description: String
    let isImplemented: Bool
}
