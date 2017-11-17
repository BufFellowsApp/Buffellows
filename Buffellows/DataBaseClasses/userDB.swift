//
//  userDB.swift
//  Buffellows
//
//  Created by Eric Gambetta-Guglielmana on 10/12/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//

import UIKit
import Firebase

class userDB  {
    
    public static let instance = userDB()
    let userData = UserModel()
    var profilePath = String()
    public init(){
        
    }
    //Call to User DB section of FireBase
    let uDB =  Database.database().reference().child("Users")
    //Call to User Profile Pic DB section of FireBase
    let iDB = Database.database().reference().child("UserPhoto")
    
    // to call
    // userDB.addUser(UserModel) {
    // (result: String) in
    // if (result == "UserAdded") {
    //  code block
    // } else {
    // code block
    // }
    func addUser(userData: UserModel, completion:@escaping (_ result: String) -> Void) {
        let userAdd = uDB.child(userData.userID!)
        var newUser = [String:String]()
        newUser.updateValue(userData.email!, forKey: "email")
        newUser.updateValue(userData.first!, forKey: "first")
        newUser.updateValue(userData.last!, forKey: "last")
        newUser.updateValue(userData.userAge!, forKey: "userAge")
        
        userAdd.updateChildValues(newUser, withCompletionBlock: { (err, ref) in
            
            if let err = err {
                print(err)
                let errComp = err as! String
                print(errComp)
                completion("UserError")
                return
            }
            completion("UserAdded")
        }
        )
        
    }
    
    
    public func deleteUser(userID: String){
        uDB.child(userID).removeValue()
    }
    // userDB.getProfilePic(userID) {
    // (result: String) in
    // if (result == "UserData") {
    // var profilePicPatch = userDB.passUserData()
    // } else {
    // code block
    // }
    public func getUSerData(userID: String, completion:@escaping (_ result: String) -> Void) {
       
        let userRef = uDB.child(userID)
        
        userRef.observe( .childAdded, with: {(snapshot) in
           
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.userData.first = dictionary["first"] as? String
                self.userData.last = dictionary["last"] as? String
                self.userData.userAge = dictionary["userAge"] as? String
                self.userData.email = dictionary["email"] as? String
            }
          completion("UserData")
        })
        
        
    }
    func passUserData() -> UserModel {
        return userData
    }
    
    func  writeProfilepic(userID: String, photoID: String) {
        
        iDB.child(userID).updateChildValues(["photoPath": photoID])
        
    }
    // to call
    // userDB.getProfilePic(userID) {
    // (result: String) in
    // if (result == "PathFound") {
    // var profilePicPatch = userDB.passProfilePath()
    // } else {
    // code block
    // }
    func getProfilePic(userID: String, completion:@escaping (_ result: String) -> Void) {
        
        iDB.child(userID).observe( .childAdded, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                self.profilePath = dictionary["photoPath"] as! String
            }
            completion("PathFound")
        })
        
        
    }
    func passProfilePath() -> String {
        return profilePath
    }
    
    
    
}
