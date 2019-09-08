//
//  Bindable.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by James Czepiel on 1/2/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) ->()) {
        self.observer = observer
    }
}
