//
//  DataLoader.swift
//  youttube
//
//  Created by James Czepiel on 10/4/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit

enum SectionType: String {
    case home = "home"
    case trending = "trending"
    case subscriptions = "subscriptions"
}

class DataLoader {
    static let shared = DataLoader()
    
    func loadVideos(for section: SectionType = .home, completion: @escaping ([Video]) -> ()) {
        let location = section.rawValue
        URLSession.shared.dataTask(with: URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/\(location).json")!) { data, response, error in
            guard let data = data else {
                completion([])
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let allVideos = try decoder.decode([Video].self, from: data)
                completion(allVideos)

            } catch let error {
                print("error = \(error)")
                completion([])
            }
        }.resume()
    }
    
    let imageCache = NSCache<NSString, UIImage>()
    
    func loadImage(using url: String, completion: @escaping (UIImage?) -> ()) {
        
        if let hasImage = imageCache.object(forKey: url as NSString) {
            completion(hasImage)
        }
        
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            self.imageCache.setObject(image!, forKey: url as NSString)
            completion(image)
            
        }.resume()
    }
}
