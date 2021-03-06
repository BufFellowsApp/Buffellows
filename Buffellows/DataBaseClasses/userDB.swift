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
    var userData = UserModel()
    
    
    var profilePath = String()
    var foundUser = String()

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
        newUser.updateValue(userData.profilePic!, forKey: "profilePic")
        
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
    // getUSerData(userID) {
    // (result: String) in
    // if (result == "UserData") {
    // var userData = userDB.passUserData()
    // } else {
    // code block
    // }
    public func getUSerData(userID: String, completion:@escaping (_ result: String) -> Void) {
            
            self.uDB.child(userID).observeSingleEvent(of: .value, with: { (snapShot) in
               
                    if let snapDict = snapShot.value as? [String:AnyObject]{
                    
                        
                        self.userData.userID = userID
                        self.userData.first = snapDict["first"] as? String
                        self.userData.last = snapDict["last"] as? String
                        self.userData.email = snapDict["email"] as? String
                        self.userData.userAge = snapDict["userAge"] as? String
                        self.userData.profilePic = snapDict["profilePic"] as? String
                        self.foundUser = userID
                    }
                

                    if self.foundUser.isEmpty {
                        completion("NotFound")
                        print("User Data not found \(userID)")
                    }
                        
                    else
                    {
                        
                        completion("UserData")
                        
                    
                }
            })
        
        
        
            
        
        
    }
    func passUserData() -> UserModel {
        return userData
    }
    func passFoundUser() -> String {
        return foundUser
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
    
    func setProfileURL(uID: String, path: String)
    {
        uDB.child(uID).updateChildValues(["profilePic": path])
        
    }
    func findUser(email:String, completion:@escaping (_ result: String) -> Void) {

        userData = UserModel()
        foundUser = String()
        uDB.queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value, with: { (snapShot) in
            
                
            if let snapDict = snapShot.value as? [String:AnyObject]{
                print("Found User By Email")
                for each in snapDict{
                    let key  = each.key
                    let name = each.value["email"] as! String
                    self.userData.userID = key
                    self.userData.first = each.value["first"] as? String
                    self.userData.last = each.value["last"] as? String
                    self.userData.email = name
                    self.userData.profilePic = each.value["profilePic"] as? String
                    self.foundUser = name
                    
                    
                }
            }
            
            
            
                if self.foundUser.isEmpty {
                    completion("NotFound")}
                else
                {
                    
                    completion("FoundUser")
                }
            
            
        }, withCancel: {(Err) in
            
            print(Err.localizedDescription)
            
        }
        )
    }
    func removeQuery() {
        self.uDB.removeAllObservers()
        self.iDB.removeAllObservers()
        
    }
    
}
