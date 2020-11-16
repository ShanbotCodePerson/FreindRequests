//
//  FriendRequestController.swift
//  FreindRequests
//
//  Created by Shannon Draeker on 11/16/20.
//

import Foundation

class FriendRequestController {
    
    // MARK: - Singleton
    
    static let shared = FriendRequestController()
    
    // MARK: - Source of Truth
    
    var pendingFriendRequests: [FriendRequest]?     // Friend requests sent to the current user
    var outgoingFriendRequests: [FriendRequest]?    // Friend requests sent by the current user
    
    // MARK: - CRUD Methods
    
    /// Create - Create a request to add a friend
    func sendFriendRequest(to user: User, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let currentUser = UserController.shared.currentUser else { return }
        
        // Create a new friend request
        let friendRequest = FriendRequest(fromID: currentUser.recordID,
                                          fromName: currentUser.name,
                                          toID: user.recordID,
                                          toName: user.name,
                                          status: .waiting)
        
        // TODO: - Save it to the cloud
        
        // TODO: - add it to the source of truth, outgoingFriendRequests
    }
    
    /// Create - Create a request to remove a friend
    func removeFriend(_ user: User, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let currentUser = UserController.shared.currentUser else { return }
        
        // Create a new friend request
        let friendRequest = FriendRequest(fromID: currentUser.recordID,
                                          fromName: currentUser.name,
                                          toID: user.recordID,
                                          toName: user.name,
                                          status: .removingFriend)
        
        // TODO: - Save it to the cloud
    }
    
    /// Read - Fetch all requests to unfriend the current user
    // TODO: - you probably want to call this function when opening the app
    func fetchPendingFriendRemovals(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let currentUser = UserController.shared.currentUser else { return }
        
        // TODO: - fetch all friend requests from the cloud where currentUser.recordID == friendRequest.toID && friendRequest.status == FriendRequest.Status.removingFriend.rawValue
        
        let unFriendRequests: [FriendRequest] = []
    
        let group = DispatchGroup()
        
        for unfriendRequest in unFriendRequests {
            let friendID = unfriendRequest.fromID
            
            // Remove the friend from the users list of friends
            if let index = currentUser.friendIDs.firstIndex(of: friendID) { currentUser.friendIDs.remove(at: index) }
            
            // Delete the friend request now that it's been completed
            group.enter()
            delete(unfriendRequest) { (result) in
                switch result {
                case .success(_):
                    group.leave()
                case .failure(let error):
                    return completion(.failure(error))
                }
            }
        }
        
        // Save the changes to the user
        group.notify(queue: .main) {
            UserController.shared.saveUpdates(to: currentUser, completion: completion)
        }
    }
    
    /// Read - Fetch all the pending friend requests
    // TODO: - you probably want to call this function when opening the app, since you need it to ask the user to confirm/deny each pending friend request, but also to check new friend requests against, since you don't want to send a request to someone who's already sent you one
    func fetchPendingFriendRequests(completion: @escaping (Result<Bool, Error>) -> Void) {
        // TODO: - fetch all friend requests from the cloud where currentUser.recordID == friendRequest.toID && friendRequest.status == FriendRequest.Status.waiting.rawValue
        
        // TODO: - save to the source of truth
    }
    
    /// Read - Fetch all the outgoing friend requests
    // TODO: - you probably want to call this function when opening the app, since you might want to display them to the user, but also to check new friend requests against, since you don't want to send a request to someone you already sent a request to
    func fetchOutgoingFriendRequests(completion: @escaping (Result<Bool, Error>) -> Void) {
        // TODO: - fetch all friend requests from the cloud where currentUser.recordID == friendRequest.fromID
        
        // TODO: - save to the source of truth
    }
    
    /// Update - Update a friend request with a response
    func respond(to friendRequest: FriendRequest, accept: Bool, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let currentUser = UserController.shared.currentUser else { return }
        
        // Update the friend request
        friendRequest.status = accept ? .accepted : .denied
        
        // If the user accepted the friend request, add and save the friend
        if accept {
            currentUser.friendIDs.append(friendRequest.fromID)
            
            // Save the changes to the user
            UserController.shared.saveUpdates(to: currentUser) { (result) in
                switch result {
                case .success(_):
                    // Fetch the new friend and add it to the source of truth
                    UserController.shared.fetchUser(with: friendRequest.fromID) { (result) in
                        switch result {
                        case .success(let friend):
                            // Save to the source of truth
                            if let friend = friend {
                                UserController.shared.usersFriends?.append(friend)
                            }
                        case .failure(let error):
                            return completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    return completion(.failure(error))
                }
            }
        }
        
        // TODO: - save the updated friend request to the cloud
    }
    
    /// Delete - Delete a friend request when it's completed
    func delete(_ friendRequest: FriendRequest, completion: @escaping (Result<Bool, Error>) -> Void) {
        // TODO: - delete the friend request from the cloud
    }
    
    /// Delete - Delete all the friend requests associated with a user
    func deleteAll(completion: @escaping (Result<Bool, Error>) -> Void) {
        // TODO: - delete all friend requests sent to or from the user (for when the user is being deleted)
    }
    
    // MARK: - Notifications
    
    /// When the current user receives a new friend request
    func receiveRequest(_ friendRequest: FriendRequest, completion: @escaping (Result<Bool, Error>) -> Void) {
        // TODO: - save the request to the source of truth, pendingFriendRequests
        
        // TODO: - show a notification or something to the user asking them to confirm or deny the friend request
    }
    
    ///
    func receiveUpdatedRequest(_ friendRequest: FriendRequest, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let currentUser = UserController.shared.currentUser else { return }
        
        // If the request was accepted, add the friends to the user's list of friends
        currentUser.friendIDs.append(friendRequest.toID)
        
        // TODO: - save the updated user to the source of truth
        
        // TODO: - fetch the User object of the new friend and save it to UserController.shared.usersFriends
        
        // TODO: - delete the friend request now that it's completed
    }
}
