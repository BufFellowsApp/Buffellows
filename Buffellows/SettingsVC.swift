//
//  SettingsVC.swift
//  Buffellows
//
//  Created by Ashish Chatterjee on 10/22/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        // Do any additional setup after loading the view.
    }

    func setupNavBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleSignout))
    }
    
    func handleSignout() {
        let loginVC = LoginVC(nibName: "LoginVC", bundle: nil)
        self.navigationController?.pushViewController(loginVC, animated: false)
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
