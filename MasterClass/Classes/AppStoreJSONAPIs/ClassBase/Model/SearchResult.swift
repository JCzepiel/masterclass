//
//  SearchResult.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/18/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import Foundation


struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Result]
}

struct Result: Decodable {
    let trackId: Int
    let trackName: String
    let primaryGenreName: String
    let averageUserRating: Double?
    let screenshotUrls: [URL]?
    let artworkUrl100: URL
    let userRatingCount: Double?
    let formattedPrice: String?
    let description: String?
    let releaseNotes: String?
    let artistName: String?
    let collectionName: String?
}

extension Result: SearchDisplayable {
    var ratingValue: Double {
        return averageUserRating ?? 0
    }
    
    var nameText: String {
        return trackName
    }
    
    var categoryText: String {
        return primaryGenreName
    }
    
    var ratingText: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let numberString = numberFormatter.string(from: NSNumber(value: userRatingCount ?? 0)) ?? "0"
        return numberString
    }
    
    var appIconImageURL: URL? {
        return artworkUrl100
    }
    
    var screenshotImageURLs: [URL?] {
        return screenshotUrls ?? []
    }
}
