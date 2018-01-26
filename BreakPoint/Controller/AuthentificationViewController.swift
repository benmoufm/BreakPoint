//
//  AuthentificationViewController.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 26/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit

class AuthentificationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK: - Actions
    @IBAction func signinWithEmailButtonPressed(_ sender: Any) {
        let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        present(loginViewController!, animated: true, completion: nil)
    }

    @IBAction func signinWithFacebookButtonPressed(_ sender: Any) {

    }

    @IBAction func signinWithGoogleButtonPressed(_ sender: Any) {

    }
}
