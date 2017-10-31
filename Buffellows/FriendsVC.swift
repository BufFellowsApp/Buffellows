	//
//  FriendsVC.swift
//  Buffellows
//
//  Created by Ashish Chatterjee on 10/22/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//

import UIKit
import Firebase


class FriendsVC: StandardVC, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var friendsList: UITableView!
    @IBOutlet weak var addUser: UIButton!
    @IBOutlet weak var searchFriends: UISearchBar!
    //var friendsList: UITableView = UITableView()
    
    var friendsData  = [FriendsModel]()
    var uID : String!
    let cellID = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        print ("Friends list View Loaded")
        
        uID = "PEgAo0eg7jcTh5SouxNeQodFsA63"
        print ("Fetching Users")
        
        friendsList.layoutMargins = UIEdgeInsetsMake(70,16,16,16)
        searchFriends.layoutMargins = UIEdgeInsetsMake(30, 10, 16, 10)
       
        friendsList.delegate      =   self
        friendsList.dataSource    =   self
        friendsList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //self.view.addSubview(self.friendsList)

        fetchFriends()
        
        
        
        
        
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
    func fetchFriends() {
        Database.database().reference().child("Users").child(uID).child("friends").observe( .childAdded, with: {(snapshot) in
            print (snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let key = snapshot.key
                print("Creating friends model array")
                let friendInfo = FriendsModel()
                friendInfo.Name = dictionary["Name"] as! String
                friendInfo.status = dictionary["status"] as! String
                friendInfo.userID = key
                self.friendsData.append(friendInfo)
                print("Friends Model Array printing")
                
                
            }
            DispatchQueue.main.async(execute: {
                self.friendsList.reloadData()
                
            })
            print ("Done Fetching Users")
        })
        
        
        
        
        
    }
    func getUid() -> String {
        return (Auth.auth().currentUser?.uid)!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return friendsData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        let user = friendsData[indexPath.row]
        cell.textLabel?.text = user.Name
        
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let user = friendsData[indexPath.row]
        print(user.status)
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            friendsData.remove(at: indexPath.row)
            self.friendsList.reloadData()
        }
    }
}
