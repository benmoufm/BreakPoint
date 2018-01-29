//
//  GroupFeedViewController.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 29/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit

class GroupFeedViewController: UIViewController {
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
            })
        }
    }

    //MARK: - Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func sendButtonPressed(_ sender: Any) {

    }
}
