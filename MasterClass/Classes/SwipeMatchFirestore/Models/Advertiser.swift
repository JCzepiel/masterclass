//
//  Advertiser.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by James Czepiel on 12/19/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit

struct Advertiser: ProducesCardViewModel {
    let title: String
    let brandName: String
    let posterPhotoNames: [String]
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
        attributedText.append(NSAttributedString(string: "\n\(brandName)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        return CardViewModel(uid: "", imageNames: posterPhotoNames, attributedString: attributedText, textAlignment: .center)
    }
}
