//
//  GroupFeedViewController.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 29/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: - Outlets
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendMessageView: UIView!
    @IBOutlet weak var messageTextField: InsetTextField!
    @IBOutlet weak var sendButton: UIButton!

    //MARK: - Variables
    var group: Group?
    var messages = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        sendMessageView.bindToKeyboard()
        tableView.delegate = self
        tableView.dataSource = self
        addTapGesture()
    }

    func initData(forGroup group: Group) {
        self.group = group
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupTitleLabel.text = group?.title
        DataService.instance.getEmails(forGroup: group!) { (emails) in
            self.membersLabel.text = emails.joined(separator: ", ")
        }
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllMessages(forDesiredGroup: self.group!, completion: { (messages) in
                self.messages = messages
                self.tableView.reloadData()
                // Scroll to last message
                if self.messages.count > 0 {
                    self.tableView.scrollToRow(at: IndexPath.init(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
                }
            })
        }
    }

    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dimissKeyBoard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dimissKeyBoard() {
        view.endEditing(true)
    }

    //MARK: - UITableViewDelegate & UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupFeedCell") as? GroupFeedTableViewCell
            else { return UITableViewCell() }
        let message = messages[indexPath.row]
        DataService.instance.getUserName(forUID: message.senderId) { (email) in
            DataService.instance.getUserProfilePicture(forUID: self.messages[indexPath.row].senderId, completion: { (pictureName) in
                if let profilePictureName = pictureName {
                    cell.configureCell(profileImage: UIImage(named: profilePictureName)!, email: email, content: message.content)
                } else {
                    cell.configureCell(profileImage: #imageLiteral(resourceName: "defaultProfileImage"), email: email, content: message.content)
                }

            })
        }
        return cell
    }

    //MARK: - Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        dismissDetail()
    }

    @IBAction func sendButtonPressed(_ sender: Any) {
        if messageTextField.text != "" {
            messageTextField.isEnabled = false
            sendButton.isEnabled = false
            DataService.instance.uploadPost(withMessage: messageTextField.text!,
                                            forUID: (Auth.auth().currentUser?.uid)!,
                                            withGroupKey: group?.key,
                                            completion: { (success) in
                                                if success {
                                                    self.messageTextField.text = ""
                                                    self.messageTextField.isEnabled = true
                                                    self.sendButton.isEnabled = true
                                                }
            })
        }
    }
}
