//
//  FriendRequest.swift
//  FreindRequests
//
//  Created by Shannon Draeker on 11/16/20.
//

import Foundation

class FriendRequest {
    
    // MARK: - Properties
    
    let fromID: String
    let fromName: String
    let toID: String
    let toName: String
    var status: Status
    let recordID: String
    
    enum Status: Int {
        case waiting
        case accepted
        case denied
        case removingFriend
    }
    
    // MARK: - Initializer
    
    init(fromID: String,
         fromName: String,
         toID: String,
         toName: String,
         status: Status = .waiting,
         recordID: String = UUID().uuidString) {
        
        self.fromID = fromID
        self.fromName = fromName
        self.toID = toID
        self.toName = toName
        self.status = status
        self.recordID = recordID
    }
}

// MARK: - Equatable

extension FriendRequest: Equatable {
    static func == (lhs: FriendRequest, rhs: FriendRequest) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}
