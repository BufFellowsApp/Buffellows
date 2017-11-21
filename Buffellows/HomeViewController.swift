//
//  HomeViewController.swift
//  Buffellows
//
//  Created by Ashish Chatterjee on 7/21/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: StandardVC {

    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var age: UILabel!
    
    var uID = "" 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadInfo()
        if (uID != Auth.auth().currentUser?.uid) {
            let loginVC = LoginVC(nibName: "LoginVC", bundle: nil)
            self.navigationController?.pushViewController(loginVC, animated: false)
        }
        // Do any additional setup after loading the view.
    }
    
    func loadInfo() {
        uID = UserDefaults.standard.value(forKey: "uID") as! String
        firstName.text = UserDefaults.standard.value(forKey: "firstName") as? String
        lastName.text = UserDefaults.standard.value(forKey: "lastName") as? String
        username.text = UserDefaults.standard.value(forKey: "username") as? String
        age.text = UserDefaults.standard.value(forKey: "age") as? String
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

}
