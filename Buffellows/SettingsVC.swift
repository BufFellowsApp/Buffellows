//
//  SettingsVC.swift
//  Buffellows
//
//  Created by Ashish Chatterjee on 10/22/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    
    
    @IBOutlet weak var password1: UITextField!
    @IBOutlet weak var password2: UITextField!
    @IBOutlet weak var changePassword: UIButton!
    @IBOutlet weak var pass2image: UIImageView!
    @IBOutlet weak var pass1image: UIImageView!
    
    @IBOutlet weak var profilePic: UIImageView!
    let imagePicker = UIImagePickerController()

    @IBAction func openCameraButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            
            
            
            
        }
        print("Button Clicked")
    }
    
    @IBAction func openPhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            
            
            
            
        }
        print("Button Clicked")
    }
    @IBAction func changePassword(_ sender: Any) {
   
            
                // [START change_password]
            Auth.auth().currentUser?.updatePassword(to: password1.text!) { (error) in
                    // [START_EXCLUDE]
                
                
                    // [END_EXCLUDE]
                }
                // [END change_password]
        
    
            print("Password Changed")
            
    
            
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        
        
        password1.addTarget(self, action: #selector(textChanged(textField:)), for: .editingChanged)
        
        
        password2.addTarget(self, action: #selector(textChanged(textField:)), for: .editingChanged)
        
        
        
        changePassword.isEnabled = false
        // Do any additional setup after loading the view.
        

        profilePic.layer.cornerRadius = 10
        profilePic.clipsToBounds = true
        
        imagePicker.delegate = self
        
        
        
    }

    func setupNavBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleSignout))
    }
    
    func handleSignout() {
        let loginVC = LoginVC(nibName: "LoginVC", bundle: nil)
        self.navigationController?.pushViewController(loginVC, animated: false)
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
    
    //MARK: - Textfield Validation
    func textChanged(textField: UITextField){
        let passwrd = password1.text
        if (isPasswordValid(passwrd!)){
            pass1image.image = UIImage(named: "exerciseSelected")
        }
        if (password1.text == password2.text)  {
            pass2image.image = UIImage(named: "exerciseSelected")
            changePassword.isEnabled = true
        } else {
            changePassword.isEnabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Password
    

   
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}")
        return passwordTest.evaluate(with: password)
    }
    
    // MARK: - Picked Image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // use the image
        profilePic.image = chosenImage
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
