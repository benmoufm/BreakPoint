//
//  AuthentificationViewController.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 26/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class AuthentificationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
    }

    //MARK: - Actions
    @IBAction func signinWithEmailButtonPressed(_ sender: Any) {
        let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        present(loginViewController!, animated: true, completion: nil)
    }

    @IBAction func signinWithFacebookButtonPressed(_ sender: Any) {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: nil, from: self) { (loginResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            AuthentificationService.instance.loginFacebookUser(completion: { (success, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                self.dismiss(animated: true, completion: nil)
            })
        }
    }

    @IBAction func signinWithGoogleButtonPressed(_ sender: Any) {

    }
}
