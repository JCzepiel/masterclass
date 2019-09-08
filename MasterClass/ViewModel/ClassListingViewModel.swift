//
//  ClassListingViewModel.swift
//  MasterClass
//
//  Created by James Czepiel on 2/18/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import Foundation

class ClassListingViewModel {
    
    let apiService = API()
    var allClasses = [ClassModel]()
    
    func numberOfClasses() -> Int {
        return allClasses.count
    }
    
    func classAtIndex(index: Int) -> ClassModel? {
        return allClasses[index]
    }
    
    func loadClassesData(completion: @escaping () -> ()) {
        apiService.loadClassesData { [weak self] allClasses in
            if let allClasses = allClasses {
                self?.allClasses = allClasses
            }
            
            completion()
        }
    }
}
