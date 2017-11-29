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
        
        storageRef = Storage.storage().reference()
        challengeList.delegate      =   self
        challengeList.dataSource    =   self
        challengeList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        loadInfo()
        loadImage()
        fetchChallenge()
        // Do any additional setup after loading the view.
    }
    
    func loadInfo() {
        uID = UserDefaults.standard.value(forKey: "uID") as! String
        loggedIn = UserDefaults.standard.value(forKey: "isLoggedIn") as! Bool
        
        if ( (uID != Auth.auth().currentUser?.uid) || !(loggedIn) ){
            let loginVC = LoginVC(nibName: "LoginVC", bundle: nil)
            self.navigationController?.pushViewController(loginVC, animated: false)
        }
        
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
    
    func loadImage(){
        guard let storagePath = UserDefaults.standard.object(forKey: "profilePicURL") as? String else {
            return
        }
        //Images are downloaded and cached for quicker use
        let profilePicUrl = URL(string: storagePath)
        profilePic.kf.setImage(with: profilePicUrl)
        
        profilePic.layer.cornerRadius = 10
        profilePic.clipsToBounds = true
       
    }
    

    
    // MARK: - Get Challenges
    func fetchChallenge() {
        
        self.challengeData.removeAll()
        
        
        self.cDB.fetchChallenges(userID: uID) {
            (result: String) in
            if (result == "DataFetched"){
                
                self.challengeData = self.cDB.passFriendData()
                for i in self.challengeData
                {
                    if i.creatorID == self.uID
                    {
                        self.uDB.getUSerData(userID: i.challengerID){
                            (result: String) in
                            if result == "UserData"
                            {
                                print("User data not creator")
                                i.friendData = self.uDB.passUserData()
                                self.challengeList.reloadData()
                            }
                            
                        }
                        
                        
                    }
                    else if i.challengerID == self.uID {
                        self.uDB.getUSerData(userID: i.creatorID ){
                            (result: String) in
                            if result == "UserData"
                            {
                                print("User data not creator")
                                i.friendData = self.uDB.passUserData()
                                self.challengeList.reloadData()
                            }
                            
                        }
                    }
                }
                
            }
        }
        
        
        
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {

        return challengeData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        let challenge = challengeData[indexPath.row]

    
    
        
                if (challenge.status == "pending"){
                    cell.textLabel?.textColor = UIColor.darkGray
                    cell.textLabel?.text = challenge.friendData.first! + " " + challenge.friendData.last!
                    
                    cell.detailTextLabel?.text = "Challenge Request pending"
                    
                } else if ( challenge.status == "request" ){
                    cell.textLabel?.textColor = UIColor.magenta
                   cell.textLabel?.text = challenge.friendData.first! + " " + challenge.friendData.last!
                    cell.detailTextLabel?.text = "Challenging You"
                    
                } else if (challenge.status == "challenge"){
                    cell.tintColor = UIColor.blue
                    cell.textLabel?.textColor = UIColor.red
                    cell.textLabel?.text = challenge.challenge
                    
                    cell.detailTextLabel?.text =  "Challenge Commencing"
                }
                else {
                    cell.tintColor = UIColor.gray
                    cell.textLabel?.textColor = UIColor.darkGray
                    cell.textLabel?.text = "No Challenges"
                }


            
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let challenge = challengeData[indexPath.row]
        
        if (challenge.status == "request") {
            
            let refreshAlert = UIAlertController(title: "Friend Request", message: "Do you want to accept request?" , preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (action: UIAlertAction!) in
                //Accept Friend
                print("Accepted Friend")

                
            }))
            refreshAlert.addAction(UIAlertAction(title: "Decline", style: .default, handler: { (action: UIAlertAction) in
                //Do not Accept
                print("Will not accept")
               
                
                
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                // Do nothing
                print("Canceled")
            }))
            present(refreshAlert, animated: true, completion: nil)
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let refreshAlert = UIAlertController(title: "Remove Friend", message: "Do you want to delelte friend?" , preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                //Remove friend
               
            }))
            refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction) in
                //Do not remove
                print("Kept")
            }))
            
            
            present(refreshAlert, animated: true, completion: nil)
            
        }
    }
}
