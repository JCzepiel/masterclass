//
//  AppReviews.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/25/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import Foundation

struct AppReviews: Decodable {
    let feed: ReviewsFeed
}

struct ReviewsFeed: Decodable {
    let entry: [Entry]
}

struct Entry: Decodable {
    let title: ReviewsTitle
    let content: ReviewsBody
    let rating: ReviewsRating
    let author: ReviewsAuthor
    
    private enum CodingKeys: String, CodingKey {
        case title, content, author
        case rating = "im:rating"
    }
}

struct ReviewsTitle: Decodable {
    let label: String
}

struct ReviewsBody: Decodable {
    let label: String
}

struct ReviewsAuthor: Decodable {
    let name: ReviewsAuthorName
}

struct ReviewsAuthorName: Decodable {
    let label: String
}

struct ReviewsRating: Decodable {
    let label: String
}
