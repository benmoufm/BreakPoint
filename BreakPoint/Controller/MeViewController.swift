//
//  MeViewController.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 26/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit
import Firebase

class MeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: - Outlets
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userDescriptionTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!

    //MARK: - Variables
    var messages = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailLabel.text = Auth.auth().currentUser?.email
        DataService.instance.REF_FEED.observe(.value) { (snapshot) in
            DataService.instance.getAllFeedMessages(forUID: (Auth.auth().currentUser?.uid)!) { (messages) in
                self.messages = messages.reversed()
                self.tableView.reloadData()
            }
        }
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllGroupMessages(forUID: (Auth.auth().currentUser?.uid)!, completion: { (messages) in
                self.messages += messages.reversed()
                self.tableView.reloadData()
            })
        }
    }

    //MARK: - UITableViewDelegate & DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "meCell") as? MeTableViewCell
            else { return UITableViewCell() }
        let message = messages[indexPath.row]
        var conversationTitle = "@feed"
        if let group = message.group {
            conversationTitle = "@\(group.title)"
        }
        cell.configureCell(conversationTitle: conversationTitle, messageContent: message.content)
        return cell
    }

    //MARK: - Actions
    @IBAction func editProfileButtonPressed(_ sender: Any) {

    }

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
