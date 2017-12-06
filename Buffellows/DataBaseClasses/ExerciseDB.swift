//
//  ExerciseDB.swift
//  Buffellows
//
//  Created by Eric Gambetta-Guglielmana on 12/4/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//

import Foundation
import Firebase

class ExerciseDB{
    
    public static let instance = ExerciseDB()
    
    let exercises = ["Shoulders","Chest", "Bicep", "Tricep", "Back", "Legs", "Cardio"]
    var eArray = [String]()
    let eDB = Database.database().reference().child("Workouts")
    var exerciseData = [String: [String]]()

    func getWorkouts (completion:@escaping (_ result: String) -> Void) {
        
        self.exerciseData.removeAll()
        eDB.removeAllObservers()
        for i in exercises {
            self.exerciseData.updateValue([String](), forKey: i)
            
            eDB.child(i).observe(.childAdded, with: {(snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    let exercise = dictionary["name"] as? String
                    self.exerciseData[i]?.append(exercise!)
                    
                }
            
            completion("Exerecises")
            })
  
        }
        
    }
    func passWorkouts() -> [String: [String]] {
        return self.exerciseData
    }
}
