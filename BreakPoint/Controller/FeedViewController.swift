//
//  FirstViewController.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 26/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    //MARK: - Variables
    var messages = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.getAllFeedMessages { (messages) in
            self.messages = messages.reversed()
            self.tableView.reloadData()
        }
    }

    //MARK: - UITableViewDelegate and UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? FeedTableViewCell
            else { return UITableViewCell() }
        DataService.instance.getUserName(forUID: messages[indexPath.row].senderId) { (userName) in
            DataService.instance.getUserProfilePicture(forUID: self.messages[indexPath.row].senderId, completion: { (picture) in
                if let profilePicture = picture {
                    cell.configure(profileImage: profilePicture, email: userName, content: self.messages[indexPath.row].content)
                } else {
                    cell.configure(profileImage: #imageLiteral(resourceName: "defaultProfileImage"), email: userName, content: self.messages[indexPath.row].content)
                }

            })
        }
        return cell
    }
}

