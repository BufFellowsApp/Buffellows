//
//  RegisterVC.swift
//  Buffellows
//
//  Created by Ashish Chatterjee on 10/10/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//

import UIKit
import Firebase
class RegisterVC: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var usernameReg: UITextField!
    @IBOutlet weak var passwordReg: UITextField!
    @IBOutlet weak var passwordFirstPass: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var age: UITextField!
    
    @IBOutlet weak var spinnerAnimate: UIActivityIndicatorView!
    @IBOutlet weak var passCheck: UIImageView!
    @IBOutlet weak var profilePic: UIImageView!
    let imagePicker = UIImagePickerController()
    
    
    @IBAction func cameraChange(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
            
            
            
        }
        print("Camera push")
    }
    
    @IBAction func libraryChange(_ sender: Any) {
     
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
            
            
            
        }
        print("Library push")
    }
    
    
    let newUser = userDB()
    var storageRef: StorageReference!
    
   
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
        guard let email = usernameReg.text, let password = passwordReg.text, let fName = firstName.text, let lName = lastName.text, let uAge = age.text else{
            print ("form is invalid")
            return
        }
        
        let userData = UserModel()
        userData.email = email
        userData.first = fName
        userData.last = lName
        userData.userAge = uAge
        
        spinnerAnimate.isHidden = false
        spinnerAnimate.startAnimating()
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
            
            if let error = error {
                print(error)
                self.spinnerAnimate.stopAnimating()
                self.spinnerAnimate.isHidden = true
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            userData.userID = uid
            let storagePath = "/images/" + (user?.uid)! + "/profile_image.png"
            if let uploadData = UIImagePNGRepresentation(self.profilePic.image!) {
                self.storageRef.child(storagePath).putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if (error != nil){
                        print(error!)
                        self.spinnerAnimate.stopAnimating()
                        self.spinnerAnimate.isHidden = true
                        return
                        
                    }
                    print("Upload Success")
                    
                    let profilePicUrl = metadata?.downloadURL()?.absoluteString
                    userData.profilePic = profilePicUrl
             
                    self.newUser.addUser(userData: userData) {
                        (result: String) in
                        if (result == "UserAdded")
                        {
                            self.spinnerAnimate.stopAnimating()
                            self.spinnerAnimate.isHidden = true
                            print("User Successfully Added into DataBase")
                            UserDefaults.standard.set(uid, forKey: "uID")
                            UserDefaults.standard.set(true, forKey: "isLoggedIn")
                            UserDefaults.standard.set(profilePicUrl, forKey: "profilePicURL")
                            self.saveInfo()
                    
                            
                            let tabBarVC = TabBarVC()
                            let nc = UINavigationController(rootViewController: tabBarVC)
                            nc.setNavigationBarHidden(false, animated: false)
                            self.present(nc, animated: false, completion: nil)
                    
                    
                        }
                        else {
                            print("Error Error")
                        }
                    }
                })
            }
        })
    }
    
    var backgroundImage = UIImageView()
    var gradientLayer = CAGradientLayer()
    var gradientView = UIView()
    var buffTitle = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        storageRef = Storage.storage().reference()
        backgroundInit()
        textEntryInit(usernameReg, "Username")
        textEntryInit(passwordFirstPass, "Password")
        textEntryInit(passwordReg, "Password")
        textEntryInit(firstName, "First Name")
        textEntryInit(lastName, "Last Name")
        textEntryInit(age, "Age")
        
        usernameReg.delegate = self
        firstName.delegate = self
        lastName.delegate = self
        passwordReg.delegate = self
        age.delegate = self

        passwordFirstPass.addTarget(self, action: #selector(textChanged(textField:)), for: .editingChanged)
        
        
        passwordReg.addTarget(self, action: #selector(textChanged(textField:)), for: .editingChanged)
        
        
        
        registerButton.isEnabled = false
        // Do any additional setup after loading the view.
        
        
        profilePic.layer.cornerRadius = 10
        profilePic.clipsToBounds = true
        profilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImageHandler)))
        
        imagePicker.delegate = self
        
        // Do any additional setup after loading the view.
    }

    func backgroundInit() {
        buffTitle.text = "BUFFELLOWS"
        buffTitle.font = UIFont.systemFont(ofSize: 45, weight: UIFontWeightLight)
        buffTitle.textColor = UIColor.white
        buffTitle.frame = CGRect(x: 0, y: (UIScreen.main.bounds.height/2)-300, width: UIScreen.main.bounds.width, height: 45)
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
        spinnerAnimate.isHidden = true
        
        
        self.view.bringSubview(toFront: firstName)
        self.view.bringSubview(toFront: lastName)
        self.view.bringSubview(toFront: usernameReg)
        self.view.bringSubview(toFront: passwordReg)
        self.view.bringSubview(toFront: passwordFirstPass)
        self.view.bringSubview(toFront: age)
        self.view.bringSubview(toFront: buffTitle)
        
        self.view.bringSubview(toFront: cancelReg)
        self.view.bringSubview(toFront: profilePic)
        self.view.bringSubview(toFront: spinnerAnimate)
        
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
            
            
            //registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
            
            //UserDefaults.standard.set(true, forKey: "isLoggedIn")
            
            //let tabBarVC = TabBarVC()
            //let nc = UINavigationController(rootViewController: tabBarVC)
            //nc.setNavigationBarHidden(false, animated: false)
            //self.present(nc, animated: false, completion: nil)
            handleRegister()
        }
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
    func textChanged(textField: UITextField){
        
 
        if ((passwordFirstPass.text == passwordReg.text) && (!(passwordReg.text?.isEmpty)! || !(passwordFirstPass.text?.isEmpty)!)) {
            passCheck.image = UIImage(named: "good")
            self.view.bringSubview(toFront: passCheck)
            self.view.bringSubview(toFront: registerButton)
            registerButton.isEnabled = true
        } else {
            
            passCheck.image = UIImage(named: "notGood")
            registerButton.isEnabled = false
            
        }
    }
    
    func profileImageHandler() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //
        
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        if let originalImage = info[UIImagePickerControllerOriginalImage]  {
            print("-----------Origin IMAGE INFO---------------")
            print(originalImage)
        }
        // use the image
        profilePic.image = editedImage
        
        print("-----------Chosen IMAGE INFO---------------")
        print(info)
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }

}
