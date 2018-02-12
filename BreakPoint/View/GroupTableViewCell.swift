//
//  GroupTableViewCell.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 29/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var groupDescriptionLabel: UILabel!
    @IBOutlet weak var groupMemberCountLabel: UILabel!

    func configureCell(title: String, description: String, memberCount: Int) {
        self.groupTitleLabel.text = title
        self.groupDescriptionLabel.text = description
        self.groupMemberCountLabel.text = "\(memberCount) members."
    }
}
