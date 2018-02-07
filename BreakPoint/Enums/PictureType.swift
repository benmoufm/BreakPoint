//
//  PictureType.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 06/02/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit

enum PictureType {
    case dark
    case light

    var description: String {
        switch self {
        case .dark:
            return "dark"
        case .light:
            return "light"
        }
    }

    var color: CGColor {
        switch self {
        case .dark:
            return UIColor.lightGray.cgColor
        case .light:
            return UIColor.gray.cgColor
        }
    }

    var selectedColor: CGColor {
        switch self {
        case .light:
            return UIColor.black.cgColor
        case .dark:
            return UIColor.white.cgColor
        }
    }
}
