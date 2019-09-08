//
//  Models.swift
//  appstore1
//
//  Created by James Czepiel on 9/19/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit

struct BaseAPIResponse: Codable {
    var bannerCategory: BannerCategory
    var categories: [AppCategory]
}

struct BannerCategory: Codable {
    var name: String
    var apps: [App]
    var type: String
    
    func convertBannerCategoryToAppCategoryUsing() -> AppCategory {
        let appCategory = AppCategory()
        appCategory.name = self.name
        appCategory.type = self.type
        appCategory.apps = self.apps
        return appCategory
    }
}

class AppCategory: NSObject, Codable {
    var name: String?
    var type: String?
    var apps: [App]?
    
    override var description: String {
        return "\n \n \(String(describing: self.name)) \(String(describing: self.type)) \(String(describing: self.apps)) \n \n"
    }
    
    static func fetchFeatureApps(completionHandler: @escaping ([AppCategory], AppCategory) -> ()) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/featured"
        
        URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            if error != nil {
                print(error as Any)
                return
            }
            
            do {
                var appCategories = [AppCategory]()
                let baseResponse = try JSONDecoder().decode(BaseAPIResponse.self, from: data!)
                
                
                for aCategory in baseResponse.categories {
                    appCategories.append(aCategory)
                }
                
                DispatchQueue.main.async {
                    completionHandler(appCategories, baseResponse.bannerCategory.convertBannerCategoryToAppCategoryUsing())
                }
            } catch let err {
                print(err)
            }
            
        }.resume()
    }
    
    static func sampleAppCategories() -> [AppCategory] {
        
        let bestNewAppCategory = AppCategory()
        bestNewAppCategory.name = "Best New App"
        
        var apps = [App]()
        
        let frozenApp = App()
        frozenApp.Name = "Disney Build It: Frozen"
        frozenApp.ImageName = "frozen"
        frozenApp.Category = "Entertainment"
        frozenApp.Price = 3.99
        
        apps.append(frozenApp)
        
        bestNewAppCategory.apps = apps
        
        
        let bestNewGamesCategory = AppCategory()
        bestNewAppCategory.name = "Best New Games"
        
        var bestNewGamesApps = [App]()
        
        let telepaintApp = App()
        telepaintApp.Name = "Telepaint"
        telepaintApp.Category = "Games"
        telepaintApp.Price = 3.99
        telepaintApp.ImageName = "telepaint"
        
        bestNewGamesApps.append(telepaintApp)
        
        bestNewGamesCategory.apps = bestNewGamesApps
        
        return [bestNewAppCategory, bestNewGamesCategory]
    }
}

class App: NSObject, Codable {
    override var description: String {
        return "\(String(describing: self.Id)) \(String(describing: self.Name)) \(String(describing: self.Category)) \(String(describing: self.ImageName)) \(String(describing: self.Price))"
    }
    
    
    var Id: Int?
    var Name: String?
    var Category: String?
    var ImageName: String?
    var Price: Double?
}
