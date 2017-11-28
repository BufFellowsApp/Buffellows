//
//  FriendsDB.swift
//  Buffellows
//
//  Created by Eric Gambetta-Guglielmana on 11/14/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//

import Foundation
import Firebase

class FriendsDB  {
    
    public static let instance = FriendsDB()
    var friendsData  = [FriendsModel]()
    public init(){
       // FirebaseApp.configure()
    }
    
    
    let rootRef = Database.database().reference().child("Friends")
    
    public func addFriend(friend: FriendsModel, user: UserModel, completion:@escaping (_ result: String) -> Void) {
        
        
        let userFriendListAdd = rootRef.child(friend.yourID!).child(friend.friendID!)
        let notUserFriendListAdd = rootRef.child(friend.friendID!).child(friend.yourID!)
        var userFriend = [String:String]()
        var notUserFriend = [String:String]()
        userFriend.updateValue("pending", forKey: "status")
        userFriend.updateValue(friend.first!, forKey: "first")
        userFriend.updateValue(friend.last!, forKey: "last")
        userFriend.updateValue(friend.friendProfilePic!, forKey: "friendProfilePic")
        notUserFriend.updateValue("request", forKey: "status")
        notUserFriend.updateValue(user.first!, forKey: "first")
        notUserFriend.updateValue(user.last!, forKey: "last")
        notUserFriend.updateValue(user.profilePic!, forKey: "friendProfilePic")

        
        
        userFriendListAdd.updateChildValues(userFriend, withCompletionBlock: {
            
            (error, user) in
            
            if error != nil{
                print("Friends-Database Error: \(String(describing: error?.localizedDescription))\n")
            }
            print("Friend Added to Database")
            

            
        })
        
            
        
        notUserFriendListAdd.updateChildValues(notUserFriend, withCompletionBlock: {
            
            (error, user) in
            
            if error != nil{
                print("Friends-Database Error: \(String(describing: error?.localizedDescription))\n")
            }
            print("Friend Request Added to Database")
            
            
        })
        
     completion("FriendAdded")
    
    }
    
    public func delFriend(friend: FriendsModel){
        rootRef.child(friend.yourID!).child(friend.friendID!).removeValue()
        rootRef.child(friend.friendID!).child(friend.yourID!).removeValue()
        print("Friend Deleted")
        
    }
    // to call
    // userDB.fetchFriends(FriendsModel) {
    // (result: String) in
    // if (result == "DataFetched") {
    // var [FriendModel] = userDB.passFriendData()
    // } else {
    // code block
    // }
    public func fetchFriends(friend: FriendsModel,  completion:@escaping (_ result: String) -> Void)  {
        self.friendsData.removeAll()
        rootRef.removeAllObservers()
        
        rootRef.child(friend.yourID!).observe(.childAdded , with: {(snapshot) in
            //print (snapshot)
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let key = snapshot.key
                //print("Creating friends model array")
                let friendInfo = FriendsModel()
                friendInfo.first = dictionary["first"] as? String
                friendInfo.last = dictionary["last"] as? String
                friendInfo.status = dictionary["status"] as? String
                friendInfo.friendID = key
                self.friendsData.append(friendInfo)
                //print("Friends Model Array printing")
                
                
            }
            
            //print ("Done Fetching Users")
     
            
            completion("DataFetched")
            
        }, withCancel: { (error) in
            
            print(error.localizedDescription)
            completion("DataError")
            
        }
        )
        
        
        
    }
    func passFriendData() -> [FriendsModel] {
        return self.friendsData
    }
    
    
    func friendRequestResponse(userID: String, friendID: String, response: String, completion:@escaping (_ result: String) -> Void)
    {
        let dataLoad = DispatchGroup()
        let backgroundQ = DispatchQueue(label:"queue")
         backgroundQ.async(group: dataLoad) {
        if (response == "accept"){
            self.rootRef.child(userID).child(friendID).updateChildValues(["status": "friend"])
            self.rootRef.child(friendID).child(userID).updateChildValues(["status": "friend"])
        }
        
        if (response == "decline" || response == "delete")
        {
            self.rootRef.child(userID).child(friendID).removeValue()
            self.rootRef.child(friendID).child(userID).removeValue()
            
        }
            
        }
        dataLoad.notify(queue: DispatchQueue.main){
            print("Friend Response DeQueued")
            completion("FriendRequestComplete")
        }
    }
    func removeQuery() {
        rootRef.removeAllObservers()
    
    }
}
