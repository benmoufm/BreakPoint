//
//  UserTableViewCell.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 29/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!

    //MARK: - Variables
    var showing = false

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            if showing == false {
                checkImageView.isHidden = false
                showing = true
            } else {
                checkImageView.isHidden = true
                showing = false
            }
        }
    }

    func configureCell(profileImage: UIImage, email: String, isSelected: Bool) {
        self.profileImageView.image = profileImage
        self.emailLabel.text = email
        if isSelected {
            self.checkImageView.isHidden = false
        } else {
            self.checkImageView.isHidden = true
        }
    }
}
