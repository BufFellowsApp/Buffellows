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

    let cdDB =  Database.database().reference().child("ChallengData")
    let cuDB =  Database.database().reference().child("ChallengUser")
    public static let instance = challengeDB()
    init(){
    }
    public func createChallenge(challengeData: ChallengeModel, completion:@escaping (_ result: String) -> Void){
        
        let newChallenge = cdDB.childByAutoId()
        let key = newChallenge.key
        let creator  = cuDB.child(challengeData.creatorID!).child(key)
        let challenged = cuDB.child(challengeData.challengerID!).child(key)
        var newEntry = [String: String]()
        
        newEntry.updateValue(challengeData.creatorID, forKey: "creator")
        newEntry.updateValue(challengeData.challengerID, forKey: "challenge")
        newEntry.updateValue(challengeData.startDate, forKey: "startDate")
        newEntry.updateValue(challengeData.endDate, forKey: "endDate")
        newEntry.updateValue(challengeData.challenge, forKey: "challenge")
        newEntry.updateValue(challengeData.exercise, forKey: "exercise")
        newEntry.updateValue(challengeData.bet, forKey: "bet")
        newEntry.updateValue(challengeData.status, forKey: "status")
        
        newChallenge.updateChildValues(newEntry, withCompletionBlock: { (err, ref) in
            if let err = err {
                print(err)
                let errComp = err as! String
                print(errComp)
                return
            }})
        
        creator.updateChildValues(["status": "pending"], withCompletionBlock: { (err, ref) in
            if let err = err {
                print(err)
                let errComp = err as! String
                print(errComp)
                return
            }})
        
        challenged.updateChildValues(["status": "request"], withCompletionBlock: { (err, ref) in
            if let err = err {
                print(err)
                let errComp = err as! String
                print(errComp)
                return
            }})
        
        DispatchQueue.main.async(execute: {
            completion("ChallengeAdded")
        })
    }
    
    public func deleteChallenge(challengeID: String, completion:@escaping (_ result: String) -> Void) {
        let challengeData = getChallenge(challengeID: challengeID)
        
        cuDB.child(challengeData.creatorID!).child(challengeID).removeValue()
        cuDB.child(challengeData.challengerID!).child(challengeID).removeValue()
        cdDB.child(challengeID).removeValue()
        DispatchQueue.main.async(execute: {
            completion("ChallengeAdded")
        })
    }
    public func updateChallenge(challengeID: String, creattorInfo: String, challengerInfo: String, challengeStatus: String, completion:@escaping (_ result: String) -> Void)
    {
        let challengeData = getChallenge(challengeID: challengeID)
        
        cuDB.child(challengeData.creatorID!).child(challengeID).updateChildValues(["status": creattorInfo])
        cuDB.child(challengeData.challengerID!).child(challengeID).updateChildValues(["status": creattorInfo])
        cdDB.child(challengeID).updateChildValues(["status": challengeStatus])
        DispatchQueue.main.async(execute: {
            completion("ChallengeAdded")
        })
    }
    
    public func getChallenge(challengeID: String) -> ChallengeModel {
        
        let getDataRef = cdDB.child(challengeID)
        
        let challengeData = ChallengeModel()
            getDataRef.observe( .childAdded, with: {(snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    challengeData.creatorID = dictionary["creatorID"] as? String
                    challengeData.challengerID = dictionary["challengeID"] as? String
                    challengeData.startDate = dictionary["startDate"] as? String
                    challengeData.endDate = dictionary["endDate"] as? String
                    challengeData.challenge = dictionary["challenge"] as? String
                    challengeData.bet = dictionary["bet"] as? String
                    challengeData.status = dictionary["status"] as? String
                }})
        return challengeData
    }
    func completeTask(userID: String, challengeID: String, day: String, completion:@escaping (_ result: String) -> Void) {
        
        cuDB.child(userID).child(challengeID).child("Day").updateChildValues([day: "True"])
        completion("updateTask")
        
    }
}
