//
//  PostPopUpViewController.swift
//  SmartCampus
//
//  Created by Tommy Chavez on 1/16/19.
//  Copyright © 2019 Tommy Chavez. All rights reserved.
//

import UIKit
import Photos
import Firebase


class PostPopUpViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate  {
    var photo = false
    
    let locations = ["ATM Machines", "Charles W. Davidson Building","CVB","Martin Luther King Jr Library","San Jose State University (default)","SPARQ"]
    var location: String?
    
    var chosenLocation = "San Jose State University"
    // var locationSet: Bool?
    let dropdownviewcontroller = DropDownViewController()
  
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var textcount: UILabel!
    
    
    @IBOutlet weak var dropDownTable: UITableView!
    @IBOutlet weak var dropdowntableHC: NSLayoutConstraint!
    
    @IBOutlet weak var AddLocation: UIButton!
   
    var textCount = 0
    
    
    
    @IBOutlet weak var postPhoto: UIButton!
    
    @IBOutlet weak var postButton: UIButton!
    
    var pickedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermission()
        postPhoto.setTitle("Add Photo", for: .normal)
        postPhoto.addTarget(self, action: #selector(handlePlusPhoto2), for: .touchUpInside)
        postButton.addTarget(self, action: #selector(handlePost), for: .touchUpInside)
        // print(location)
        dropDownTable.delegate = self
        dropDownTable.dataSource = self
        dropdowntableHC.constant = 0
       textView.delegate = self
    // textcount.text = "(\textCount)/280"
       textcount.font = .systemFont(ofSize: 8)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholdertext.text = ""
        // Run code here for when user begins type into the text view
        
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        textCount = numberOfChars
        textcount.text = "\(numberOfChars) /280"
        return numberOfChars < 280    // 10 Limit Value
    }


    @IBOutlet weak var placeholdertext: UILabel!
    
    
    @IBAction func TouchLocationButton(_ sender: Any) {
     
        UIView.animate(withDuration: 0.5) {
                   self.dropdowntableHC.constant = 128
                   self.view.layoutIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "chooseLocation")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "chooseLocation")
            
        }
        cell?.textLabel?.text = self.locations[ indexPath.row]
        return cell!
    }
    
    
    @IBOutlet weak var LocationButtonOut: UIButton!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenLocation = locations[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        UIView.animate(withDuration: 0.5) {
            self.dropdowntableHC.constant = 0
            self.view.layoutIfNeeded()
        }
        
        LocationButtonOut.setTitle(chosenLocation,
            for: .normal)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    @objc func handlePlusPhoto2() {
        //print("tap")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        //print("tap")
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage { pickedImage = editedImage
            
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            pickedImage = originalImage
        }
        photo = true
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func handlePost() {
        print("post")
        if(photo == false) {
            saveToDatabaseWithNoMedia()
        }
        else {
        guard let caption = textView.text, !caption.isEmpty else { return }
        
        // guard let locationText = locationTextField.text, !locationText.isEmpty else { return }
        let locationText = chosenLocation
        guard let image = pickedImage else { return }
        print(caption)
       
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else { return }
        
        
        let filename = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("posts").child(filename)
        //let storageRef = Storage.storage().reference().child("posts")
        storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
            
            if let err = err {
                print("Failed to upload post image:", err)
                return
            }
            
            storageRef.downloadURL(completion: { (downloadURL, err) in
                if let err = err {
                    print("Failed to fetch downloadURL:", err)
                    return
                }
                guard let imageUrl = downloadURL?.absoluteString else { return }
                
                print("Successfully uploaded post image:", imageUrl)
                
                self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
            })
            }
        }
    }
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
        guard let postImage = pickedImage else { return }
        guard let caption = textView.text else { return }
        // guard let locationText = locationTextField.text, !locationText.isEmpty else { return }
        let locationText = chosenLocation
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        
        
        
        
        print(caption)
        // guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // let userPostRef = Database.database().reference().child("posts").child(uid)
        let userPostRef = Database.database().reference().child("posts")
        //let ref = userPostRef
        let ref = userPostRef.childByAutoId()
        
        
        let values = ["imageUrl": imageUrl, "caption": caption,
                      "location": locationText,"imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "usersName": uid, "creationDate": Date().timeIntervalSince1970, "numberoflikes":0,"likes": "", "charactercount": textCount ] as [String : Any]
        
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to DB", err)
                return
            }
            
             //ref.child("likes").updateChildValues(["123": "like"])
             // ref.child("likes").updateChildValues(["124": "like"])
            
            
            
            print("Successfully saved post to DB")
         //   self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    fileprivate func saveToDatabaseWithNoMedia() {
        //guard let postImage = pickedImage else { return }
        guard let caption = textView.text else { return }
        // guard let locationText = locationTextField.text, !locationText.isEmpty else { return }
        let locationText = chosenLocation
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        print(caption)
        
        let userPostRef = Database.database().reference().child("posts")
        let ref = userPostRef.childByAutoId()
        
        let values = ["imageUrl": "noImage", "caption": caption,
                      "location": locationText,"imageWidth": 0, "imageHeight": 0, "usersName": uid, "creationDate": Date().timeIntervalSince1970, "numberoflikes":0,"likes": "", "charactercount": textCount] as [String : Any]
        
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to DB", err)
                return
            }
            
            print("Successfully saved post to DB")
//            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
//    @IBAction func CancelAction(_ sender: Any) {
//         self.dismiss(animated: true, completion: nil)
//    }
//    
    
    
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
}






