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
    let uDB = userDB()
    var challengeList  = [ChallengeModel]()
    var challengeData = ChallengeModel()
    public static let instance = challengeDB()

    
    
    // Create a new challenge
    // to call
    // createChallenge(challengeModel) {
    // (result: String) in
    // if (result == "ChallengeAdded") {
    //  code block
    // } else {
    // code block
    // }

    public func createChallenge(challengeData: ChallengeModel, completion:@escaping (_ result: String) -> Void){
        
        let newChallenge = cdDB.childByAutoId()
        let key = newChallenge.key
        let creator  = cuDB.child(challengeData.creatorID!).child(key)
        let challenged = cuDB.child(challengeData.challengerID!).child(key)
        var newEntry = [String: String]()
        var newCreator = [String: String]()
        var newChallenged = [String: String]()
        newEntry.updateValue(challengeData.creatorID, forKey: "creatorID")
        newEntry.updateValue(challengeData.challengerID, forKey: "challengerID")
        newEntry.updateValue(challengeData.startDate, forKey: "startDate")
        newEntry.updateValue(challengeData.endDate, forKey: "endDate")
        newEntry.updateValue(challengeData.challenge, forKey: "challenge")
        newEntry.updateValue(challengeData.exercise, forKey: "exercise")
        newEntry.updateValue(challengeData.bet, forKey: "bet")
        newEntry.updateValue(challengeData.status, forKey: "status")
        newCreator = newEntry
        newChallenged = newEntry
        newCreator["status"] = "pending"
        newChallenged["status"] = "request"
        
        newChallenge.updateChildValues(newEntry, withCompletionBlock: { (err, ref) in
            if let err = err {
                print(err)
                return
            }
            print("newChallenge Added")
        })
        
        creator.updateChildValues(newCreator, withCompletionBlock: { (err, ref) in
            if let err = err {
                print(err)
                return
            }
            print("creator Added")
        })
        
        challenged.updateChildValues(newChallenged, withCompletionBlock: { (err, ref) in
            if let err = err {
                print(err)
                return
            }
            print("challenged Added")

        })
        completion("ChallengeAdded")
        
    
    }
    
    //DELETE CHALLENGE
    // to call
    // userDB.deleteChallenge(string, string, string, string) {
    // (result: String) in
    // if (result == "ChallengeDeleted") {
    //  code block
    // } else {
    // code block
    // }
    public func deleteChallenge(challengeID: String, creatorID: String, challengerID: String, completion:@escaping (_ result: String) -> Void) {
        
        
        cuDB.child(creatorID).child(challengeID).removeValue()
        cuDB.child(challengerID).child(challengeID).removeValue()
        cdDB.child(challengeID).removeValue()
        DispatchQueue.main.async(execute: {
            
            completion("ChallengeDeleted")
        })
    }
    // update challenge status
    // to call
    // challengeDB.updateChallenge(challengeID, creatorInfo, challengeInfo, challengeStatus) {
    // (result: String) in
    // if (result == "ChallengeUpdated") {
    //  code block
    // } else {
    // code block
    // }
    public func updateChallenge(challengeID: String, creattorInfo: String, challengerInfo: String, challengeStatus: String, completion:@escaping (_ result: String) -> Void)
    {
        
        
        cuDB.child(creattorInfo).child(challengeID).updateChildValues(["status": "challenge"])
        cuDB.child(challengerInfo).child(challengeID).updateChildValues(["status": "challenge"])
        cdDB.child(challengeID).updateChildValues(["status": "challenge"])
        
            completion("ChallengeUpdated")
       
    }
    //Function for user to update if they completed their task for the challenge that day.
    // to call  challengeDB.getChallenge(challengeID) {
    // (result: String) in
    // if (result == "FoundChallenge") {
    //  code block
    // } else {
    // code block
    // }
    private func getData(challengeID: String)-> ChallengeModel {
        
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
                challengeData.challengeKey = snapshot.key
            }})
        return challengeData
    }


    public func getChallenge(challengeID: String, completion:@escaping (_ result: String) -> Void)  {
        
        let getDataRef = cdDB.child(challengeID)
        
        challengeData = ChallengeModel()
            getDataRef.observe( .childAdded, with: {(snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.challengeData.creatorID = dictionary["creatorID"] as? String
                    self.challengeData.challengerID = dictionary["challengeID"] as? String
                    self.challengeData.startDate = dictionary["startDate"] as? String
                    self.challengeData.endDate = dictionary["endDate"] as? String
                    self.challengeData.challenge = dictionary["challenge"] as? String
                    self.challengeData.bet = dictionary["bet"] as? String
                    self.challengeData.status = dictionary["status"] as? String
                }
                //completion("FoundChallenge")
            })
       
            completion("FoundChallenge")
       
    }
    func passChallengeData () -> ChallengeModel {
        return challengeData
    }
    //Function for user to update if they completed their task for the challenge that day.
    // to call  userDB.completeTask(creatorID, challengerID, challengeID) {
    // (result: String) in
    // if (result == "updateTask") {
    //  code block
    // } else {
    // code block
    // }
    func completeTask(creatorID: String, challengerID: String, challengeID: String)  {
        
        cuDB.child(creatorID).child(challengeID).updateChildValues(["status": "complete"])
        cuDB.child(challengerID).child(challengeID).updateChildValues(["status": "complete"])
        cdDB.child(challengeID).updateChildValues(["status": "complete"])
        
        
    }
    public func fetchChallenges(userID: String,  completion:@escaping (_ result: String) -> Void)  {
        self.challengeList.removeAll()
        cuDB.removeAllObservers()
        
        cuDB.child(userID).observe(.childAdded , with: {(snapshot) in
            
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let key = snapshot.key
                let challengeInfo = ChallengeModel()
                challengeInfo.challengeKey = key
                challengeInfo.creatorID = dictionary["creatorID"] as? String
                challengeInfo.challengerID = dictionary["challengerID"] as? String
                challengeInfo.challenge = dictionary["challenge"] as? String
                challengeInfo.endDate = dictionary["endDate"] as? String
                challengeInfo.exercise = dictionary["exercise"] as? String
                challengeInfo.startDate = dictionary["startDate"] as? String
                challengeInfo.status = dictionary["status"] as? String
                self.challengeList.append(challengeInfo)
                
            }
            completion("DataFetched")
            
        }, withCancel: { (error) in
            
            print(error.localizedDescription)
            completion("DataError")
            
            })
    }
    func passFriendData() -> [ChallengeModel] {
        return self.challengeList
    }
}
