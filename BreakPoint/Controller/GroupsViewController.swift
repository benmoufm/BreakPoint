//
//  SecondViewController.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 26/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit

class GroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    //MARK: - Variables
    var groups = [Group]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllGroups { (groups) in
                self.groups = groups
                self.tableView.reloadData()
            }
        }
    }

    //MARK: - UITableViewDelegate & UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell") as? GroupTableViewCell
            else { return UITableViewCell() }
        cell.configureCell(title: groups[indexPath.row].title,
                           description: groups[indexPath.row].description,
                           memberCount: groups[indexPath.row].memberCount)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let groupFeedViewController =
            storyboard?.instantiateViewController(withIdentifier: "GroupFeedViewController") as? GroupFeedViewController
            else { return }
        groupFeedViewController.initData(forGroup: groups[indexPath.row])
        presentDetail(groupFeedViewController)
    }
}

