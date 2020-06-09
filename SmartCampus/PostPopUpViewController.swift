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
    var audioString = "noaudio"
    var songurl = "" {
        didSet{
            
            //littlePreview.image = UIImage(named: "music")
            cancelButton.isHidden = false
            cancelButton.isEnabled  = true
            print("songurl:")
            let fileManager = FileManager.default
            print(songurl)
            let url =  URL(string: songurl)
            let filePath = url?.path
            if(FileManager.default.fileExists(atPath: (url?.path)!)){  // just use String when you have to check for existence of your file
                print("nsdata exists");
                let result = NSData(contentsOf: url!);
                print(result?.length)
                let stringForm = result?.base64EncodedString(options: []) //https://stackoverflow.com/questions/25923567/nsdata-on-firebase
                audioString = "noaudio"
                audioString = (result?.base64EncodedString(options: []))! //https://stackoverflow.com/questions/25923567/nsdata-on-firebase
                //
             //  littlePreview.image = UIImage(data: result as! Data, scale: 1.0)
               // print(audioString[0..<3])
                littlePreview.image = UIImage(named: "music")

            }
        }
    }
    var global = true
    @IBOutlet weak var globe: UIButton!
    @IBAction func pressglob(_ sender: Any) {
        if(global == true){
        globe.setImage(UIImage(named: "lock"), for: .normal
        )
            global = false
        }
        else{
            globe.setImage(UIImage(named: "earth"), for: .normal
            )
           global = true
        }
        
    }
    
    
    
    
    
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var littlePreview: UIImageView!
    let locations = ["Art Building","Book Store","Business Center","CEFCU Stadium","Dorms","Engineering Building", "Downtown San Jose","Event Center","Greek Life","Health Center","Housing","MLK Jr Library","Music Building", "Parking","San Jose State University","Science Building","SRAC", "Student Union"]
    let medialist = ["Add Photo","Add Video","Add Music"]
    
    var location: String?
    
    @IBAction func cancelbuttonaction(_ sender: Any) {
         textView.text = ""
        textCount = 0
        textcount.text = "\(textCount) /280"

        self.tabBarController!.selectedIndex = selectedIndex ?? 0
        
        //https://stackoverflow.com/questions/5413538/switching-to-a-tabbar-tab-view-programmatically
       //cancel post button
    
    }
    
    func cancelact(){
        self.presentingViewController?.dismiss(animated: false, completion:nil)
    }
    

    
    
    @IBAction func cancelpicturebutton(_ sender: Any) {
        if(cancelButton.isHidden == false ){
            photo = false
            littlePreview.image = UIImage(named: "whitesquare")
            cancelButton.isHidden = true
        }
    }
    
    var chosenLocation = "San Jose State University"
    // var locationSet: Bool?
    var chosenMedia = ""
    let dropdownviewcontroller = DropDownViewController()
  
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var textcount: UILabel!
    
    
    @IBOutlet weak var dropDownTable: UITableView!
    @IBOutlet weak var dropdowntableHC: NSLayoutConstraint!
    
    @IBOutlet weak var mediadropDownTable: UITableView!
    @IBOutlet weak var mediadropdowntableHC: NSLayoutConstraint!
    @IBOutlet weak var AddLocation: UIButton!
   
    var textCount = 0
    
    @IBAction func unwindToOne(segue: UIStoryboardSegue) {
     self.tabBarController!.selectedIndex = selectedIndex ?? 0
    }
    
    @IBOutlet weak var postPhoto: UIButton!
    
    @IBOutlet weak var postButton: UIButton!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        postButton.isEnabled = true;
        super.viewWillAppear(animated)
        textView.text = "";
        textCount = 0
           textcount.text = "\(textCount) /280"
        globe.setImage(UIImage(named: "earth"), for: .normal)
        global = true
        photo = false
        littlePreview.image = UIImage(named: "whitesquare")
        cancelButton.isHidden = true
        LocationButtonOut.titleLabel?.text = ""
        chosenLocation = "San Jose State University"

        
            
        textView.becomeFirstResponder()
        //view.addBackground()
    
    }
    
    @IBAction func unwindToHomeController( sender: UIStoryboardSegue){
         self.tabBarController!.selectedIndex = selectedIndex ?? 0
        
       }
    var pickedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        postButton.isEnabled = true
        textView.becomeFirstResponder()
        textView.font = .systemFont(ofSize: 19.25)
        //view.addBackground()
        print("Song Url")
         textView.returnKeyType = UIReturnKeyType.done
        //print(songurl)
        setupcancelbutton()
