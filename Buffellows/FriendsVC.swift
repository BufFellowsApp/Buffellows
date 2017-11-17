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
        
    }
    
    //var friendsList: UITableView = UITableView()
    var filterData = [FriendsModel]()
    var friendsData  = [FriendsModel]()
    var uID : String!
    var searchActive : Bool = false
    let cellID = "cellId"
    let fDB = FriendsDB()
    let uDB = userDB()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        print ("Friends list View Loaded")
        
        uID = "PEgAo0eg7jcTh5SouxNeQodFsA63"
        print ("Fetching Users")

        friendsList.delegate      =   self
        friendsList.dataSource    =   self
        friendsList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //self.view.addSubview(self.friendsList)

        fetchFriends()
        self.searchBarSetup()
        //self.friendsList.frame = CGRe
        
        
        
        
        
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
        let getFriend = FriendsModel()
        getFriend.yourID = uID
        fDB.fetchFriends(friend: getFriend) {
            (result: String) in
            if (result == "DataFetched")
            {
                self.friendsData = self.fDB.passFriendData()
            }
        }
            DispatchQueue.main.async(execute: {
                self.friendsList.reloadData()
        })
            
            //print ("Done Fetching Users")
        
        
        
        
        
        
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
    }

    func searchBarSetup(){
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        searchBar.backgroundImage = UIImage()
        searchBar.barStyle = UIBarStyle.black
        searchBar.delegate = self
        self.friendsList.tableHeaderView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search Bar Text Changed")
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
    func findFriend(email: String){
        uDB.findUser(email: email) {
            (result: String) in
            if (result == "FoundUser"){
                print("Found User")
            }
            
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
   
