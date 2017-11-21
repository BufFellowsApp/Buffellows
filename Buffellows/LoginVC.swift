//
//  LoginVC.swift
//  Buffellows
//
//  Created by Ashish Chatterjee on 8/2/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameLogin: UITextField!
    @IBOutlet weak var passwordLogin: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func loginButton(_ sender: UIButton) {
        handleLoginCondition()
    }
    
    @IBOutlet weak var registerButton: UIButton!
    @IBAction func registerButton(_ sender: UIButton) {
        let regVC = RegisterVC(nibName: "RegisterVC", bundle: nil)
        self.navigationController?.pushViewController(regVC, animated: false)
    }
    
    var backgroundImage = UIImageView()
    var gradientLayer = CAGradientLayer()
    var gradientView = UIView()
    var buffTitle = UILabel()
    let msg = UILabel()
    var tapScreen = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        backgroundInit()
        textEntryInit()
        loginButtonInit()
        
       //let ref = Database.database().reference(fromURL: "https://buffellows-cc410.firebaseio.com/")
        
     // ref.updateChildValues(["someValue": 123123])
        
        usernameLogin.delegate = self
        passwordLogin.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func loginButtonInit() {
//        loginButton.layer.borderColor = UIColor.white.cgColor
//        loginButton.layer.borderWidth = 0.5
        loginButton.layer.cornerRadius = 10
    }
    
    func backgroundInit() {
        usernameLogin.alpha = 0.0
        passwordLogin.alpha = 0.0
        loginButton.alpha = 0.0
        registerButton.alpha = 0.0
        
        buffTitle.text = "BUFFELLOWS"
        buffTitle.font = UIFont.systemFont(ofSize: 45, weight: UIFontWeightLight)
        buffTitle.textColor = UIColor.white
        buffTitle.frame = CGRect(x: 0, y: (UIScreen.main.bounds.height/2)-22.5, width: UIScreen.main.bounds.width, height: 45)
        buffTitle.textAlignment = .center
        self.view.addSubview(buffTitle)
        
        msg.text = "Tap anywhere to begin!"
        msg.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightUltraLight)
        msg.textColor = UIColor.white.withAlphaComponent(0.5)
        msg.frame = CGRect(x: 0, y: (UIScreen.main.bounds.height)-25, width: UIScreen.main.bounds.width, height: 17)
        msg.textAlignment = .center
        self.view.addSubview(msg)
        
        tapScreen.frame = UIScreen.main.bounds
        tapScreen.backgroundColor = UIColor.clear
        tapScreen.addTarget(self, action: #selector(self.loginInitiated(_:)), for: .touchUpInside)
        self.view.addSubview(tapScreen)
        
        self.view.backgroundColor = UIColor.black
        backgroundImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        backgroundImage.image = #imageLiteral(resourceName: "login-background")
        backgroundImage.contentMode = .scaleAspectFill
        
        let topColor = UIColor(red: 50/255, green: 0/255, blue: 0/255, alpha: 0.6)
        let bottomColor = UIColor(red: 50/255, green: 0/255, blue: 0/255, alpha: 0.9)
        gradientView.frame = UIScreen.main.bounds
        gradientLayer.frame = UIScreen.main.bounds
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientView.layer.addSublayer(gradientLayer)
        self.view.addSubview(gradientView)
        self.view.sendSubview(toBack: gradientView)
        
        self.view.addSubview(backgroundImage)
        self.view.sendSubview(toBack: backgroundImage)
    }
    
    func loginInitiated(_ button: UIButton) {
        tapScreen.isHidden = true
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        blurEffectView.alpha = 0.0
        
        UIView.animate(withDuration: 0.5) {
            self.msg.alpha = 0.0
            blurEffectView.alpha = 0.5
            self.buffTitle.frame = CGRect(x: 0, y: (UIScreen.main.bounds.height/2)-200, width: UIScreen.main.bounds.width, height: 45)
            self.usernameLogin.alpha = 1.0
            self.passwordLogin.alpha = 1.0
            self.loginButton.alpha = 1.0
            self.registerButton.alpha = 1.0
        }
        
        self.view.bringSubview(toFront: usernameLogin)
        self.view.bringSubview(toFront: passwordLogin)
        self.view.bringSubview(toFront: loginButton)
        self.view.bringSubview(toFront: registerButton)
        self.view.bringSubview(toFront: buffTitle)
    }
    
    func textEntryInit() {
        usernameLogin.backgroundColor = UIColor.clear
        usernameLogin.textColor = UIColor.white
        usernameLogin.textAlignment = .center
        usernameLogin.borderStyle = .none
        usernameLogin.tintColor = UIColor.white
        usernameLogin.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.7)])
        
        passwordLogin.backgroundColor = UIColor.clear
        passwordLogin.textColor = UIColor.white
        passwordLogin.textAlignment = .center
        passwordLogin.borderStyle = .none
        passwordLogin.tintColor = UIColor.white
        passwordLogin.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.7)])
    }
    
    func handleLoginCondition() {
        if (usernameLogin.text == "admin" || passwordLogin.text == "password") {
            let tabBarVC = TabBarVC()
            UserDefaults.standard.set("admin", forKey: "username")
            UserDefaults.standard.set("password", forKey: "password")
            UserDefaults.standard.set("fName", forKey: "firstName")
            UserDefaults.standard.set("lName", forKey: "lastName")
            UserDefaults.standard.set("userAge", forKey: "age")
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.synchronize()
            
            let nc = UINavigationController(rootViewController: tabBarVC)
            nc.setNavigationBarHidden(false, animated: false)
            
            self.present(nc, animated: false, completion: nil)
            
        } else if ((usernameLogin.text?.isEmpty)! || (passwordLogin.text?.isEmpty)!) {
            let alert = UIAlertController(title: "Login Error", message: "Please enter a username / password", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            Auth.auth().signIn(withEmail: usernameLogin.text!, password: passwordLogin.text!) { (user,error) in
                if error != nil {
                    let alert = UIAlertController(title: "Login Error", message: "\(error!)", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    print(error!)
                    
                }
                else if (user != nil) {
                    let tabBarVC = TabBarVC()
                    let uDB = userDB()
                    uDB.getUSerData(userID: (user?.uid)!){
                        (results:String) in
                        if results == "UserData" {
                            let userLogin = uDB.passUserData()
                            let nc = UINavigationController(rootViewController: tabBarVC)
                            nc.setNavigationBarHidden(false, animated: false)
                            self.present(nc, animated: false, completion: nil)
                            UserDefaults.standard.set(self.usernameLogin.text!, forKey: "username")
                            UserDefaults.standard.set(self.passwordLogin.text!, forKey: "password")
                            UserDefaults.standard.set(user?.uid, forKey: "uID")
                            UserDefaults.standard.set(userLogin.first, forKey: "firstName")
                            UserDefaults.standard.set(userLogin.last, forKey: "lastName")
                            UserDefaults.standard.set(userLogin.userAge, forKey: "age")
                            UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        }
                    }
                }
            }
        }
    }
    /*
     let tabBarVC = TabBarVC()
     let nc = UINavigationController(rootViewController: tabBarVC)
     nc.setNavigationBarHidden(false, animated: false)
     self.present(nc, animated: false, completion: nil)
 */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.barTintColor = UIColor.red
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
