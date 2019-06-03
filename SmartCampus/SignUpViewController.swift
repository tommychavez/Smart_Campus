//
//  SignUpViewController.swift
//  SmartCampus
//
//  Created by Tommy Chavez on 10/29/18.
//  Copyright © 2018 Tommy Chavez. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Photos

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var usernameTextfield: UITextField!
    
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var profImage: UIImageView!
    
    @IBOutlet weak var plusphotobutton: UIButton!
    
    var selectedImage: UIImage?
     var originalImage: UIImage?
    var editedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
           checkPermission()
        let textImage = UIImage( named: "no-image-icon-hi.png")
        plusphotobutton.setImage(textImage ,for: .normal)
         plusphotobutton.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
       
        //profImage.addGestureRecognizer(tapGesture)
        //profImage.isUserInteractionEnabled = true
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func handlePlusPhoto() {
     
        print("123")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            plusphotobutton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            plusphotobutton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        plusphotobutton.layer.cornerRadius = plusphotobutton.frame.width/2
        plusphotobutton.layer.masksToBounds = true
        plusphotobutton.layer.borderColor = UIColor.black.cgColor
        plusphotobutton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
        
        
    
    
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }
    
 
    @IBAction func dismissOnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
  

    @IBAction func signUpBtn_TouchUpinsde(_ sender: Any) {
        guard let email = emailTextfield.text, !email.isEmpty else { return }
        guard let username = usernameTextfield.text, !username.isEmpty else { return }
        guard let password = passwordTextfield.text, !password.isEmpty else { return }
        
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (authResult, error) in
            // ...
            guard let user = authResult?.user else { return }
            
            guard let image = self.plusphotobutton.imageView?.image else { return }
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
              let filename = NSUUID().uuidString
            Storage.storage().reference().child("profile_images")
            let storageRef = Storage.storage().reference().child("profile_images").child(filename)
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                
                if let err = err {
                    print("Failed to upload profile image:", err)
                    return
                }

                storageRef.downloadURL(completion: { (downloadURL, err) in
                    if let err = err {
                        print("Failed to fetch downloadURL:", err)
                        return
                    }
                    
                guard let profileImageUrl = downloadURL?.absoluteString else { return }
                
                print("Successfully uploaded profile image:", profileImageUrl)
                
            
            let ref = Database.database().reference()
            let userReference = ref.child("users")
            //print(usersReference.description())
            let uid = user.uid
            let newUserReference = userReference.child(uid)
            newUserReference.setValue(["username":self.usernameTextfield.text!, "email": self.emailTextfield.text!, "ProfileImage": profileImageUrl])
                })
            })
        }
        
    }
}//close uiviewcontroller