//        self.view.backgroundColor = UIColor(patternImage: backgroundimage101!)
//        self.view.backgroundColor = UIColor(patternImage: backgroundimage101!)
    
        checkPermission()
       
        postButton.addTarget(self, action: #selector(handlePost), for: .touchUpInside)
        // print(location)
        dropDownTable.delegate = self
        dropDownTable.dataSource = self
        dropDownTable.layer.borderWidth = 2.0
        dropdowntableHC.constant = 0
        view.bringSubviewToFront(dropDownTable)
        mediadropDownTable.delegate = self
        mediadropDownTable.dataSource = self
         mediadropDownTable.layer.borderWidth = 2.0
        mediadropdowntableHC.constant = 0
    
       textView.delegate = self
    // textcount.text = "(\textCount)/280"
       textcount.font = .systemFont(ofSize: 8)
        
       

              AppUtility.lockOrientation(.portrait)
    }
            
            override func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)

                // Don't forget to reset when view is being removed
                AppUtility.lockOrientation(.all)
            }
    
    func setupcancelbutton(){
    cancelButton.layer.cornerRadius = 0.5 * cancelButton.bounds.size.width
    cancelButton.layer.borderWidth = 1
    cancelButton.layer.borderColor = UIColor.red.cgColor
    cancelButton.isHidden = true
        cancelButton.isEnabled  = false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textCount > 0){
        placeholdertext.text = ""
        }
        // Run code here for when user begins type into the text view
        
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
            if (text == "\n") {
                handlePost()
            }
            
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        textCount = numberOfChars
        textcount.text = "\(numberOfChars) /280"
        if(textCount > 0){
            placeholdertext.text = ""
        }
        return numberOfChars < 280    // 10 Limit Value
    }


    @IBOutlet weak var placeholdertext: UILabel!
    
    @IBAction func TouchMediaButton(_ sender: Any) {
         handlePlusPhoto2()
//        if( self.mediadropdowntableHC.constant == 128){
//            print("IN HERE")
//           UIView.animate(withDuration: 0.5) {
//                self.mediadropdowntableHC.constant = 0
//                self.view.layoutIfNeeded()
//            }
//
//        }
//
//        else{
//            UIView.animate(withDuration: 0.5) {
//            self.mediadropdowntableHC.constant = 128
//            self.view.layoutIfNeeded()
//        }
//        }
        

    }
    
    @IBAction func TouchLocationButton(_ sender: Any) {
     
        if( self.dropdowntableHC.constant == 128){
            print("IN HERE")
            UIView.animate(withDuration: 0.5) {
                self.dropdowntableHC.constant = 0
                self.view.layoutIfNeeded()
            }
            
        }
        else {
        UIView.animate(withDuration: 0.5) {
                   self.dropdowntableHC.constant = 128
                   self.view.layoutIfNeeded()
        }
    }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
        if(tableView == dropDownTable){
        return locations.count
        }
        
        if(tableView == mediadropDownTable){
            return medialist.count
        }
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "chooseLocation")
        if(tableView == dropDownTable){
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "chooseLocation")
            
        }
        cell?.textLabel?.text = self.locations[ indexPath.row]
            cell?.textLabel?.numberOfLines = 0;
            cell?.textLabel?.lineBreakMode = .byWordWrapping
            cell?.textLabel?.font = .systemFont(ofSize: 9)
        }
        if(tableView == mediadropDownTable){
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "chooseLocation")
                
            }
             cell?.textLabel?.adjustsFontSizeToFitWidth = true
            cell?.textLabel?.text = self.medialist[ indexPath.row]
        }
        
        
        
        return cell!
    }
    
    
    @IBOutlet weak var LocationButtonOut: UIButton!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == dropDownTable){
        chosenLocation = locations[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        UIView.animate(withDuration: 0.5) {
            self.dropdowntableHC.constant = 0
            self.view.layoutIfNeeded()
        }
        
        LocationButtonOut.setTitle(chosenLocation,
            for: .normal)
        }
        
        if(tableView == mediadropDownTable){
            if(indexPath.row == 0){
                handlePlusPhoto2()
            }
            chosenMedia = medialist[indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
            
            UIView.animate(withDuration: 0.5) {
                self.mediadropdowntableHC.constant = 0
                self.view.layoutIfNeeded()
            }
            
            //postButton.setTitle(chosenMedia,
                        //               for: //.normal)
        }
        
        if(indexPath.row == 2){
            print("HERE")
            let vc = viewfilecontroller()
            self.navigationController?.pushViewController(vc, animated: true)
           // handlePlusPhoto2()
        }
        
        
    }
    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        view.endEditing(true)
//    }
    //touch anywhere exit
    
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
            littlePreview.image = editedImage
            cancelButton.isHidden = false
            cancelButton.isEnabled  = true
            
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            pickedImage = originalImage
             littlePreview.image = originalImage
            cancelButton.isHidden = false
            cancelButton.isEnabled  = true
        }
        photo = true
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func handlePost() {
            postButton.isEnabled = false
            print("post")
            if(audioString != "noaudio"){
              handleAudio()
            }
            
           else if(photo == false) {
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
        
        func handleAudio(){
            guard let caption = textView.text else { return }
            // guard let locationText = locationTextField.text, !locationText.isEmpty else { return }
            let locationText = chosenLocation
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            print(caption)
        
            let userPostRef = Database.database().reference().child("posts")
            //let ref = userPostRef
            let ref = userPostRef.childByAutoId()
         
            
            let values = ["imageUrl": "noImage", "caption": caption,
                          "location": locationText,"imageWidth": 0, "imageHeight": 0, "usersName": uid, "creationDate": Date().timeIntervalSince1970, "numberoflikes":0,"likes": "", "charactercount": textCount, "Audio64": audioString,"Global": global, "postorevent": "post" , "EndDateString": "","StartTimeString": ""] as [String : Any]
            
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
            
            let userPost = Database.database().reference().child("users").child(uid).child("ownposts").child(ref.key!)
            let uservalues = ["postid": ref.key!, "global": global] as [String : Any]
            userPost.updateChildValues(uservalues)
            
            let userPostloc = Database.database().reference().child("LocationPosts").child(locationText).child(ref.key!)
            let uservaluesloc = ["postid": ref.key!, "global": global, "userid":uid] as [String : Any]
                       userPostloc.updateChildValues(uservaluesloc)
            
            for item in friendsList {
                      let friendPost = Database.database().reference().child("users").child(item).child("friendposts").child(ref.key!)
                      let uservalues = ["postid": ref.key!] as [String : Any]
                      friendPost.updateChildValues(uservalues)
                      
                  }
            
            self.tabBarController!.selectedIndex = selectedIndex ?? 0
            
            
        
        }
        
        fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
            guard let postImage = pickedImage else { return }
            guard let caption = textView.text else { return }
            // guard let locationText = locationTextField.text, !locationText.isEmpty else { return }
            let locationText = chosenLocation
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
        
             //let spaceCount = caption.filter{$0 == " "}.count
            
            
            print(caption)
            // guard let uid = Auth.auth().currentUser?.uid else { return }
            
            // let userPostRef = Database.database().reference().child("posts").child(uid)
            let userPostRef = Database.database().reference().child("posts")
            //let ref = userPostRef

            let commentPostRef = Database.database().reference().child("comments")
            // let ref = userPostRef.childByAutoId()
            let new_date = Int(Date().timeIntervalSince1970 * 100000.0)
            
            //let ref = userPostRef.child(String(new_date))
            let ref = userPostRef.childByAutoId()
           // let newref = commentPostRef.child(String(new_date))
            let newref = commentPostRef.child(ref.key!)
            print()
            
            
            let newvalues = ["commentnum": 0, "creationDate": Date().timeIntervalSince1970] as [String : Any]
            newref.updateChildValues(newvalues) { (err, ref) in
                if let err = err {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Failed to save post to DB", err)
                    return
                }
                
                
                print("Successfully saved post to DB")
                //            self.dismiss(animated: true, completion: nil)
            }
            
            
            var numlines2 = textView.numberOfLines()
                       if(textView.text.count == 0){
                           
                           numlines2 = 0
                       }
            
            let values = ["imageUrl": imageUrl, "caption": caption,
                          "location": locationText,"imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "usersName": uid, "creationDate": Date().timeIntervalSince1970, "numberoflikes":0,"likes": "", "charactercount": textCount , "Audio64": audioString, "Global": global, "postorevent": "post" , "EndDateString": "","StartTimeString": "", "numberofspaces": numlines2, "numberofcomments":0] as [String : Any]
            //Date().timeIntervalSince1970,
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
            
            
            let userPost = Database.database().reference().child("users").child(uid).child("ownposts").child(ref.key!)
            let uservalues = ["postid": ref.key!, "global": global] as [String : Any]
                       userPost.updateChildValues(uservalues)
            
            
            let userPostloc = Database.database().reference().child("LocationPosts").child(locationText).child(ref.key!)
            let uservaluesloc = ["postid": ref.key!, "global": global, "userid":uid] as [String : Any]
                       userPostloc.updateChildValues(uservaluesloc)
            
            for item in friendsList {
                      let friendPost = Database.database().reference().child("users").child(item).child("friendposts").child(ref.key!)
                      let uservalues = ["postid": ref.key!] as [String : Any]
                      friendPost.updateChildValues(uservalues)
                      
                  }
            
            self.tabBarController!.selectedIndex = selectedIndex ?? 0
            
        }
        
    
        
        
        fileprivate func saveToDatabaseWithNoMedia() {
            //guard let postImage = pickedImage else { return }
            guard let caption = textView.text else { return }
            // guard let locationText = locationTextField.text, !locationText.isEmpty else { return }
            let locationText = chosenLocation
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            print(caption)

            let userPostRef = Database.database().reference().child("posts")
            let commentPostRef = Database.database().reference().child("comments")
          // let ref = userPostRef.childByAutoId()
            let new_date = Int(Date().timeIntervalSince1970 * 100000.0)
            
           // let ref = userPostRef.child(String(new_date))
                
            let ref = userPostRef.childByAutoId()
           // let newref = commentPostRef.child(String(new_date))
            let newref = commentPostRef.child(ref.key!)
            print()
            var numlines = textView.numberOfLines()
            if(textView.text.count == 0){
                
                numlines = 0
            }
            
            
           
            let values = ["imageUrl": "noImage", "caption": caption,
                          "location": locationText,"imageWidth": 0, "imageHeight": 0, "usersName": uid, "creationDate": Date().timeIntervalSince1970, "numberoflikes":0,"likes": "", "charactercount": textCount , "Audio64": audioString, "Global": global, "postorevent": "post" , "EndDateString": "","StartTimeString": "", "numberofspaces": numlines, "numberofcomments":0] as [String : Any]
            
            let newvalues = ["commentnum": 0, "creationDate": Date().timeIntervalSince1970] as [String : Any]
            newref.updateChildValues(newvalues) { (err, ref) in
                if let err = err {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Failed to save post to DB", err)
                    return
                }
                
                
                print("Successfully saved post to DB")
                //            self.dismiss(animated: true, completion: nil)
            }
            
            
            
            ref.updateChildValues(values) { (err, ref) in
                if let err = err {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Failed to save post to DB", err)
                    return
                }
                
                
                print("Successfully saved post to DB")
    //            self.dismiss(animated: true, completion: nil)
            }
            let userPost = Database.database().reference().child("users").child(uid).child("ownposts").child(ref.key!)
            let uservalues = ["postid": ref.key!, "global":global] as [String : Any]
                                  userPost.updateChildValues(uservalues)
            
            
            let userPostloc = Database.database().reference().child("LocationPosts").child(locationText).child(ref.key!)
            let uservaluesloc = ["postid": ref.key!, "global": global, "userid":uid] as [String : Any]
                       userPostloc.updateChildValues(uservaluesloc)
            
            
            for item in friendsList {
                      let friendPost = Database.database().reference().child("users").child(item).child("friendposts").child(ref.key!)
                      let uservalues = ["postid": ref.key!] as [String : Any]
                      friendPost.updateChildValues(uservalues)
                      
                  }
            self.tabBarController!.selectedIndex = selectedIndex ?? 0
            
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
  
}




extension UIView {
        func addBackground(contentMode: UIView.ContentMode = .scaleToFill) {
            // setup the UIImageView
            let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
            backgroundImageView.image = screenshot
            backgroundImageView.contentMode = contentMode
            backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(backgroundImageView)
            sendSubviewToBack(backgroundImageView)
            
            // adding NSLayoutConstraints
            let leadingConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
            let trailingConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
            let topConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
            let bottomConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            
            NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
        }
  
}





extension UITextView{

    func numberOfLines() -> Int{
        if let fontUnwrapped = self.font{
            return Int(self.contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }

}
