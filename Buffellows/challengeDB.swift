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
    private init(){
        FirebaseApp.configure()
    }

    
    public func addChallenge(challengeData: [String: String]){
        
        
        let challengeID = challengeData["CreatorID"]! + challengeData["ChallengerID"]! + challengeData["Name"]! + challengeData["StartDate"]! + challengeData["EndDate"]!
        let challengeAdd = rootRef.child(challengeID)
        
        
        challengeAdd.setValue(["Name": challengeData["Name"]])
        challengeAdd.setValue(["Creator": challengeData["CreatorID"]])
        challengeAdd.setValue(["Challenger": challengeData["ChallengerID"]])
        challengeAdd.setValue(["StartDate": challengeData["StartDate"]])
        challengeAdd.setValue(["EndDate": challengeData["EndDate"]])
        challengeAdd.setValue(["Challenge": challengeData["Challenge"]])
        challengeAdd.setValue(["Bet": challengeData["Bet"]])
        challengeAdd.setValue(["Status" : "Waiting for Acceptance"])
        
    }
    
    public func deleteChallenge(challengeID: String) {
        rootRef.child(challengeID).removeValue()
    }
    public func updateChallenge(challengeID: String, updateInfo: String)
    {
        rootRef.child(challengeID).updateChildValues(["Status": updateInfo])
    }
    
}
