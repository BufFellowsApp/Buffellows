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
    @IBOutlet weak var passimage: UIImageView!
    
    
    @IBOutlet weak var downloadActivity: UIActivityIndicatorView!
    @IBOutlet weak var saveProfilePic: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    let imagePicker = UIImagePickerController()
    var storageRef: StorageReference!
    let uDB = userDB()
    @IBOutlet weak var spinnerAnimate: UIActivityIndicatorView!
    
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
    @IBAction func savePhoto(_ sender: Any){
        let uID = Auth.auth().currentUser?.uid
        let storagePath = "/images/" + uID! + "/profile_image.png"
        downloadActivity.isHidden = false
        downloadActivity.startAnimating()
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
                UserDefaults.standard.set(profilePicUrl, forKey: "profilePicURL")
                UserDefaults.standard.synchronize()
                self.uDB.setProfileURL(uID: uID!, path: profilePicUrl!)
             
                self.downloadActivity.stopAnimating()
                self.downloadActivity.isHidden = true
                

                
            })
        }
    
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
        loadImage()
        setupNavBar()
        storageRef = Storage.storage().reference()
        
        
        password1.addTarget(self, action: #selector(textChanged(textField:)), for: .editingChanged)
        
        
        password2.addTarget(self, action: #selector(textChanged(textField:)), for: .editingChanged)
        
        
        
        changePassword.isEnabled = false
        // Do any additional setup after loading the view.
        
        
        profilePic.layer.cornerRadius = 10
        profilePic.clipsToBounds = true
        profilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImageHandler)))
        imagePicker.delegate = self
        
        
        
    }

    func setupNavBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleSignout))
    }
    
    func loadImage(){

        print("Loading Profile Image")
        
        
        guard let storagePath = UserDefaults.standard.object(forKey: "profilePicURL") as? String else {
            return
        }
        print("---PROFILE PIC STORAGE PATH:  \(storagePath)")
        // [START downloadimage]
        downloadActivity.isHidden = false
        downloadActivity.startAnimating()
        let httpsReference = Storage.storage().reference(forURL: storagePath)
        httpsReference.downloadURL(completion: { (url, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error)
                    return
                }
                guard let imageData = UIImage(data: data!) else { return }
                DispatchQueue.main.async {
                    self.profilePic.image = imageData
                    
                    self.downloadActivity.stopAnimating()
                    self.downloadActivity.isHidden = true
                }
            }).resume()
        })
        // [END downloadimage]
        profilePic.layer.cornerRadius = 10
        profilePic.clipsToBounds = true
        profilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImageHandler)))
        imagePicker.delegate = self
    }
    func handleSignout() {
        
        do {
            try Auth.auth().signOut()
                let loginVC = LoginVC(nibName: "LoginVC", bundle: nil)
                self.navigationController?.pushViewController(loginVC, animated: false)
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
            
        } catch let error as NSError {
            print(error)
            
        }
       
    }
    func profileImageHandler() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
            
        }
    }
    
    //MARK: - Textfield Validation
    func textChanged(textField: UITextField){
        

        if (password1.text == password2.text)  {
            passimage.image = UIImage(named: "good")
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
        self.saveProfilePic.isHidden = false
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
}
