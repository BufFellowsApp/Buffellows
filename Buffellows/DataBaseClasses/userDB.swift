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
    public init(){
        //FirebaseApp.configure()
    }
    //Call to User DB section of FireBase
    let uDB =  Database.database().reference().child("Users")
    //Call to User Profile Pic DB section of FireBase
    let iDB = Database.database().reference().child("UserPhoto")
    

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
    public func getUSerData(userID: String) -> UserModel {
        let userData = UserModel()
        let userRef = uDB.child(userID)
        
        userRef.observe( .childAdded, with: {(snapshot) in
           
            if let dictionary = snapshot.value as? [String: AnyObject] {
                userData.first = dictionary["first"] as? String
                userData.last = dictionary["last"] as? String
                userData.userAge = dictionary["userAge"] as? String
                userData.email = dictionary["email"] as? String
            }})
        return userData
    }
    
    func  writeProfilepic(userID: String, photoID: String) {
        
        iDB.child(userID).updateChildValues(["photoPath": photoID])
        
    }
    func getProfilePic(userID: String) -> String {
        var path = String()
        iDB.child(userID).observe( .childAdded, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                path = dictionary["photoPath"] as! String
            }
        })
        return path
    }
    
    
    
}
