//
//  LoginVC.swift
//  Buffellows
//
//  Created by Ashish Chatterjee on 8/2/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var usernameLogin: UITextField!
    @IBOutlet weak var passwordLogin: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func loginButton(_ sender: UIButton) {
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        self.navigationController?.pushViewController(homeVC, animated: false)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBOutlet weak var registerButton: UIButton!
    @IBAction func registerButton(_ sender: UIButton) {
        let regVC = RegisterVC(nibName: "RegisterVC", bundle: nil)
        self.navigationController?.pushViewController(regVC, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
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
