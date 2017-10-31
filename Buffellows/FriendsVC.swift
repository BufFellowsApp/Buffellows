	//
//  FriendsVC.swift
//  Buffellows
//
//  Created by Ashish Chatterjee on 10/22/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//

import UIKit
import Firebase


class FriendsVC: StandardVC, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {
    
    @IBOutlet weak var friendsList: UITableView!
    
 
    @IBAction func AddFriend(_ sender: Any) {
        
    }
    //var friendsList: UITableView = UITableView()
    var filterData = [FriendsModel]()
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
        
       
        friendsList.delegate      =   self
        friendsList.dataSource    =   self
        friendsList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //self.view.addSubview(self.friendsList)

        fetchFriends()
        self.searchBarSetup()
        
        
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        friendsList.reloadData()
        print("View did Appear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: DATABASE
    func fetchFriends() {
        Database.database().reference().child("Users").child(uID).child("friends").observe( .childAdded, with: {(snapshot) in
            //print (snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let key = snapshot.key
                //print("Creating friends model array")
                let friendInfo = FriendsModel()
                friendInfo.Name = dictionary["Name"] as! String
                friendInfo.status = dictionary["status"] as! String
                friendInfo.userID = key
                self.friendsData.append(friendInfo)
                //print("Friends Model Array printing")
                
                
            }
            DispatchQueue.main.async(execute: {
                self.friendsList.reloadData()
                
            })
            //print ("Done Fetching Users")
        })
        
        
        
        
        
    }
    //MARK: SSEARCH BAR
    func searchBarSetup(){
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        searchBar.backgroundImage = UIImage()
        searchBar.barStyle = UIBarStyle.black
        
        self.friendsList.tableHeaderView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            filterData = friendsData
        }
        
    }
    
    func filterTableView(text: String) {
        //Add filtering
    }
    
    
    func getUid() -> String {
        return (Auth.auth().currentUser?.uid)!
    }

    
    //MARK: TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return friendsData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        let user = friendsData[indexPath.row]
        
        if (user.status == "pending"){
            cell.textLabel?.textColor = UIColor.darkGray
            cell.textLabel?.text = user.Name
            cell.detailTextLabel?.text = "Friend Request pending"
            
        } else if ( user.status == "request" ){
            cell.textLabel?.textColor = UIColor.magenta
            cell.textLabel?.text = user.Name
            cell.detailTextLabel?.text = "Requesting Friendship"
            
        } else {
            cell.tintColor = UIColor.blue
            cell.textLabel?.textColor = UIColor.red
            cell.textLabel?.text = user.Name
        }
        
        
        
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let user = friendsData[indexPath.row]
        print(user.status)
        if (user.status == "request") {
            
            let refreshAlert = UIAlertController(title: "Friend Request", message: "Do you want to accept \(user.Name ?? "Name") request?" , preferredStyle: UIAlertControllerStyle.alert)
            
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
            let refreshAlert = UIAlertController(title: "Friend Request", message: "Do you want to delelte friend?" , preferredStyle: UIAlertControllerStyle.alert)
  
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                //Remove friend
                print("Removed Friend")
                self.friendsData.remove(at: indexPath.row)
                self.friendsList.reloadData()
            }))
            refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction) in
                //Do not remove
                print("Kept")
            }))


            present(refreshAlert, animated: true, completion: nil)
            
        }
    }
}
