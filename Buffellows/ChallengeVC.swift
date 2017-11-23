//
//  ChallengeVC.swift
//  Buffellows
//
//  Created by Eric Gambetta-Guglielmana on 11/13/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//

// CHALLENGE SETUP PAGE

import UIKit
import SearchTextField
import Firebase

class ChallengeVC: StandardVC {
    
    // Set up includes:
    //  Challengee - Searchable - inline?
    //  Muscle Group - Searchable - inline?
    //      Exercise - Searchable - inline?
    //  Number of Reps / Distance - Raw info
    //  Duration - Dropdown while searching
    //  Incentive / Prize - Raw Info
    let cDB = challengeDB()
    var userDict = [String:String]()
    let challengeeSearch = SearchTextField(frame: CGRect(x: UIScreen.main.bounds.width/16, y: 100, width: 7*UIScreen.main.bounds.width/8, height: 50))
    var friendsDict = ["Friends" : ["Ashish", "Eric", "Kambi", "Rahul", "Daniel"],
                       "FriendID" : ["0", "1","2","3","4"] ]
    
    
    let muscleGroupSearch = SearchTextField(frame: CGRect(x: UIScreen.main.bounds.width/16, y: 175, width: 7*UIScreen.main.bounds.width/8, height: 50))
    let muscleGroupDict = ["Cardio" : ["Cardio 1", "Cardio 2"],
                           "Chest" : ["Chest 1", "Chest 2"],
                           "Back" : ["Back 1", "Back 2"],
                           "Biceps" : ["Biceps 1", "Biceps 2"],
                           "Triceps" : ["Triceps 1", "Triceps 2"],
                           "Shoulders" : ["Shoulders 1", "Shoulders 2"],
                           "Legs" : ["Legs 1", "Legs 2"]]
    
    let numRepsSearch = SearchTextField(frame: CGRect(x: UIScreen.main.bounds.width/16, y: 250, width: 7*UIScreen.main.bounds.width/8, height: 50))
    let numRepsDict = ["Reps" : ["10 Reps", "25 Reps", "50 Reps", "75 Reps", "100 Reps", "150 Reps", "200 Reps"]]
    let distDict = ["Distance": ["1 Mile", "2 Miles", "2.5 Miles", "3 Miles"]]
    
    let durationSearch = SearchTextField(frame: CGRect(x: UIScreen.main.bounds.width/16, y: 325, width: 7*UIScreen.main.bounds.width/8, height: 50))
    let durDict = ["Duration": ["1 Day", "2 Days", "3 Days", "4 Days", "5 Days", "6 Days", "1 Week", "2 Weeks"]]
    
    var submit = UIButton()
    
