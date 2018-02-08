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

    func uploadPicture(image: UIImage, uid: String, completion: @escaping (_ url: String) -> Void) {
        var data = Data()
        data = UIImagePNGRepresentation(image)!
        let imageRef = REF_IMAGES.child(uid)
        _ = imageRef.putData(data, metadata: nil, completion: { (metadata, error) in
            guard let metaData = metadata else { return }
            let downloadURL = metaData.downloadURL()
            completion((downloadURL?.absoluteString)!)
        })
    }

    func downloadPicture(url: String, completion: @escaping (UIImage) -> Void) {
        let httpsRef = STORAGE_BASE.reference(forURL: url)
        httpsRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            guard let data = data else { return }
            let image = UIImage(data: data)!
            completion(image)
        }
    }
}
