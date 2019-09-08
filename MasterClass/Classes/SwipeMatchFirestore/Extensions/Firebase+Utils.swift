//
//  Firebase+Utils.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by James Czepiel on 1/7/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import Firebase

extension Firestore {
    func fetchCurrentUser(completion: @escaping (SwipeMatchFirestoreUser?, Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil, NSError(domain: "Cannot get current user uid", code: 46, userInfo: nil))
            return
        }
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("error fetching current user with error = \(error)")
                completion(nil, error)
                return
            }
            
            guard let userDictionary = snapshot?.data() else {
                completion(nil, NSError(domain: "Cannot create user dictionary", code: 45, userInfo: nil))
                return
            }
            let user = SwipeMatchFirestoreUser(dictionary: userDictionary)
            
            completion(user, nil)
        }
    }
}
