//
//  LogininViewController.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 26/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    //MARK: - Outlets
    @IBOutlet weak var emailTextField: InsetTextField!
    @IBOutlet weak var passwordTextField: InsetTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    //MARK: - TextFieldDelegate

    //MARK: - Actions
    @IBAction func signinButtonPressed(_ sender: Any) {
        if emailTextField.text != nil && passwordTextField.text != nil {
            AuthentificationService.instance.loginUser(
                withEmail: emailTextField.text!,
                andPassword: passwordTextField.text!,
                completion: { (success, error) in
                    if success {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        debugPrint(String(describing: error?.localizedDescription))
                    }
                    AuthentificationService.instance.registerUser(
                        withEmail: self.emailTextField.text!,
                        andPassword: self.passwordTextField.text!,
                        completion: { (success, error) in
                            if success {
                                AuthentificationService.instance.loginUser(
                                    withEmail: self.emailTextField.text!,
                                    andPassword: self.passwordTextField.text!,
                                    completion: { (success, nil) in
                                        self.dismiss(animated: true, completion: nil)
                                })
                            } else {
                                debugPrint(String(describing: error?.localizedDescription))
                            }
                    })
            })
        }
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
