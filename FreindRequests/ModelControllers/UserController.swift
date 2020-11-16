//
//  UserController.swift
//  FreindRequests
//
//  Created by Shannon Draeker on 11/16/20.
//

import Foundation

class UserController {
    
    // MARK: - Singleton
    
    static let shared = UserController()
    
    // MARK: - Source of Truth
    
    var currentUser: User?
    var usersFriends: [User]?
    
    // MARK: - CRUD Methods
    
    /// Create - Create a new user
    func createUser(with email: String, name: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let user = User(email: email, name: name)
        
        // TODO: - Save to the cloud
        
        currentUser = user
    }
    
    /// Read - Fetch all the users friends
    func fetchUsersFriends(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let currentUser = currentUser else { return }
        
        let group = DispatchGroup()
        var usersFriends: [User] = []
        
        for friendID in currentUser.friendIDs {
            group.enter()
            fetchUser(with: friendID) { (result) in
                switch result {
                case .success(let friend):
                    group.leave()
                    if let friend = friend { usersFriends.append(friend) }
                case .failure(let error):
                    return completion(.failure(error))
                }
            }
        }
        
        group.notify(queue: .main) {
            self.usersFriends = usersFriends
            return completion(.success(true))
        }
    }
    
    /// Read - Fetch a user by record ID
    func fetchUser(with recordID: String, completion: @escaping (Result<User?, Error>) -> Void) {
        // TODO: - fetch the user from the cloud
    }
    
    /// Read - Search for a user by email
    func searchForUser(with email: String, completion: @escaping (Result<User?, Error>) -> Void) {
        // TODO: - search the cloud for a user with the given email
    }
    
    /// Update - Save updates to a user
    func saveUpdates(to user: User, completion: @escaping (Result<Bool, Error>) -> Void) {
        // TODO: - save the user to the cloud
        
        // TODO: - update the source of truth
    }
    
    /// Delete - Delete a user
    func delete(_ user: User, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        // TODO: - send requests to all the users friends to remove this user from their friends lists
        
        // TODO: - remove all friend requests sent from or to the user
        
        // TODO: - delete the user's account
        
        // TODO: - delete the user's authentication information
    }
    
    // MARK: - Notifications
    
    func setUpNotifications() {
        // TODO: - set up notifications to be alerted when friend requests are added to the cloud with the current user's recordID as the "toID" field, or when friend requests with the current user's recordID in the "fromID" field are updated in the cloud
        
        // When receiving a new friend request
//        FriendRequestController.shared.receiveRequest(<#T##friendRequest: FriendRequest##FriendRequest#>, completion: <#T##(Result<Bool, Error>) -> Void#>)
        
        // When receiving a response to a friend request sent by the user
//        FriendRequestController.shared.receiveUpdatedRequest(<#T##friendRequest: FriendRequest##FriendRequest#>, completion: <#T##(Result<Bool, Error>) -> Void#>)
    }
}
