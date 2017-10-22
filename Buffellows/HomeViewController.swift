//
//  HomeViewController.swift
//  Buffellows
//
//  Created by Ashish Chatterjee on 7/21/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//

import UIKit

class HomeViewController: StandardVC {

    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var age: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadInfo()
        
        // Do any additional setup after loading the view.
    }
    
    func loadInfo() {
        firstName.text = UserDefaults.standard.value(forKey: "firstName") as! String
        lastName.text = UserDefaults.standard.value(forKey: "lastName") as! String
        username.text = UserDefaults.standard.value(forKey: "username") as! String
        age.text = UserDefaults.standard.value(forKey: "age") as! String
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
