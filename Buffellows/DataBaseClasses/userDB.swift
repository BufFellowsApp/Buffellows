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
    
    let rootRef =  Database.database().reference()
    

    func addUser(userData: UserModel, completion:@escaping (_ result: String) -> Void) {
        
       
        
        let userAdd = rootRef.child("Users").child(userData.userID!)
        
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
        })
        
    }
    
    
    public func deleteUser(userID: String){
        
        rootRef.child(userID).removeValue()
    }
    public func getUSerData(userID: String) -> UserModel {
        let userData = UserModel()
        let getDataRef = rootRef.child("Users").child(userID)
        
        getDataRef.observe( .childAdded, with: {(snapshot) in
            //print (snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                //print("Creating friends model array")
                
                userData.first = dictionary["first"] as? String
                userData.last = dictionary["last"] as? String
                userData.userAge = dictionary["userAge"] as? String
                userData.email = dictionary["email"] as? String
                //print("Friends Model Array printing")
                
                
            }
            
            //print ("Done Fetching Users")
        })
        return userData
    }
    
}
