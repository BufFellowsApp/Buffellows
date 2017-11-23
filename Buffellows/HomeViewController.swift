//
//  HomeViewController.swift
//  Buffellows
//
//  Created by Ashish Chatterjee on 7/21/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: StandardVC, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var challengeList: UITableView!
    
    let cDB = challengeDB()
    
    
    var friendsData  = [FriendsModel]()
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
        fetchFriends()
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
        print("Profile Pic Value: \(profilePicUrlString!)")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadImage(){
        
        print("Loading Profile Image")
        
    
        guard let storagePath = UserDefaults.standard.object(forKey: "profilePicURL") as? String else {
            return
        }
        print("---PROFILE PIC STORAGE PATH:  \(storagePath)")
        // [START downloadimage]
        let httpsReference = Storage.storage().reference(forURL: storagePath)
        httpsReference.downloadURL(completion: { (url, error) in
            if error != nil {
            print(error?.localizedDescription)
            return
            }
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error)
                    return
                }
                guard let imageData = UIImage(data: data!) else { return }
                DispatchQueue.main.async {
                    self.profilePic.image = imageData
                }
            }).resume()
    })
        // [END downloadimage]
        profilePic.layer.cornerRadius = 10
        profilePic.clipsToBounds = true
       
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Get Challenges
    func fetchFriends() {
        
        self.friendsData.removeAll()
        
        let getFriend = FriendsModel()
        getFriend.yourID = uID
        self.cDB.fetchFriends(userID: uID) {
            (result: String) in
            if (result == "DataFetched"){
                
                self.friendsData = self.cDB.passFriendData()
                self.challengeList.reloadData()
            }
        }
        
        
        
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {

        return friendsData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        var user = FriendsModel()
        
       
            user = friendsData[indexPath.row]
            
            if (user.status == "pending"){
                cell.textLabel?.textColor = UIColor.darkGray
                cell.textLabel?.text = user.friendID
                
                cell.detailTextLabel?.text = "Friend Request pending"
                
            } else if ( user.status == "request" ){
                cell.textLabel?.textColor = UIColor.magenta
                cell.textLabel?.text = user.friendID
                cell.detailTextLabel?.text = "Requesting Friendship"
                
            } else if (user.status == "friend"){
                cell.tintColor = UIColor.blue
                cell.textLabel?.textColor = UIColor.red
                cell.textLabel?.text = user.friendID
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
        let user = friendsData[indexPath.row]
        
        if (user.status == "request") {
            
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
