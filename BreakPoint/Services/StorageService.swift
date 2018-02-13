//
//  StorageService.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 08/02/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import Foundation
import Firebase

let STORAGE_BASE = Storage.storage()

class StorageService {
    static let instance = StorageService()

    private(set) var REF_IMAGES = STORAGE_BASE.reference().child("images")

    func uploadPicture(url: URL, uid: String, completion: @escaping (_ url: String) -> Void) {
        let imageRef = REF_IMAGES.child(uid)
        _ = imageRef.putFile(from: url, metadata: nil, completion: { (metadata, error) in
            guard let metaData = metadata else { return }
            let downloadURL = metaData.downloadURL()
            completion((downloadURL?.absoluteString)!)
        })
    }
}
