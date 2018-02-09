//
//  MeViewController.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 26/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit
import Firebase

class MeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIPopoverPresentationControllerDelegate {
    //MARK: - Outlets
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userDescriptionTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!

    //MARK: - Variables
    var messages = [Message]()
    var inEdition = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        userDescriptionTextView.delegate = self
        userDescriptionTextView.isEditable = false
        userDescriptionTextView.backgroundColor = #colorLiteral(red: 0.2126879096, green: 0.2239724994, blue: 0.265286684, alpha: 1)
        profileImageView.rounded()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailLabel.text = Auth.auth().currentUser?.email
        DataService.instance.REF_USERS.observe(.value) { (snapshot) in
            DataService.instance.getUserDescription(forUID: (Auth.auth().currentUser?.uid)!, completion: { (description) in
                self.userDescriptionTextView.text = description
            })
        }
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
        DataService.instance.REF_USERS.observe(.value) { (snapshot) in
            DataService.instance.getUserProfilePicture(forUID: (Auth.auth().currentUser?.uid)!, completion: { (picture) in
                guard let profilePicture = picture else { return }
                self.profileImageView.image = profilePicture
                self.view.layoutIfNeeded()
            })
        }
        inEdition = false
        userDescriptionTextView.isEditable = inEdition
        editProfileButton.setImage(#imageLiteral(resourceName: "compose"), for: .normal)
        userDescriptionTextView.backgroundColor = #colorLiteral(red: 0.2126879096, green: 0.2239724994, blue: 0.265286684, alpha: 1)
    }

    private func updateUserDescription() {
        if userDescriptionTextView.text != "" {
            userDescriptionTextView.isEditable = false
            editProfileButton.isEnabled = false
            DataService.instance.updateUserDescription(
                forUID: (Auth.auth().currentUser?.uid)!,
                userDescription: userDescriptionTextView.text,
                completion: { (success) in
                    if success {
                        self.editProfileButton.isEnabled = true
                    }
            })
        } else {
            userDescriptionTextView.text = "Say something about you.."
        }
    }

    //MARK: - UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
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

    //MARK: - UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    //MARK: - Actions
    @IBAction func editProfileButtonPressed(_ sender: Any) {
        inEdition = !inEdition
        userDescriptionTextView.isEditable = inEdition
        if inEdition {
            editProfileButton.setImage(#imageLiteral(resourceName: "close"), for: .normal)
            userDescriptionTextView.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.168627451, blue: 0.2039215686, alpha: 1)
        } else {
            updateUserDescription()
            editProfileButton.setImage(#imageLiteral(resourceName: "compose"), for: .normal)
            userDescriptionTextView.backgroundColor = #colorLiteral(red: 0.2126879096, green: 0.2239724994, blue: 0.265286684, alpha: 1)
        }
    }
    @IBAction func profileImageButtonPressed(_ sender: UIButton) {
        if inEdition {
            present(ChoosePictureViewController(), animated: true, completion: nil)
        } else {
            let profilePictureViewController = ProfilePictureViewController(
                size: CGSize(width: 350, height: 350),
                image: profileImageView.image!
                )
            profilePictureViewController.modalPresentationStyle = .popover
            profilePictureViewController.popoverPresentationController?.delegate = self
            present(profilePictureViewController, animated: true, completion: nil)
            profilePictureViewController.popoverPresentationController?.sourceView = sender
            profilePictureViewController.popoverPresentationController?.sourceRect = sender.bounds
        }
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
