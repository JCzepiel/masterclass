//
//  SearchDisplayable.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/18/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import Foundation

protocol SearchDisplayable {
    var trackId: Int { get }
    var nameText: String { get }
    var categoryText: String { get }
    var ratingText: String { get }
    var ratingValue: Double { get }
    var appIconImageURL: URL? { get }
    var screenshotImageURLs: [URL?] { get }
}
