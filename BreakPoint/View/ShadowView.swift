//
//  ShadowView.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 26/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    override func awakeFromNib() {
        setupView()
        super.awakeFromNib()
    }

    func setupView() {
        layer.shadowOpacity = 0.75
        layer.shadowRadius = 5
        layer.shadowColor = UIColor.black.cgColor
    }
}
