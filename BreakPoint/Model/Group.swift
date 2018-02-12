//
//  Group.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 29/01/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import Foundation

class Group {
    private(set) var title: String
    private(set) var description: String
    private(set) var key: String
    private(set) var memberCount: Int
    private(set) var members: [String]

    init(title: String, description: String, key: String, members: [String]) {
        self.title = title
        self.description = description
        self.key = key
        self.memberCount = members.count
        self.members = members
    }
}
