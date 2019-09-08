//
//  Service.swift
//  TwitterLBTA
//
//  Created by James Czepiel on 9/17/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import Foundation

struct Service {
    
    //let tron = TRON(baseURL: "https://api.letsbuildthatapp.com/")
    
    static let sharedInstance = Service()
    
    func fetchHomeFeed(completion: @escaping (HomeDataSource?, Error?) -> ()) {        
        let urlString = "https://api.letsbuildthatapp.com/twitter/home"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, resposne, error) in
            guard let data = data else {
                print("error fetching = \(String(describing: error))")
                completion(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let apiResponse = try decoder.decode(APIResponseModel.self, from: data)
                let homeDatasource = HomeDataSource()
                homeDatasource.users = apiResponse.users.map { User(name: $0.name, username: $0.username, bio: $0.bio, profileImageUrl: $0.profileImageUrl) }
                homeDatasource.tweets = apiResponse.tweets.map {
                    let newUserFromTweet = User(name: $0.user.name, username: $0.user.username, bio: $0.user.bio, profileImageUrl: $0.user.profileImageUrl)
                    return Tweet(user: newUserFromTweet, message: $0.message)
                }
                completion(homeDatasource, nil)
            } catch let error {
                print("error fetching = \(error)")
                completion(nil, error)
            }
        }.resume()
        
        
        completion(nil, nil)
    }
    
    class Home: Codable {
        let users: [UserCodable]
        let tweets: [TweetCodable]
    }
    
    class JSONError: Codable {
        
    }
    
}
