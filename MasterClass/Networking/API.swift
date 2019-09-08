//
//  API.swift
//  MasterClass
//
//  Created by James Czepiel on 2/18/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import Foundation

class API {
    func loadClassesData(completion: @escaping ([ClassModel]?) -> ()) {
        if let path = Bundle.main.path(forResource: "Classes", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let allClasses = try decoder.decode([ClassModel].self, from: data)
                completion(allClasses)
                
            } catch(let error) {
                print("Error loading class data: \(error)")
                completion(nil)
            }
        } else {
            print("Error loading path")
            completion(nil)
        }
    }
}
