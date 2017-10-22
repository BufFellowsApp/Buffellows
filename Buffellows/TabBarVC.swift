//
//  TabBarVC.swift
//  Buffellows
//
//  Created by Ashish Chatterjee on 10/22/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        setupNavBar()
        
        self.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        
        setupTabBar()
    }
    
    func setupTabBar() {
        
        let homeVC = HomeViewController()
        let homeTab = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "buffProfIcon"), selectedImage: #imageLiteral(resourceName: "buffaloSelected"))
        homeVC.tabBarItem = homeTab
        
        let friendsVC = FriendsVC()
        let friendsTab = UITabBarItem(title: "Friends", image: #imageLiteral(resourceName: "friends"), selectedImage: #imageLiteral(resourceName: "friendsSelected"))
        friendsVC.tabBarItem = friendsTab
        
        let exercisesVC = ExercisesVC()
        let exercisesTab = UITabBarItem(title: "Exercises", image: #imageLiteral(resourceName: "exercise"), selectedImage: #imageLiteral(resourceName: "exerciseSelected"))
        exercisesVC.tabBarItem = exercisesTab
        
        self.viewControllers = [homeVC, friendsVC, exercisesVC]
    }
    
    func setupNavBar() {
//        self.navigationController?.navigationBar.barTintColor = UIColor.red
//        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationItem.title = "B U F F E L L O W S"
        self.navigationItem.leftBarButtonItem = nil
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 25, weight: UIFontWeightThin)]
        
        let settingsButton = UIButton(type: .system)
        settingsButton.setImage(#imageLiteral(resourceName: "settings"), for: .normal)
        settingsButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        settingsButton.addTarget(self, action: #selector(goSettings), for: .touchUpInside)
        settingsButton.contentMode = .scaleAspectFit
        let settingsItem = UIBarButtonItem(customView: settingsButton)
        self.navigationItem.leftBarButtonItem = settingsItem
    }
    
    func goSettings() {
        print("CLICKED SETTINGS")
        let settingsVC = SettingsVC(nibName: "SettingsVC", bundle: nil)
        self.navigationController?.pushViewController(settingsVC, animated: true)
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
