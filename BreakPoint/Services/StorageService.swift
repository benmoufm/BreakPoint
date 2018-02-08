//
//  StorageService.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 08/02/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import Foundation
import Firebase

let STORAGE_BASE = Storage.storage().reference()

class StorageService {
    static let instance = StorageService()

    private(set) var REF_IMAGES = STORAGE_BASE.child("images")
}
