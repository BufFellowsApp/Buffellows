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

    //var friendsList: UITableView = UITableView()
    var filterData = [FriendsModel]()
    var friendsData  = [FriendsModel]()
    var tempFriend = FriendsModel()
    var tempUser = UserModel()
    var userData = UserModel()
    
    
    let uID : String! =  Auth.auth().currentUser?.uid
    var searchActive : Bool = false
    let cellID = "cellId"
    
    let fDB = FriendsDB()
    let uDB = userDB()
    
    
    
    var refreshController = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        searchActive = false
        getUserData()
        friendsList.delegate      =   self
        friendsList.dataSource    =   self
        let cellNib = UINib(nibName: "FriendCell", bundle: nil)
        friendsList.register(cellNib, forCellReuseIdentifier: cellID)
        
        
        self.friendsList.refreshControl = self.refreshController
        self.refreshController.addTarget(self, action: #selector(FriendsVC.didRefreshList), for: .valueChanged)
        fetchFriends()
        self.searchBarSetup()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        searchActive = false
        self.friendsList.reloadData()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.fDB.removeQuery()
        self.uDB.removeQuery()
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
        
        self.friendsData.removeAll()
        self.filterData.removeAll()
        let getFriend = FriendsModel()
        getFriend.yourID = uID
        self.fDB.fetchFriends(friend: getFriend) {
            (result: String) in
            if (result == "DataFetched"){
                
                self.friendsData = self.fDB.passFriendData()
                self.friendsList.reloadData()
            }
        }
        self.friendsList.reloadData()
        
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
       searchActive = false;
        guard let text = searchBar.text  else { return }
        
        
        
        let charset = CharacterSet(charactersIn: "@")
        if (text.rangeOfCharacter(from: charset) != nil) {
            
            
            uDB.findUser(email: text.lowercased()) {
            (result: String) in
                if (result == "FoundUser") {
                    
                    self.userFound()
                    searchBar.text = ""
                    
                }
                else {
                    print("No User Found")
                }
            }
        }
       
            view.endEditing(true)
    
        
        
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
        
        uDB.getUSerData(userID: self.uID)
        {
            (result: String) in
            if (result == "UserData")
            {
                print("User Data found")
                self.userData = self.uDB.passUserData()
                print(self.userData.userID!)
                print(self.userData.first!)
                
            }
            
        }
    }
    func userFound() {
        
        tempUser = uDB.passUserData()
        tempFriend.first = tempUser.first
        tempFriend.last = tempUser.last
        tempFriend.friendID = tempUser.userID
        tempFriend.yourID = userData.userID
        tempFriend.friendProfilePic = tempUser.profilePic
        
                if self.friendsData.contains(where: {$0.friendID == self.tempFriend.friendID}) || (tempFriend.friendID == userData.userID)
                {
                    print("Friend already Exist")
                }
                else {
                    print("Friend can be added")
                    let refreshAlert = UIAlertController(title: "Add Friend", message: "Do you want to send a friend request to \(self.tempFriend.first!) \(self.tempFriend.last!)" , preferredStyle: UIAlertControllerStyle.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                        //Add friend
                        
                        self.fDB.addFriend(friend: self.tempFriend, user: self.userData) {
                            (results: String) in
                            if (results == "FrindAdded")
                            {
                                
                                
                                self.fetchFriends()
                            }
                        }
                        self.searchActive = false
                    }))
                    refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction) in
                        //Do not Add
                        print("Not Added")
                    }))
                    
                    
                    present(refreshAlert, animated: true, completion: nil)
                    
                }
                
        
            
        
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touched")
        self.view.endEditing(true)
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! FriendCell
        var user = FriendsModel()
        
        if (searchActive){
            
            user = filterData[indexPath.row]
            let profilePicUrl = URL(string: user.friendProfilePic!)
            cell.profileImage.kf.setImage(with: profilePicUrl)
            
            //rounding edges of profile picture
            cell.profileImage.layer.cornerRadius = 10
            cell.profileImage.clipsToBounds = true
            if (user.friendID != nil){
            if (user.status == "pending"){
                cell.friendName?.textColor = UIColor.darkGray
                cell.friendName?.text = user.first! + " " + user.last!
                
                cell.status?.text = "Friend Request pending"
                
            } else if ( user.status == "request" ){
                cell.friendName?.textColor = UIColor.magenta
                cell.friendName?.text = user.first! + " " + user.last!
                cell.status?.text = "Requesting Friendship"
                
            } else if (user.status == "friend"){
                
                cell.friendName?.textColor = UIColor.red
                cell.friendName?.text = user.first! + " " + user.last!
                cell.status?.text = "Friend"
            }
            
            
            else {
                cell.tintColor = UIColor.gray
                cell.friendName?.textColor = UIColor.darkGray
                cell.status?.text = "No Friends"
               
            }
            }
        }
        else {
            user = friendsData[indexPath.row]
            let profilePicUrl = URL(string: user.friendProfilePic!)
            cell.profileImage.kf.setImage(with: profilePicUrl)
            
            //rounding edges of profile picture
            cell.profileImage.layer.cornerRadius = 10
            cell.profileImage.clipsToBounds = true
            if (user.status == "pending"){
                cell.friendName?.textColor = UIColor.darkGray
                cell.friendName?.text = user.first! + " " + user.last!
                
                cell.status?.text = "Friend Request pending"
                
            } else if ( user.status == "request" ){
                cell.friendName?.textColor = UIColor.magenta
                cell.friendName?.text = user.first! + " " + user.last!
                cell.status?.text = "Requesting Friendship"
                
            } else if (user.status == "friend"){
                cell.tintColor = UIColor.blue
                cell.friendName?.textColor = UIColor.red
                cell.friendName?.text = user.first! + " " + user.last!
                cell.status?.text = "Friend"
            }
            else {
                cell.tintColor = UIColor.gray
                cell.friendName?.textColor = UIColor.darkGray
                cell.friendName?.text = "No Friends"
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
                self.fDB.friendRequestResponse(userID: self.uID, friendID: user.friendID!, response: "accept") {
                    (results: String) in
                    self.fetchFriends()
                    
                }
                
            }))
            refreshAlert.addAction(UIAlertAction(title: "Decline", style: .default, handler: { (action: UIAlertAction) in
                //Do not Accept
                print("Will not accept")
                self.fDB.friendRequestResponse(userID: self.uID, friendID: user.friendID!, response: "decline") {
                    (results: String) in
                    if (results == "FriendRequestComplete"){
                        self.fetchFriends()
                    }
                    
                }
                self.friendsList.reloadData()
                
                
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
            let refreshAlert = UIAlertController(title: "Remove Friend", message: "Do you want to delete friend?" , preferredStyle: UIAlertControllerStyle.alert)
  
            refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction) in
                //Do not remove
                print("Kept")
            }))
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                //Remove friend
                print("Removed Friend")
                
                self.tempFriend.friendID = user.friendID
                self.tempFriend.yourID = self.uID
                self.fDB.delFriend(friend: self.tempFriend)
                self.fetchFriends()
            }))


            present(refreshAlert, animated: true, completion: nil)
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
   
