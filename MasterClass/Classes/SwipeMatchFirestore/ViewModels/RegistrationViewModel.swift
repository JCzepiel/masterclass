//
//  RegistrationViewModel.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by James Czepiel on 1/2/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewModel {
    
    // MARK: - Properties
    
    var bindableIsRegistering = Bindable<Bool>()
    
    var bindableImage = Bindable<UIImage>()
    
    var fullName: String? {
        didSet {
            checkFormValidity()
        }
    }
    
    var email: String? {
        didSet {
            checkFormValidity()
        }
    }
    
    var password: String? {
        didSet {
            checkFormValidity()
        }
    }
    
    var bindableIsFormValid = Bindable<Bool>()
    
    // MARK: - Methods
    
    func performRegistration(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else { return }

        bindableIsRegistering.value = true
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { [unowned self] result, error in
            if let error = error {
                print(error)
                completion(error)
                return
            }
            
            self.saveImageToFirebase(completion: completion)
            
        })
    }
    
    // MARK: - Fileprivate
    
    fileprivate func saveImageToFirebase(completion: @escaping ((Error?) -> ())) {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        
        ref.putData(imageData, metadata: nil, completion: { (storageMetadata, error) in
            if let error = error {
                print(error)
                completion(error)
                return
            }
            
            ref.downloadURL(completion: { (url, error) in
                if let error = error {
                    print(error)
                    completion(error)
                    return
                }
                
                self.bindableIsRegistering.value = false
                
                let imageUrl = url?.absoluteString ?? ""
                self.saveInfoToFirestore(imageUrl: imageUrl, completion: completion)
            })
        })
    }
    
    fileprivate func saveInfoToFirestore(imageUrl: String, completion: @escaping ((Error?) -> ())) {
        let documentPath = Auth.auth().currentUser?.uid ?? ""
        let documentDictionary: [String: Any] = ["fullName": fullName ?? "",
                                  "uid": documentPath,
                                  "imageUrl1": imageUrl,
                                  "age": SwipeMatchFirestoreUser.defaultMinAge,
                                  "minSeekingAge": SwipeMatchFirestoreUser.defaultMinAge,
                                  "maxSeekingAge": SwipeMatchFirestoreUser.defaultMaxAge]
        
        Firestore.firestore().collection("users").document(documentPath).setData(documentDictionary) { error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false && bindableImage.value != nil
        bindableIsFormValid.value = isFormValid
    }
}
