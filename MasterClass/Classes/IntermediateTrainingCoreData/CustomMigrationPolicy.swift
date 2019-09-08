//
//  CustomMigrationPolicy.swift
//  IntermediateTrainingCoreData
//
//  Created by James Czepiel on 3/28/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import Foundation
import CoreData

class CustomMigrationPolicy: NSEntityMigrationPolicy {
    @objc func transformNumEmployes(forNum: NSNumber) -> String {
        print("hi with int = \(forNum)")
        if forNum.intValue < 150 {
            return "Small"
        } else {
            return "Very large"
        }
        
    }
}
