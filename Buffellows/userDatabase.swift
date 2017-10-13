//
//  userDatabase.swift
//  Buffellows
//
//  Created by Eric Gambetta-Guglielmana on 10/12/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//

import UIKit
import Firebase

class userDatabase  {
    let rootRef =  Database.database().reference()
    public static let instance = userDatabase()
    private init(){
        FirebaseApp.configure()
    }

    public func getUSerData(userID: String) -> Dictionary<String, Any> {
        var userData = [String: AnyObject]()
        let getDataRef = rootRef.child("Users").child(userID)
        
        getDataRef.observe(.value){
            (snap: DataSnapshot) in
            userData = (snap.value as? [String: AnyObject])!
                

        }
        return userData
    }
    public func addUser(userData: [String: AnyObject]) {
        
        let userID = userData["userID"] as! String
        let firstName = userData["firstName"] as! String
        let lastName = userData["lastName"] as! String
        let userAge = userData["age"] as! Int
        let userAdd = rootRef.child("users").child(userID)
        
        userAdd.setValue(["first": firstName])
        userAdd.setValue(["last": lastName])
        userAdd.setValue(["age": userAge])
    }
    public func addFriend(userID: String, friendID: String){
        
        let friendAdd = rootRef.child("users").child(userID).child("friends")
        var friendsList = [String]()
        friendAdd.observe(.value){ (snap: DataSnapshot) in
            friendsList = (snap.value as? [String])!
            
        }
        friendAdd.setValue([friendsList.count: friendID])
        
    }
    public func addChallenge(challengeID: String, userID: String){
        let challengeAdd = rootRef.child("users").child(userID).child("challenges")
        challengeAdd.setValue([challengeID: "incomplete"])
        
    
    }
}
