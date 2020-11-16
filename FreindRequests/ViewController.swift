//
//  ViewController.swift
//  FreindRequests
//
//  Created by Shannon Draeker on 11/16/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Friend Request Methods
    
    /// The user has clicked the button to try to add a new friend
    func addFriendButtonTapped() {
        // TODO: - show an alert with a text field asking the user to enter the unique email or name of the user they wish to add as a friend
        
        
        // TODO: - when the email has been entered, search for the user
        let email = ""
        UserController.shared.searchForUser(with: email) { [weak self] (result) in
            switch result {
            case .success(let friend):
                guard let friend = friend else {
                    print("The friend doesn't exist, ask the user to try again and make sure to spell the email correctly")
                    return
                }
                
                print("the friend exists, now make sure it's valid to send them a request")
                guard !(FriendRequestController.shared.outgoingFriendRequests?.contains(where: { $0.toID == friend.recordID }) ?? true),
                      !(FriendRequestController.shared.pendingFriendRequests?.contains(where: { $0.fromID == friend.recordID }) ?? true),
                      !(UserController.shared.currentUser?.friendIDs.contains(friend.recordID) ?? true),
                      !friend.blockedIDs.contains(UserController.shared.currentUser?.recordID ?? "")
                else { return }
                
                // Send the friend request
                FriendRequestController.shared.sendFriendRequest(to: friend) { (result) in
                    switch result {
                    case .success(_):
                        print("the friend request has been sent, notify the user and update the display if applicable")
                    case .failure(let error):
                        print("Error in file \(#fileID) in function \(#function) on line \(#line): \(error.localizedDescription) \n---\n \(error)")
                    }
                }
            case .failure(let error):
                print("Error in file \(#fileID) in function \(#function) on line \(#line): \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    /// The user has clicked the button to try to remove a friend
    func removeFriendButtonTapped() {
        // TODO: - present an "are you sure?" alert
        
        FriendRequestController.shared.removeFriend(User(email: "example", name: "example")) { [weak self] (result) in
            switch result {
            case .success(_):
                print("it was sent successfully, notify the user and update the display if applicable")
                print("might want to ask the user if they want to block the person they just removed")
            case .failure(let error):
                print("Error in file \(#fileID) in function \(#function) on line \(#line): \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    /// Display an alert with a friend request
    func displayFriendRequest() {
        let friendRequest = FriendRequest(fromID: "exampleID", fromName: "exampleName", toID: "exampleID2", toName: "exampleName2")
        
        // Create the alert controller
        let alertController = UIAlertController(title: "New Friend Request", message: "New friend request received from \(friendRequest.fromName)", preferredStyle: .alert)
        
        // Add the deny button to the alert
        alertController.addAction(UIAlertAction(title: "Deny", style: .cancel, handler: { (_) in
            FriendRequestController.shared.respond(to: friendRequest, accept: false) { (result) in
                switch result {
                case .success(_):
                    print("success - now can update the UI if applicable")
                    print("might want to ask the user if they want to block the person who sent the request")
                case .failure(let error):
                    print("Error in file \(#fileID) in function \(#function) on line \(#line): \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }))
        
        // Add the confirm button to the alert
        alertController.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (_) in
            FriendRequestController.shared.respond(to: friendRequest, accept: true) { (result) in
                switch result {
                case .success(_):
                    print("success - now can update the UI if applicable")
                case .failure(let error):
                    print("Error in file \(#fileID) in function \(#function) on line \(#line): \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }))
        
        // Present the alert
        present(alertController, animated: true)
    }
}