    let messageLabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/16, y: 400, width: 7*UIScreen.main.bounds.width/8, height: 100))
    var message: String!
    var friend: String!
    var exercise: String!
    var reps: String!
    var duration: String!
    
    
    //DATABASE VARS
    let fDB = FriendsDB()
    let uDB = userDB()
    var uID :String! = Auth.auth().currentUser?.uid
    var friendsData  = [FriendsModel]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //uID = Auth.auth().currentUser?.uid
        getFriendsList()
        //setUpSearch(challengeeSearch, friendsDict, "Choose a friend to Challenge!")
        setUpSearch(muscleGroupSearch, muscleGroupDict, "Enter in an Exercise!")
        setUpSearch(durationSearch, durDict, "How long to complete this challenge?")
        
        
        submit.frame = CGRect(x: UIScreen.main.bounds.width/16, y: UIScreen.main.bounds.height-125, width: 7*UIScreen.main.bounds.width/8, height: 50)
        submit.backgroundColor = UIColor(red: 50/255, green: 0, blue: 0, alpha: 1)
        submit.tintColor = UIColor.white
        submit.setTitle("Submit!", for: .normal)
        submit.addTarget(self, action: #selector(self.submitTapped), for: .touchUpInside)
        self.view.addSubview(submit)
        
        // Do any additional setup after loading the view.
        
    }
    
    func submitTapped(_ sender: UIButton) {
        let friendID = userDict[friend] as! String
        print("MY ID--------------------------\(uID!)")
        print("FRIEND ID ---------------------\(friendID)")
        if(self.message != nil) {
           
            
            
            let dateformat = DateFormatter()
            dateformat.dateFormat = "dd/MM/yyyy"
            let challenge = ChallengeModel()
            challenge.creatorID = uID ?? "na"
            challenge.challengerID = friendID
            challenge.challenge = self.reps
            challenge.startDate = dateformat.string(from:Date())
            challenge.endDate = self.duration
            challenge.bet = "None"
            challenge.status = "request"
            challenge.exercise = self.exercise
            print("-----------------DATE--------------")
            print(challenge.challengerID)
            cDB.createChallenge(challengeData: challenge){
            (result:String) in
                if (result == "ChallengeAdded") {
                    print("Pop ViewController")
                    self.navigationController?.popViewController(animated: false)
                }
            }

            

        } else {
            let alert = UIAlertController(title: "Error", message: "Please fill out all the information!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setUpSearch(_ stf: SearchTextField, _ dict: [String : [String]], _ placeholder: String) {
        
        stf.placeholder = placeholder
        stf.layer.backgroundColor = UIColor.white.cgColor
        let pad = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        stf.leftView = pad
        stf.leftViewMode = .always
        var selTitle: String!
        var selSub: String!
        
        var searchableItems: [SearchTextFieldItem] = []
        for key in dict {
            let subtitle = key.key
            let titleArr = key.value
            for title in titleArr {
                let item = SearchTextFieldItem(title: title, subtitle: subtitle)
                searchableItems.append(item)
            }
        }
        stf.filterItems(searchableItems)
        
        stf.theme = .darkTheme()
        stf.theme.bgColor = UIColor.white
        stf.theme.font = UIFont.systemFont(ofSize: 15)
        stf.theme.borderColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        stf.theme.separatorColor = UIColor(red: 50/255, green: 0, blue: 0, alpha: 1)
        stf.theme.fontColor = UIColor.gray.withAlphaComponent(0.7)
        stf.theme.cellHeight = 50
        
        // Set specific comparision options - Default: .caseInsensitive
        stf.comparisonOptions = [.caseInsensitive]
        
        // Set the max number of results. By default it's not limited
        stf.maxNumberOfResults = 5
        
        // You can also limit the max height of the results list
        stf.maxResultsListHeight = 200
        
        // Customize the way it highlights the search string. By default it bolds the string
        stf.highlightAttributes = [NSForegroundColorAttributeName: UIColor(red: 50/255, green: 0, blue: 0, alpha: 1), NSFontAttributeName:UIFont.boldSystemFont(ofSize: 15)]
        
        // Handle what happens when the user picks an item. By default the title is set to the text field
        stf.itemSelectionHandler = {item, itemPosition in
            
            stf.text = item.title
            selTitle = item.title
            selSub = item.subtitle
            self.conditionChecking(selSub)
            self.createMessage(selSub, selTitle)
        }
       
        stf.inlineMode = true
        
        // Show the list of results as soon as the user makes focus - Default: false
        stf.startVisible = false
        
        
        self.view.addSubview(stf)
        self.view.bringSubview(toFront: stf)
        
    }
    
    func createMessage(_ type: String, _ msg: String) {
        if(type == "Friends") {
            self.friend = msg
        } else if (type == "Reps" || type == "Distance") {
            self.reps = msg
        } else if (type == "Duration") {
            self.duration = msg
        } else {
            self.exercise = msg
        }
        
        if(self.friend != nil && self.reps != nil && self.duration != nil && self.exercise != nil) {
            self.message = self.friend + " has " + self.duration + " to complete " + self.reps + " of " + self.exercise
            print(self.message)
            self.messageLabel.text = self.message
            self.messageLabel.numberOfLines = 3
            self.messageLabel.textColor = UIColor(red: 50/255, green: 0, blue: 0, alpha: 1)
            self.messageLabel.textAlignment = .center
            self.messageLabel.font = UIFont.systemFont(ofSize: 22)
            self.view.addSubview(messageLabel)
        }
    }
    
    func conditionChecking(_ string: String) {
        
        if(string == "Cardio") {
            setUpSearch(numRepsSearch, distDict, "Enter the Distance!")
        } else {
            setUpSearch(numRepsSearch, numRepsDict, "Enter the Number of Reps!")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func getFriendsList(){
        let getFriend = FriendsModel()
        friendsData.removeAll()
        getFriend.yourID = uID
        
        print(uID)
        print(friendsDict)
        self.fDB.fetchFriends(friend: getFriend) {
            (result: String) in
            if (result == "DataFetched"){
                self.friendsDict["Friends"]?.removeAll()
                self.friendsDict["FriendID"]?.removeAll()
                self.userDict.removeAll()
                
                self.friendsData = self.fDB.passFriendData()
                for users in self.friendsData {
                    if (users.status == "friend"){
                        let name =  "\(users.first!) \(users.last!)"
                        print(name)
                        self.friendsDict["Friends"]?.append(name)
                        
                        self.friendsDict["FriendID"]?.append(users.friendID!)
                        self.userDict.updateValue(users.friendID!, forKey: name)
                    }
                }
               
                self.setUpSearch(self.challengeeSearch, self.friendsDict, "Choose a friend to Challenge!")
            }
            
        }
      
    }

}
