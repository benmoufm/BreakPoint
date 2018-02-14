//
//  AuthentificationService.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 26/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import Foundation
import Firebase
import FBSDKCoreKit

class AuthentificationService {
    static let instance = AuthentificationService()

    func registerUser(withEmail email: String, andPassword password: String,
                      completion: @escaping (_ status: Bool,_ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user else {
                completion(false, error)
                return
            }
            let userData = ["provider": user.providerID,
                            "email": user.email as Any]
            DataService.instance.createDBUser(uniqueID: user.uid, userData: userData)
            completion(true, nil)
        }
    }

    func loginUser(withEmail email: String, andPassword password: String,
                   completion: @escaping (_ status: Bool,_ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                completion(false, error)
                return
            }
            completion(true, nil)
        }
    }

    func loginFacebookUser(completion: @escaping (_ status: Bool,_ error: Error?) -> Void) {
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                completion(false, error)
                return
            }
            guard let user = user else { return }
            DataService.instance.createDBUser(
                uniqueID: user.uid,
                userData: [
                    "provider": user.providerID,
                    "email": user.displayName as Any,
                    ]
            )
            completion(true, nil)
        }
    }
}
