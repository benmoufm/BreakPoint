//
//  GroupFeedTableViewCell.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 29/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit
import SDWebImage

class GroupFeedTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

    func configure(url: URL, profileImagePlaceHolder: UIImage, email: String, content: String) {
        self.profileImageView.rounded()
        self.profileImageView.sd_setImage(with: url, placeholderImage: profileImagePlaceHolder, options: .highPriority)
        self.emailLabel.text = email
        self.contentLabel.text = content
    }

    func configureCell(profileImage: UIImage, email: String, content: String) {
        self.profileImageView.rounded()
        self.profileImageView.image = profileImage
        self.emailLabel.text = email
        self.contentLabel.text = content
    }
}
