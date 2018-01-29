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
        membersLabel.text = group?.members.joined(separator: ", ")
    }

    //MARK: - Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func sendButtonPressed(_ sender: Any) {

    }
}
