//
//  MeViewController.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 26/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit
import Firebase

class MeViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailLabel.text = Auth.auth().currentUser?.email
    }

    //MARK: - Actions
    @IBAction func signoutButtonPressed(_ sender: Any) {
        let logoutPopup = UIAlertController(title: "Logout ?", message: "Are you sure you want to logout ?", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout ?", style: .destructive) { (buttonTapped) in
            do {
                try Auth.auth().signOut()
                let authentificationViewController =
                    self.storyboard?.instantiateViewController(withIdentifier: "AuthentificationViewController")
                        as? AuthentificationViewController
                self.present(authentificationViewController!, animated: true, completion: nil)
            } catch {
                debugPrint(error)
            }
        }
        logoutPopup.addAction(logoutAction)
        present(logoutPopup, animated: true, completion: nil)
    }
}
