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

    func updateUserDescription(forUID uid: String, userDescription: String, completion: @escaping (_ success: Bool) -> Void) {
        REF_USERS.child(uid).updateChildValues(["description": userDescription])
        completion(true)
    }

    func updateUserProfilePicture(forUID uid: String, pictureName: String, upload: Bool, completion: @escaping (_ success: Bool) -> Void) {
        REF_USERS.child(uid).child("avatar").updateChildValues(["pictureName": pictureName, "upload": upload])
        completion(true)
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

    func getUserDescription(forUID uid: String, completion: @escaping (_ description: String) -> Void) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot]
                else { return }
            for snapshot in userSnapshot {
                if snapshot.key == uid {
                    guard let userDescription = snapshot.childSnapshot(forPath: "description").value as? String
                        else {
                            completion("Say something about you..")
                            return
                    }
                    completion(userDescription)
                }
            }
        }
    }

    func getEmails(forGroup group: Group, completion: @escaping (_ emails: [String]) -> Void) {
        var emails = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot]
                else { return }
            for snapshot in userSnapshot {
                if group.members.contains(snapshot.key) {
                    let email = snapshot.childSnapshot(forPath: "email").value as! String
                    emails.append(email)
                }
            }
            completion(emails)
        }
    }

    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?,
                    completion: @escaping (_ success: Bool) -> Void) {
        if groupKey != nil {
            REF_GROUPS.child(groupKey!).child("messages")
                .childByAutoId().updateChildValues(["content": message, "senderId": uid])
            completion(true)
        } else {
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid])
            completion(true)
        }
    }

    func getAllFeedMessages(forUID uid: String, completion: @escaping (_ messages: [Message]) -> Void) {
        var messages = [Message]()
        REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapshot) in
            guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot]
                else { return }
            for snapshot in feedMessageSnapshot {
                let senderID = snapshot.childSnapshot(forPath: "senderId").value as! String
                if senderID == uid {
                    let content = snapshot.childSnapshot(forPath: "content").value as! String
                    let message = Message(content: content, senderId: senderID, group: nil)
                    messages.append(message)
                }
            }
            completion(messages)
        }
    }

    func getAllGroupMessages(forUID uid: String, completion: @escaping (_ messages: [Message]) -> Void) {
        var messages = [Message]()
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot]
                else { return }
            for snapshot in groupSnapshot {
                let groupKey = snapshot.key
                let groupTitle = snapshot.childSnapshot(forPath: "title").value as! String
                let groupDescription = snapshot.childSnapshot(forPath: "description").value as! String
                let members = snapshot.childSnapshot(forPath: "members").value as! [String]
                if members.contains(uid) {
                    let groupMessages = snapshot.childSnapshot(forPath: "messages")
                    guard let messagesSnapshot = groupMessages.children.allObjects as? [DataSnapshot]
                        else { return }
                    for messageSnapshot in messagesSnapshot {
                        let senderId = messageSnapshot.childSnapshot(forPath: "senderId").value as! String
                        if senderId == uid {
                            let content = messageSnapshot.childSnapshot(forPath: "content").value as! String
                            let message = Message(content: content,
                                                  senderId: senderId,
                                                  group: Group(title: groupTitle,
                                                               description: groupDescription,
                                                               key: groupKey,
                                                               members: members))
                            messages.append(message)
                        }
                    }
                }
            }
            completion(messages)
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
                let message = Message(content: content, senderId: senderId, group: nil)
                messages.append(message)
            }
            completion(messages)
        }
    }

    func getAllMessages(forDesiredGroup group: Group, completion: @escaping (_ messages: [Message]) -> Void) {
        var messages = [Message]()
        REF_GROUPS.child(group.key).child("messages").observeSingleEvent(of: .value) { (messageSnapshot) in
            guard let messageSnapshot = messageSnapshot.children.allObjects as? [DataSnapshot]
                else { return }
            for snapshot in messageSnapshot {
                let content = snapshot.childSnapshot(forPath: "content").value as! String
                let senderId = snapshot.childSnapshot(forPath: "senderId").value as! String
                let message = Message(content: content, senderId: senderId, group: nil)
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

    func getIds(forUserNames usernames: [String], completion: @escaping (_ uids: [String]) -> Void) {
        var uids = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for snapshot in userSnapshot {
                let email = snapshot.childSnapshot(forPath: "email").value as! String
                if usernames.contains(email) {
                    uids.append(snapshot.key)
                }
            }
            completion(uids)
        }
    }

    func createGroup(withTitle title: String, andDescription description: String,
                     forUserIds ids: [String], completion: @escaping (_ success: Bool) -> Void) {
        REF_GROUPS.childByAutoId().updateChildValues(["title": title,
                                                      "description": description,
                                                      "members": ids])
        completion(true)
    }

    func getAllGroups(completion: @escaping (_ groups: [Group]) -> Void) {
        var groups = [Group]()
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot]
                else { return }
            for snapshot in groupSnapshot {
                let members = snapshot.childSnapshot(forPath: "members").value as! [String]
                if members.contains((Auth.auth().currentUser?.uid)!) {
                    let title = snapshot.childSnapshot(forPath: "title").value as! String
                    let description = snapshot.childSnapshot(forPath: "description").value as! String
                    let key = snapshot.key
                    let group = Group(title: title, description: description, key: key, members: members)
                    groups.append(group)
                }
            }
            completion(groups)
        }
    }
}
