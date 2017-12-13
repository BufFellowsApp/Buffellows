//
//  HomeViewController.swift
//  Buffellows
//
//  Created by Ashish Chatterjee on 7/21/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//


import UIKit
import Firebase
import Kingfisher

class HomeViewController: StandardVC, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var challengeList: UITableView!
    
    let cDB = challengeDB()
    let uDB = userDB()
    
    
    var challengeData  = [ChallengeModel]()
    var cData = ChallengeModel()
    let cellID = "cellId"
    
    
     var storageRef: StorageReference!
    
    var uID: String!
    var loggedIn: Bool!
    var profilePicUrlString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        //Setting up file storage calls
        storageRef = Storage.storage().reference()
        
        //initializing list view
        challengeList.delegate      =   self
        challengeList.dataSource    =   self
        let cellNib = UINib(nibName: "clcell", bundle: nil)
        challengeList.register(cellNib, forCellReuseIdentifier: cellID)
        
        //load saved data
        loadInfo()
        
        // Do any additional setup after loading the view.
        loadImage()
        
       
    }
    
    func setup() {
        firstName.adjustsFontSizeToFitWidth = true
        lastName.adjustsFontSizeToFitWidth = true
        username.adjustsFontSizeToFitWidth = true
        age.adjustsFontSizeToFitWidth = true
    }
    
    func loadInfo() {
        
        //inilizing variables and login status
        uID = UserDefaults.standard.value(forKey: "uID") as! String
        loggedIn = UserDefaults.standard.value(forKey: "isLoggedIn") as! Bool
        
        if ( (uID != Auth.auth().currentUser?.uid) || !(loggedIn) ){
            let loginVC = LoginVC(nibName: "LoginVC", bundle: nil)
            self.navigationController?.pushViewController(loginVC, animated: false)
        }
        //loading user data from presentent data
        firstName.text = UserDefaults.standard.value(forKey: "firstName") as? String
        lastName.text = UserDefaults.standard.value(forKey: "lastName") as? String
        username.text = UserDefaults.standard.value(forKey: "username") as? String
        age.text = UserDefaults.standard.value(forKey: "age") as? String
        profilePicUrlString = UserDefaults.standard.value(forKey: "profilePicURL") as! String
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        challengeData.removeAll()
        fetchChallenge()
        loadImage()
        self.challengeList.reloadData()
        
        
    }
    func loadImage(){
        
        //loading user profile image
        guard let storagePath = UserDefaults.standard.object(forKey: "profilePicURL") as? String else {
            return
        }
        //Images are downloaded and cached for quicker use
        let profilePicUrl = URL(string: storagePath)
        profilePic.kf.setImage(with: profilePicUrl)
        
        //rounding edges of profile picture
        profilePic.layer.cornerRadius = 10
        profilePic.clipsToBounds = true
       
    }
    

    
    // MARK: - Get Challenges
    func fetchChallenge() {
        //clear challenge data for clean use
        self.challengeList.reloadData()
        self.challengeData.removeAll()
        
        //challenge data is called for current challenges
        //for current user

            self.cDB.fetchChallenges(userID: self.uID) {
            (result: String) in
            if (result == "DataFetched"){
                self.challengeData = self.cDB.passFriendData()
                self.challengeList.reloadData()
            }
        }
     
     

        self.challengeList.reloadData()
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {

        return challengeData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! clcell
        let challenge = challengeData[indexPath.row]
        
        if (challenge.status == "pending"){
            cell.challenge?.textColor = UIColor.darkGray
            cell.challenge?.text = challenge.challenge! + " is pending"
            
           
                    
        } else if ( challenge.status == "request" ){
            cell.challenge?.textColor = UIColor.magenta
            cell.challenge?.text = challenge.challenge! + " is waitng for response"
           
            
            
                    
        } else if (challenge.status == "challenge"){
            cell.tintColor = UIColor.blue
            cell.challenge?.textColor = UIColor.red
            cell.challenge?.text = challenge.challenge!
            
            cell.detailTextLabel?.text =  "Challenge Commencing"
            
            
   
            
        }
        else if (challenge.status == "completed") {
            cell.challenge.text = challenge.challenge + " has been completed!"
        }
        else {
            cell.tintColor = UIColor.gray
            cell.challenge?.textColor = UIColor.darkGray
            cell.challenge?.text = "No Challenges"
            }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let challenge = challengeData[indexPath.row]
        if (challenge.status == "request") {
            let refreshAlert = UIAlertController(title: "You have been Challenged", message: "Do you want to accept request?" , preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (action: UIAlertAction!) in
                self.cDB.updateChallenge(challengeID: challenge.challengeKey, creattorInfo: challenge.creatorID, challengerInfo: challenge.challengerID, challengeStatus: "challenge") {
                    
                    (results: String) in
                    if (results == "ChallengeUpdated"){
                    self.fetchChallenge()
                    }
                    
                }
            print("Accepted Challenge")

            }))
            refreshAlert.addAction(UIAlertAction(title: "Decline", style: .default, handler: { (action: UIAlertAction) in
                self.cDB.deleteChallenge(challengeID: challenge.challengeKey, creatorID: challenge.creatorID, challengerID: challenge.challengerID) {
                    (results: String) in
                    if (results == "ChallengeDeleted"){
                        self.fetchChallenge()
                    }
                }                
                print("Declined Challenge")
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                // Do nothing
                print("Canceled")
            }))
            present(refreshAlert, animated: true, completion: nil)
        }
        else if (challenge.status == "challenge") {
            let refreshAlert = UIAlertController(title: "Challenge", message: "Have you compelted the challenge?" , preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.cDB.completeTask(creatorID: challenge.creatorID, challengerID: challenge.challengerID, challengeID: challenge.challengeKey)
                
            }))

            refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                // Do nothing
                print("Have no completed")
            }))
            present(refreshAlert, animated: true, completion: nil)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let challenge = challengeData[indexPath.row]
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let refreshAlert = UIAlertController(title: "Remove Challenge", message: "Do you want to delete challenge?" , preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction) in
                //Do not remove
                print("Not Deleted")
            }))
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.cDB.deleteChallenge(challengeID: challenge.challengeKey, creatorID: challenge.creatorID, challengerID: challenge.challengerID) {
                    (results: String) in
                    if (results == "ChallengeDeleted"){
                        self.fetchChallenge()
                    }
                }
               
            }))
      
            present(refreshAlert, animated: true, completion: nil)
            
        }
    }


}
