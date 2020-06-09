//
//  editProfileViewController.swift
//  SmartCampus
//
//  Created by Tomas Chavez on 8/17/19.
//  Copyright © 2019 Tommy Chavez. All rights reserved.
//

import UIKit
import Firebase
import Photos


 var addedPicture: Bool?
var profilePhotoEdit: UIImage?
class editProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {


    

    @IBAction func updateButtonAct(_ sender: Any) {
        if(biographyVar != bioTextLabel.text){
            Database.database().reference().child("users").child(uid!).child("biography").setValue(bioTextLabel.text)
            
        }
        if(addedPicture == true ){
        guard let image = photobutton.imageView?.image else { return }
            profilePhotoEdit = image;
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
                                Database.database().reference().child("users").child(self.uid!).child("ProfileImage").setValue(profileImageUrl)
                               
                             })
              })
                
            
        }
        
        
        
  NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
        
        dismiss(animated: true, completion: nil)
    }
  
    //var addedPicture: Bool?
    var selectedImage: UIImage?
    var originalImage: UIImage?
    var editedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        biotextlabel.returnKeyType = UIReturnKeyType.done
//view.backgroundColor = UIColor.red
        // Do any additional setup after loading the view.
        profilePictureImage.layer.masksToBounds = true
        profilePictureImage.layer.cornerRadius = profilePictureImage.frame.height/2
        if(addedPicture == true){
            profilePictureImage.image = profilePhotoEdit
            
        }
        else {
            
            self.profilePictureImage.loadImageUsingCacheWithUrlString(urlString: myProfilePicture!)
        }
        
        addedPicture = false; //profilePictureImage.loadImageUsingCacheWithUrlString(urlString: myProfilePicture!)
         
       print(profilePictureImage.frame.height)
        print(profilePictureImage.frame.width)
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//                   Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
//                       //print(snapshot.value ?? "")
//                     //  let postid = snapshot.key
//                    let dictionary = snapshot.value as? [String: Any]
//
//                       myProfilePicture = dictionary?[ "ProfileImage"] as? String
//                    self.profilePictureImage.loadImageUsingCacheWithUrlString(urlString: myProfilePicture!)
//
//                           DispatchQueue.main.async {
//                               //self.ProPic.image = image
//                       }
//                   })
        
        
       
      //  profilePictureImage.clipsToBounds = true
        bioTextLabel.textContainer.maximumNumberOfLines = 6
        biotextlabel.textContainer.lineBreakMode = .byTruncatingTail
       loadbiography()
        profilePictureImage.addSubview(click2button); click2button.clipsToBounds = true
        photobutton.layer.cornerRadius = photobutton.frame.height/2
        photobutton.addTarget(self, action: #selector(takeCareOfphoto), for: .touchUpInside)
        
             checkPermission()
        biotextlabel.delegate = self
      
            AppUtility.lockOrientation(.portrait)
      }
          
          override func viewWillDisappear(_ animated: Bool) {
              super.viewWillDisappear(animated)

              // Don't forget to reset when view is being removed
              AppUtility.lockOrientation(.all)
          }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
    @objc func takeCareOfphoto(){
        print("HERE")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            photobutton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photobutton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
photobutton.layer.cornerRadius = photobutton.frame.width/2
       photobutton.layer.masksToBounds = true
       photobutton.layer.borderColor = UIColor.black.cgColor
       photobutton.layer.borderWidth = 3
        
       // dismiss(animated: true, completion: nil)
        //print("HERE BABY");
        addedPicture = true;
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var templabel: UILabel!
    func textViewDidChange(_ textView: UITextView){
    if( biotextlabel.text != ""){
        templabel.isHidden = true
    }
        if( biotextlabel.text == ""){
            templabel.isHidden = false
        }
        
        
    }
    
    
    @IBOutlet weak var biotextlabel: UITextView!
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
    
    
    @IBOutlet weak var photobutton: UIButton!
    @IBOutlet weak var click2button: UILabel!
    var biographyVar = ""
    let uid = Auth.auth().currentUser?.uid
    
    func loadbiography(){
        print(id)
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot.value ?? "")
            //  let postid = snapshot.key
            let dictionary = snapshot.value as? [String: Any]
            print(snapshot.key)
            let biography = dictionary?[ "biography"] as? String
            print(biography)
            
        self.bioTextLabel.text = biography
            self.biographyVar = biography ?? "";
            if(self.biotextlabel.text==""){
                self.templabel.text = "What would you like your bio to be..."
            }
            //biography!

            DispatchQueue.main.async {
                //self.ProPic.image = image
            }
        })
    }
    

    
    @IBOutlet weak var bioTextLabel: UITextView!
    @IBOutlet weak var profilePictureImage: UIImageView!
    
    @IBAction func cancelButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false, completion:nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
