//
//  User.swift
//  FreindRequests
//
//  Created by Shannon Draeker on 11/16/20.
//

import Foundation

class User {
    
    // MARK: - Properties
    
    var email: String
    var name: String
    var recordID: String
    var friendIDs: [String]     // The record ID of each user who has friended this user
    var blockedIDs: [String]    // The record ID of each user that this user has blocked
    
    // MARK: - Initializer
    
    init(email: String, name: String, recordID: String = UUID().uuidString) {
        self.email = email
        self.name = name
        self.recordID = recordID
        self.friendIDs = []
        self.blockedIDs = []
    }
}

// MARK: - Equatable

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}
