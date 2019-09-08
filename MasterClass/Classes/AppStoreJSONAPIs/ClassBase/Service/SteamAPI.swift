//
//  SteamAPI.swift
//  AppStoreJSONAPIs
//
//  Created by James Czepiel on 4/18/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import Foundation

class SteamAPI {
    static let shared = SteamAPI()
    
    func fetchGames(completion: @escaping (SteamAppResult?, Error?) -> ()) {
        let urlString = "https://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?steamid=76561197988974102&include_appinfo=1&format=json&include_played_free_games=1&key=B21F9792743467755074C45D20F4DA94"
        guard let url = URL(string: urlString) else { return }
        
        print("URL: \(urlString)")
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(SteamAppResultRaw.self, from: data)
                completion(result.response, nil)
                
            } catch let error {
                print(error)
                completion(nil, error)
            }
            
            }.resume()
    }
}
