//
//  MeTableViewCell.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 01/02/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit

class MeTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var conversationLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    func configureCell(conversationTitle: String, messageContent: String) {
        self.conversationLabel.text = conversationTitle
        self.messageLabel.text = messageContent
    }
}
