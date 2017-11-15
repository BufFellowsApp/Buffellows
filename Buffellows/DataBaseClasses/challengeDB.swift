//
//  challengeDB.swift
//  Buffellows
//
//  Created by Eric Gambetta-Guglielmana on 10/12/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//

import UIKit
import Firebase

class challengeDB {

    let rootRef =  Database.database().reference().child("Challenges")
    public static let instance = challengeDB()
    init(){
    
    }

    
    public func createChallenge(challengeData: ChallengeModel){
        
        let creator  = rootRef.child(challengeData.creator!).child(challengeData.challenger!)
        let challenged = rootRef.child(challengeData.challenger!).child(challengeData.creator!)
        let creator_challenge = ChallengeModel()
        
        var newEntry = [String: String]()
        
        newEntry.updateValue(challengeData.creator, forKey: "creator")
        newEntry.updateValue(challengeData.challenge, forKey: "challenge")
        newEntry.updateValue(challengeData.startDate, forKey: "startDate")
        newEntry.updateValue(challengeData.endDate, forKey: "endDate")
        newEntry.updateValue(challengeData.challenge, forKey: "challenge")
        newEntry.updateValue(challengeData.bet, forKey: "bet")
        newEntry.updateValue(challengeData.status, forKey: "status")
        
        creator.updateChildValues(newEntry, withCompletionBlock: { (err, ref) in
            
            if let err = err {
                print(err)
                let errComp = err as! String
                print(errComp)
                
                return
            }
            
            
        })
        challenged.updateChildValues(newEntry, withCompletionBlock: { (err, ref) in
            
            if let err = err {
                print(err)
                let errComp = err as! String
                print(errComp)
                
                return
            }
            
            
        })
    }
    
    public func deleteChallenge(yourID: String, friendID: String) {
        rootRef.child(yourID).child(friendID).removeValue()
        rootRef.child(friendID).child(yourID).removeValue()
    }
    public func updateChallenge(yourID: String, friendID: String, updateInfo: String)
    {
        rootRef.child(yourID).child(friendID).updateChildValues(["status": updateInfo])
        rootRef.child(friendID).child(yourID).updateChildValues(["status": updateInfo])
    }
    
    public func getChallenge(userID: String, friendID: String) -> ChallengeModel {
        
        let getDataRef = rootRef.child(userID).child(friendID)
        let challengeData = ChallengeModel()
            getDataRef.observe( .childAdded, with: {(snapshot) in
                //print (snapshot)
                if let dictionary = snapshot.value as? [String: AnyObject] {
                   
                    //print("Creating friends model array")
                    challengeData.creator = dictionary["creator"] as? String
                    challengeData.challenge = dictionary["challenge"] as? String
                    challengeData.startDate = dictionary["startDate"] as? String
                    challengeData.endDate = dictionary["endDate"] as? String
                    challengeData.challenge = dictionary["challenge"] as? String
                    challengeData.bet = dictionary["bet"] as? String
                    challengeData.status = dictionary["status"] as? String
                    //print("Friends Model Array printing")
                    
                    
                }
        })
        return challengeData
    }
}
