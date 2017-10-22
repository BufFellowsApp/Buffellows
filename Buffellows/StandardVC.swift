//
//  StandardVC.swift
//  Buffellows
//
//  Created by Ashish Chatterjee on 8/2/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//

import UIKit

class StandardVC: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "B U F F E L L O W S"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightThin)]
        
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
