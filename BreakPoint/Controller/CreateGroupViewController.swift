//
//  CreateGroupViewController.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 29/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    //MARK: - Outlets
    @IBOutlet weak var titleTextField: InsetTextField!
    @IBOutlet weak var descriptionTextField: InsetTextField!
    @IBOutlet weak var groupMemberLabel: UILabel!
    @IBOutlet weak var emailSearchTextField: InsetTextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    //MARK : - Variables
    var emails = [String]()
    var chosenUsers = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        emailSearchTextField.delegate = self
        addTargetToTextField()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doneButton.isHidden = true
    }

    //MARK: - UITableViewDelegate & UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emails.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserTableViewCell
            else { return UITableViewCell() }
        if chosenUsers.contains(emails[indexPath.row]) {
            cell.configureCell(profileImage: #imageLiteral(resourceName: "defaultProfileImage"), email: emails[indexPath.row], isSelected: true)
        } else {
            cell.configureCell(profileImage: #imageLiteral(resourceName: "defaultProfileImage"), email: emails[indexPath.row], isSelected: false)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserTableViewCell
            else { return }
        if !chosenUsers.contains(cell.emailLabel.text!) {
            chosenUsers.append(cell.emailLabel.text!)
            groupMemberLabel.text = chosenUsers.joined(separator: ", ")
            doneButton.isHidden = false
        } else {
            chosenUsers = chosenUsers.filter { $0 != cell.emailLabel.text! }
            if chosenUsers.count >= 1 {
                groupMemberLabel.text = chosenUsers.joined(separator: ", ")
            } else {
                groupMemberLabel.text = "add people to your group"
                doneButton.isHidden = true
            }
        }
    }

    //MARK: - UITextFieldDelegate
    func addTargetToTextField() {
        emailSearchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    @objc func textFieldDidChange() {
        if emailSearchTextField.text == "" {
            emails = []
            tableView.reloadData()
        } else {
            DataService.instance.getEmail(forSearchQuery: emailSearchTextField.text!, completion: { (emails) in
                self.emails = emails
                self.tableView.reloadData()
            })
        }
    }

    //MARK: - Actions
    @IBAction func doneButtonPressed(_ sender: Any) {

    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
