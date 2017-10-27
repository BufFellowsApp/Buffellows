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
        
        saveInfo()
        
        let tabBarVC = TabBarVC(nibName: "TabBarVC", bundle: nil)
        self.navigationController?.pushViewController(tabBarVC, animated: false)
        self.navigationController?.navigationBar.isHidden = false
        handleRegister()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameReg.delegate = self
        firstName.delegate = self
        lastName.delegate = self
        passwordReg.delegate = self
        age.delegate = self

        // Do any additional setup after loading the view.
    }
    
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
