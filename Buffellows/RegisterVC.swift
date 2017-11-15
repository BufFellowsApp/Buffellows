//
//  RegisterVC.swift
//  Buffellows
//
//  Created by Ashish Chatterjee on 10/10/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//

import UIKit
import Firebase
class RegisterVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameReg: UITextField!
    @IBOutlet weak var passwordReg: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var age: UITextField!
    
    var username: String!
    var password: String!
    var fName: String!
    var lName: String!
    var userAge: String!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBAction func registerButton(_ sender: UIButton) {
        handleRegisteringCondition()
    }
    
    @IBOutlet weak var cancelReg: UIButton!
    @IBAction func cancelReg(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    func saveInfo() {
        username = usernameReg.text
        password = passwordReg.text
        fName = firstName.text
        lName = lastName.text
        userAge = age.text
        
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.set(fName, forKey: "firstName")
        UserDefaults.standard.set(lName, forKey: "lastName")
        UserDefaults.standard.set(userAge, forKey: "age")
        UserDefaults.standard.synchronize()
        
    }
     func handleRegister(){
        guard let email = usernameReg.text, let password = passwordReg.text else{
            print ("form is invalid")
            return
        }
        
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            //successfully authenticated user Still need to convert this to the userDB.swift calls.
            let ref = Database.database().reference()
            let usersReference = ref.child("Users").child(uid)
            let values = ["name": self.firstName.text!, "email": email]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if let err = err {
                    print(err)
                    return
                }
                
                print("Saved user successfully into Firebase db")
                
            })
            
        })
    }
    
    var backgroundImage = UIImageView()
    var gradientLayer = CAGradientLayer()
    var gradientView = UIView()
    var buffTitle = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        backgroundInit()
        textEntryInit(usernameReg, "Username")
        textEntryInit(passwordReg, "Password")
        textEntryInit(firstName, "First Name")
        textEntryInit(lastName, "Last Name")
        textEntryInit(age, "Age")
        
        usernameReg.delegate = self
        firstName.delegate = self
        lastName.delegate = self
        passwordReg.delegate = self
        age.delegate = self

        // Do any additional setup after loading the view.
    }

    func backgroundInit() {
        buffTitle.text = "BUFFELLOWS"
        buffTitle.font = UIFont.systemFont(ofSize: 45, weight: UIFontWeightLight)
        buffTitle.textColor = UIColor.white
        buffTitle.frame = CGRect(x: 0, y: (UIScreen.main.bounds.height/2)-250, width: UIScreen.main.bounds.width, height: 45)
        buffTitle.textAlignment = .center
        self.view.addSubview(buffTitle)
        
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
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        blurEffectView.alpha = 0.5
        
        registerButton.layer.cornerRadius = 10
        
        self.view.bringSubview(toFront: firstName)
        self.view.bringSubview(toFront: lastName)
        self.view.bringSubview(toFront: usernameReg)
        self.view.bringSubview(toFront: passwordReg)
        self.view.bringSubview(toFront: age)
        self.view.bringSubview(toFront: buffTitle)
        self.view.bringSubview(toFront: registerButton)
        self.view.bringSubview(toFront: cancelReg)
    }
    
    func textEntryInit(_ textfield: UITextField, _ placeholder: String) {
        textfield.backgroundColor = UIColor.clear
        textfield.textColor = UIColor.white
        textfield.textAlignment = .center
        textfield.borderStyle = .none
        textfield.tintColor = UIColor.white
        textfield.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.7)])
    }
    
    func handleRegisteringCondition() {
        if ((usernameReg.text?.isEmpty)! || (firstName.text?.isEmpty)! || (lastName.text?.isEmpty)! ||  (passwordReg.text?.isEmpty)! ||  (age.text?.isEmpty)!) {
            let alert = UIAlertController(title: "Registration Error", message: "Please make sure you fill out all the information.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            saveInfo()
            
            registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
            
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            
            let tabBarVC = TabBarVC()
            let nc = UINavigationController(rootViewController: tabBarVC)
            nc.setNavigationBarHidden(false, animated: false)
            self.present(nc, animated: false, completion: nil)
            handleRegister()
        }
    }
    
    
//  func handleRegister() //ADD DATABASE CALLS FOR REGISTER
//    {
//        guard let email = usernameReg.text, let password = passwordReg.text else{
//            print ("form is invalid")
//            return
//        }
//
//        Auth.createUser(withEmail: email, password: password, completion:  (user: User, error), in
//            //if error != nil{
//            //    print(error)
//              //  return
//          //  }
//
//
//        let ref = Database.database().reference(fromURL: "https://buffellows-cc410.firebaseio.com/")
//
//        ref.updateChildValues(["someValue": 123123])
//
//
//
//    
//    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
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
