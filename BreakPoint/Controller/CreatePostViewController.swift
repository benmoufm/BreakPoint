//
//  CreatePostViewController.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 26/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit
import Firebase

class CreatePostViewController: UIViewController, UITextViewDelegate {
    //MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
    }

    //MARK: - UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }

    //MARK: - Actions
    @IBAction func sendButtonPressed(_ sender: Any) {
        if textView.text != nil && textView.text != "Say something here..." {
            sendButton.isEnabled = false
            DataService.instance.uploadPost(withMessage: textView.text,
                                            forUID: (Auth.auth().currentUser?.uid)!,
                                            withGroupKey: nil,
                                            completion: { (success) in
                                                if success {
                                                    self.sendButton.isEnabled = true
                                                    self.dismiss(animated: true, completion: nil)
                                                } else {
                                                    self.sendButton.isEnabled = true
                                                    debugPrint("There was an error uploading post")
                                                }
            })
        }
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
