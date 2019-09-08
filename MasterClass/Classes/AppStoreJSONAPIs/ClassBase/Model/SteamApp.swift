//
//  SteamApp.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/18/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import Foundation

struct SteamAppResultRaw: Decodable {
    let response: SteamAppResult
}

struct SteamAppResult: Decodable {
    let game_count: Int
    let games: [SteamApp]
}

struct SteamApp: Decodable {
    let appid: Int
    let name: String
    let playtime_forever: Int
    let playtime_2weeks: Int?
    let img_icon_url: String
    let img_logo_url: String
    let has_community_visible_stats: Bool?
}

extension SteamApp: SearchDisplayable {
    var trackId: Int {
        return appid
    }
    
    var ratingValue: Double {
        return 0
    }
    
    var nameText: String {
        return name
    }
    
    var categoryText: String {
        return String(appid)
    }
    
    var ratingText: String {
        return "Played: " + String(playtime_forever)
    }
    
    var appIconImageURL: URL? {
        return URL(string: "http://media.steampowered.com/steamcommunity/public/images/apps/\(appid)/\(img_icon_url).jpg")
    }
    
    var screenshotImageURLs: [URL?] {
        return [URL(string: "http://media.steampowered.com/steamcommunity/public/images/apps/\(appid)/\(img_logo_url).jpg")]
    }
}
