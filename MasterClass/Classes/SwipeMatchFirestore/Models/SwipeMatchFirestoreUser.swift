//
//  SwipeMatchFirestoreUser.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by James Czepiel on 12/18/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit

struct SwipeMatchFirestoreUser: ProducesCardViewModel {
    
    static let defaultMinAge = 18
    static let defaultMaxAge = 45

    var name: String?
    var age: Int?
    var profession: String?
    var imageUrl1: String?
    var imageUrl2: String?
    var imageUrl3: String?
    var uid: String?
    //let imageNames: [String]
    
    var minSeekingAge: Int?
    var maxSeekingAge: Int?
    
    init(dictionary: [String: Any]) {
        //self.imageNames = [imageUrl]

        self.name = dictionary["fullName"] as? String ?? ""
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.imageUrl2 = dictionary["imageUrl2"] as? String
        self.imageUrl3 = dictionary["imageUrl3"] as? String
        self.uid = dictionary["uid"] as? String ?? ""
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int
    }
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        
        var ageString = "N/A"
        if let hasAge = age {
            ageString = "\(hasAge)"
        }
        attributedText.append(NSAttributedString(string: " \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        let professionString = profession ?? "Not available"
        attributedText.append(NSAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        var imageUrls = [String]()
        if let urlString = imageUrl1 { imageUrls.append(urlString) }
        if let urlString = imageUrl2 { imageUrls.append(urlString) }
        if let urlString = imageUrl3 { imageUrls.append(urlString) }

        return CardViewModel(uid: uid ?? "", imageNames: imageUrls, attributedString: attributedText, textAlignment: .left)
    }
}

