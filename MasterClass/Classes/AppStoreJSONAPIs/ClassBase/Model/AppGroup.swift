//
//  AppGroup.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/23/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import Foundation

struct AppGroup: Decodable {
    let feed: Feed
}

struct Feed: Decodable {
    let title: String
    let results: [FeedResult]
}

struct FeedResult: Decodable {
    let artistName: String
    let name: String
    let artworkUrl100: URL
    let id: String
}
