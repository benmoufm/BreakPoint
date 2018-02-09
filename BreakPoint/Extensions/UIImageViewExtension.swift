//
//  UIImageViewExtension.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 09/02/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit

extension UIImageView {
    func rounded() {
        layer.cornerRadius = frame.width / 2
    }
}
