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
    
    @IBOutlet weak var friendsCell: UITableViewCell!
    
    @IBAction func AddFriend(_ sender: Any) {
        
        let tempFM = FriendsModel()
        let tempUser = UserModel()
        tempFM.friendID = "QYLnLUM8xEZzHbx9JoEBSvNfM1s1"
        tempFM.first = "Daniel"
        tempFM.last = "Lastname"
        tempFM.status = "pending"
        tempFM.yourID = uID
        tempUser.email = "eric@email.com"
        tempUser.first = "Eric"
        tempUser.last = "Gambetta"
        tempUser.userID = uID
        if friendsData.contains(where: {$0.friendID == tempFM.friendID})
        {
            print("Friend already Exist")
        }
        else {
            print("Added Friend")
            fDB.addFriend(friend: tempFM, user: tempUser)
            
        }
        self.friendsList.reloadData()
        
        
    }
    
    

    
    
    
    //var friendsList: UITableView = UITableView()
    var filterData = [FriendsModel]()
    var friendsData  = [FriendsModel]()
    var tempFriend = FriendsModel()
    var tempUser = UserModel()
    let uID : String! = "PEgAo0eg7jcTh5SouxNeQodFsA63"
    var searchActive : Bool = false
    let cellID = "cellId"
    let fDB = FriendsDB()
    let uDB = userDB()
    var userData = UserModel()
    var refreshController = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        print ("Friends list View Loaded")
        searchActive = false
        
        print ("Getting USer Data model")
        getUserData()
        
        print ("Fetching Users")

        friendsList.delegate      =   self
        friendsList.dataSource    =   self
        friendsList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //self.view.addSubview(self.friendsList)
        
        self.friendsList.refreshControl = self.refreshController
        self.refreshController.addTarget(self, action: #selector(FriendsVC.didRefreshList), for: .valueChanged)
        
        
        fetchFriends()
        self.searchBarSetup()
        //self.friendsList.frame = CGRe
        
        
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        print("View did Appear")
        searchActive = false
        self.friendsList.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: REFRESH CONTROLLER
    func didRefreshList(){
        self.fetchFriends()
        self.refreshController.endRefreshing()
    }
    //MARK: DATABASE
    func fetchFriends() {
        
        let getFriend = FriendsModel()
        getFriend.yourID = uID
        self.fDB.fetchFriends(friend: getFriend) {
            (result: String) in
            if (result == "DataFetched"){
                self.friendsData = self.fDB.passFriendData()
                self.friendsList.reloadData()
            }
        }
    }
    //MARK: SSEARCH BAR
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
   
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text  else { return }
        
        
        
        let charset = CharacterSet(charactersIn: "@")
        if (text.rangeOfCharacter(from: charset) != nil) {
            print ("The Text is:  \(text)")
            
            uDB.findUser(email: text.lowercased()) {
            (result: String) in
                if (result == "FoundUser") {
                    print("Future Friend Found")
                    self.userFound()
                    searchBar.text = ""
                    self.searchActive = false
                }
                else {
                    print("No User Found")
                }
            }
        }
        searchActive = false;
        
    }

    func searchBarSetup(){
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        searchBar.backgroundImage = UIImage()
        searchBar.barStyle = UIBarStyle.black
        searchBar.delegate = self
        self.friendsList.tableHeaderView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filterData = friendsData.filter({ (text) -> Bool in
            let tmp: NSString = text.first! as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filterData.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.friendsList.reloadData()
    }
 
    func getUserData() {
        print("Get USer Data")
        uDB.getUSerData(userID: self.uID)
        {
            (result: String) in
            if (result == "UserData")
            {
                print("User Data found")
                self.userData = self.uDB.passUserData()
                print(self.userData.userID!)
                
                
            }
            
        }
    }
    func userFound() {
        
        tempUser = uDB.passUserData()
        tempFriend.first = tempUser.first
        tempFriend.last = tempUser.last
        tempFriend.friendID = tempUser.userID
        tempFriend.yourID = userData.userID
        print("The Temp user is: \(tempFriend.first!) \(tempFriend.last!)")
                if self.friendsData.contains(where: {$0.friendID == self.tempFriend.friendID}) || (tempFriend.friendID == userData.userID)
                {
                    print("Friend already Exist")
                }
                else {
                    print("Friend can be added")
                    let refreshAlert = UIAlertController(title: "Add Friend", message: "Do you want to send a friend request to \(self.tempFriend.first!) \(self.tempFriend.last!)" , preferredStyle: UIAlertControllerStyle.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                        //Add friend
                        print("Friend Request")
                        self.fDB.addFriend(friend: self.tempFriend, user: self.userData)
                        self.searchActive = false
                        self.friendsData.removeAll()
                        
                       self.fetchFriends()
                    }))
                    refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction) in
                        //Do not Add
                        print("Not Added")
                    }))
                    
                    
                    present(refreshAlert, animated: true, completion: nil)
                    
                }
                
        
            
        
        
        
    }
    
    
    func getUid() -> String {
        return (Auth.auth().currentUser?.uid)!
    }

    
    //MARK: TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (searchActive) {
            return filterData.count
        }
        return friendsData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        var user = FriendsModel()
        if (searchActive){
            user = filterData[indexPath.row]
            if (user.status == "pending"){
                cell.textLabel?.textColor = UIColor.darkGray
                cell.textLabel?.text = user.first! + " " + user.last!
                
                cell.detailTextLabel?.text = "Friend Request pending"
                
            } else if ( user.status == "request" ){
                cell.textLabel?.textColor = UIColor.magenta
                cell.textLabel?.text = user.first! + " " + user.last!
                cell.detailTextLabel?.text = "Requesting Friendship"
                
            } else {
                cell.tintColor = UIColor.blue
                cell.textLabel?.textColor = UIColor.red
                cell.textLabel?.text = user.first! + " " + user.last!
            }
        }
        else {
            user = friendsData[indexPath.row]
            if (user.status == "pending"){
                cell.textLabel?.textColor = UIColor.darkGray
                cell.textLabel?.text = user.first! + " " + user.last!
                
                cell.detailTextLabel?.text = "Friend Request pending"
                
            } else if ( user.status == "request" ){
                cell.textLabel?.textColor = UIColor.magenta
                cell.textLabel?.text = user.first! + " " + user.last!
                cell.detailTextLabel?.text = "Requesting Friendship"
                
            } else {
                cell.tintColor = UIColor.blue
                cell.textLabel?.textColor = UIColor.red
                cell.textLabel?.text = user.first! + " " + user.last!
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let user = friendsData[indexPath.row]
        print(user.status ?? "None")
        if (user.status == "request") {
            
            let refreshAlert = UIAlertController(title: "Friend Request", message: "Do you want to accept \(user.first!) request?" , preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (action: UIAlertAction!) in
                //Accept Friend
                print("Accepted Friend")
                self.fDB.friendRequestResponse(userID: self.uID, friendID: user.friendID!, response: "accept")
                self.fetchFriends()
            }))
            refreshAlert.addAction(UIAlertAction(title: "Decline", style: .default, handler: { (action: UIAlertAction) in
                //Do not Accept
                print("Will not accept")
                self.fDB.friendRequestResponse(userID: self.uID, friendID: user.friendID!, response: "decline")
                self.friendsData.remove(at: indexPath.row)
                self.fetchFriends()
                
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
        let user = friendsData[indexPath.row]
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let refreshAlert = UIAlertController(title: "Remove Friend", message: "Do you want to delelte friend?" , preferredStyle: UIAlertControllerStyle.alert)
  
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                //Remove friend
                print("Removed Friend")
                self.fDB.friendRequestResponse(userID: self.uID, friendID: user.friendID!, response: "delete")
                self.friendsData.removeAll()
                self.fetchFriends()
            }))
            refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction) in
                //Do not remove
                print("Kept")
            }))


            present(refreshAlert, animated: true, completion: nil)
            
        }
    }
}
   
