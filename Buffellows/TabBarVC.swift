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
        let homeTab = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "buffProfIcon"), selectedImage: #imageLiteral(resourceName: "buffaloSelected"))
        homeTab.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        homeVC.tabBarItem = homeTab
        
        let friendsVC = FriendsVC()
        let friendsTab = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "friends"), selectedImage: #imageLiteral(resourceName: "friendsSelected"))
        friendsTab.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        friendsVC.tabBarItem = friendsTab
        
        let exercisesVC = ExercisesVC()
        let exercisesTab = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "exercise"), selectedImage: #imageLiteral(resourceName: "exerciseSelected"))
        exercisesTab.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        exercisesVC.tabBarItem = exercisesTab
        
        self.viewControllers = [homeVC, friendsVC, exercisesVC]
        
        self.tabBar.tintColor = UIColor(displayP3Red: 50/255, green: 0, blue: 0, alpha: 1)
    }
    
    func setupNavBar() {
//        self.navigationController?.navigationBar.barTintColor = UIColor.red
//        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationItem.title = "B U F F E L L O W S"
        self.navigationItem.leftBarButtonItem = nil
        
        let settingsButton = UIButton(type: .system)
        settingsButton.tintColor = UIColor.white
        settingsButton.setImage(#imageLiteral(resourceName: "settings"), for: .normal)
        settingsButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        settingsButton.addTarget(self, action: #selector(goSettings), for: .touchUpInside)
        settingsButton.contentMode = .scaleAspectFit
        let settingsItem = UIBarButtonItem(customView: settingsButton)
        self.navigationItem.leftBarButtonItem = settingsItem
        
        let challengeButton = UIButton(type: .system)
        challengeButton.tintColor = UIColor.white
        challengeButton.setImage(#imageLiteral(resourceName: "exerciseSelected"), for: .normal)
        challengeButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        challengeButton.addTarget(self, action: #selector(goChallengeSetup), for: .touchUpInside)
        challengeButton.contentMode = .scaleAspectFit
        let challengeItem = UIBarButtonItem(customView: challengeButton)
        self.navigationItem.rightBarButtonItem = challengeItem
    }
    
    func goChallengeSetup() {
        print("CLICK CHALLENGE")
        let challengeVC = ChallengeVC(nibName: "ChallengeVC", bundle: nil)
        self.navigationController?.pushViewController(challengeVC, animated: true)
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
