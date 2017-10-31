//
//  FriendsVC.swift
//  Buffellows
//
//  Created by Ashish Chatterjee on 10/22/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//

import UIKit
import Firebase


class FriendsVC: StandardVC  {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var uID : String!
    let cellID = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        print ("Friends list View Loaded")
        
        uID = "PEgAo0eg7jcTh5SouxNeQodFsA63"
        print ("Fetching Users")
        fetchUser()
        
        
        
        
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
    func fetchUser() {
        Database.database().reference().child("Users").child(uID).child("friends").observe( .childAdded, with: {(snapshot) in
            print ("Users Found")
            print (snapshot)
            
        })
        
        
        
        
        print ("Done Fetching Users")
    }
    func getUid() -> String {
        return (Auth.auth().currentUser?.uid)!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        // cell selected code here
    }
}
