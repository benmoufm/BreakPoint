//
//  DataService.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 26/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()

    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")

    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }

    func createDBUser(uniqueID: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uniqueID).updateChildValues(userData)
    }

    func getUserName(forUID uid: String, completion: @escaping (_ username: String) -> Void) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for snapshot in userSnapshot {
                if snapshot.key == uid {
                    completion(snapshot.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }

    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?,
                    completion: @escaping (_ success: Bool) -> Void) {
        if groupKey != nil {
            //TODO: Send to groups ref
        } else {
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid])
            completion(true)
        }
    }

    func getAllFeedMessages(completion: @escaping (_ messages: [Message]) -> Void) {
        var messages = [Message]()
        REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapshot) in
            guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot]
                else { return }
            for snapshot in feedMessageSnapshot {
                let content = snapshot.childSnapshot(forPath: "content").value as! String
                let senderId = snapshot.childSnapshot(forPath: "senderId").value as! String
                let message = Message(content: content, senderId: senderId)
                messages.append(message)
            }
            completion(messages)
        }
    }

    func getEmail(forSearchQuery query: String, completion: @escaping (_ emailArray: [String]) -> Void) {
        var emails = [String]()
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for snapshot in userSnapshot {
                let email = snapshot.childSnapshot(forPath: "email").value as! String
                if email.contains(query) && email != Auth.auth().currentUser?.email {
                    emails.append(email)
                }
            }
            completion(emails)
        }
    }
}
