//
//  File.swift
//  SmartCampus
//
//  Created by Tommy Chavez on 7/9/19.
//  Copyright © 2019 Tommy Chavez. All rights reserved.
//
//https://www.youtube.com/watch?v=S5i8n_bqblE&t=550s

// corner radius from storyboard
//https://stackoverflow.com/questions/34215320/use-storyboard-to-mask-uiview-and-give-rounded-corners
//9.10 for popup
import UIKit
import Firebase
import Photos



class newEventController:  UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
   
    @IBOutlet weak var littlePreview: UIImageView!
    var photo = false
    
    @IBAction func cancelAct(_ sender: Any) {
        if(cancelButton.isHidden == false ){
            photo = false
            littlePreview.image = UIImage(named: "whitesquare")
            cancelButton.isHidden = true
        }
    }
    @IBOutlet weak var cancelButton: UIButton!
    let locations = ["Art Building","Book Store","Business Center","CEFCU Stadium","Dorms","Engineering Building", "Downtown San Jose","Event Center","Greek Life","Health Center","Housing","MLK Jr Library","Music Building", "Parking","San Jose State University","Science Building","SRAC", "Student Union"]
    @IBOutlet weak var dropdownmenu: UITableView!
     @IBOutlet weak var dropdowntableHC: NSLayoutConstraint!
    
    @IBOutlet weak var segmentstartend: UISegmentedControl!
    @IBOutlet weak var addloc: UIButton!
    @IBOutlet weak var titlecount: UILabel!
    @IBOutlet weak var datePickerEnd: UIDatePicker!
    @IBOutlet weak var descriptiontext: UITextView!
    @IBOutlet weak var placeholderfirst: UILabel!
    @IBOutlet weak var endtimelabel: UILabel!
    @IBOutlet var backgroundview: UIView!
    @IBOutlet weak var startbutton: UIView!
    @IBOutlet weak var event_title: UITextView!
    @IBOutlet weak var evendescriptionplace: UILabel!
    @IBOutlet weak var datepicker: UIDatePicker!
    var dateString: String?
    var titleCount = 0
    var descriptionCount = 0
    var endTime:TimeInterval!
    var startTime:TimeInterval!
    override func viewDidLoad() {
        super.viewDidLoad()
         addbutton.isEnabled = true
      segmentstartend.selectedSegmentIndex = 0
        segmentstartend.removeBorders()
        //view.addBackground()
        datePickerEnd.minimumDate = Date()
        datepicker.minimumDate = Date()
       dropdowntableHC.constant = 0 
        //popoverlayover.layer.masksToBounds = true
       event_title.becomeFirstResponder()
        event_title.delegate = self
        descriptiontext.delegate = self
        dropdownmenu.dequeueReusableCell(withIdentifier: "chooseLocation")
        dropdownmenu.delegate = self
        dropdownmenu.dataSource = self
        dropdownmenu.layer.borderWidth = 2.0
       // textfield.inputView = datePicker
        //self.view.backgroundColor = UIColor.blue
        event_title.returnKeyType = UIReturnKeyType.done
        descriptiontext.returnKeyType = UIReturnKeyType.done
        event_title.font = .systemFont(ofSize: 19.5)
        descriptiontext.font = .systemFont(ofSize: 18.6)
        setupcancelbutton()
     
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

    
    
    

    
    @IBAction func valuechangedsegment(_ sender: Any) {
        if(segmentstartend.selectedSegmentIndex == 0){
            view.endEditing(true)
            datePickerEnd.isEnabled = false
            datePickerEnd.isHidden = true
            
            datepicker.isEnabled = true
            datepicker.isHidden = false
            datepicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
            
        }
        else if(segmentstartend.selectedSegmentIndex == 1){
            datepicker.isEnabled = false
            datepicker.isHidden = true
            
            datePickerEnd.isEnabled = true
            datePickerEnd.isHidden = false
            datePickerEnd.addTarget(self, action: #selector(datePickerChanged2(picker:)), for: .valueChanged)
            
            view.endEditing(true)
        }
    }
    @IBAction func touchaddloc(_ sender: Any) {
        
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
    @IBOutlet weak var descriptionCountLabel: UILabel!
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            addbutton.sendActions(for: .touchUpInside)
        }
        
        print("HERE")
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
      //  if(textView.text == event_title.text ){
        if(textView == event_title ){
            print("event title")
        titleCount = numberOfChars
       titlecount.text = "\(numberOfChars) /24"
            
            return numberOfChars < 24
        }
       // else if(textView.text ==  descriptiontext.text ){
        else if(textView ==  descriptiontext){
            descriptionCount = numberOfChars
             print("description title")
            descriptionCountLabel.text = "\(numberOfChars) /140"
        }
        
        return numberOfChars < 140    // 10 Limit Value
    }
    var chosenLocation = "San Jose State University"
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            chosenLocation = locations[indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
            
            UIView.animate(withDuration: 0.5) {
                self.dropdowntableHC.constant = 0
                self.view.layoutIfNeeded()
            }
            
            addloc.setTitle(chosenLocation,
                                       for: .normal)
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
    
    @IBAction func cancelbuttonact(_ sender: Any) {
       //self.presentingViewController?.dismiss(animated: false, completion:nil)
         //self.tabBarController!.selectedIndex = selectedIndex ?? 0
      
        
      //  self.presentingViewController?.dismiss(animated: false, completion:nil)
        
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         photo = false
        //view.addBackground()
    }
   
    
    
    @IBOutlet weak var timestartlabel: UILabel!
//    @objc func dateChanged(datePicker: UIDatePicker){
//       let  dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "LLLL dd, YYYY HH:mm"
//
//        timestartlabel.text = dateFormatter.string(from: datePicker.date)
//        view.endEditing(true)
//    }
    
   
    
    
    @objc func datePickerChanged(picker: UIDatePicker) {
     startTime = picker.date.timeIntervalSince1970
        let  dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, YYYY h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
    
             timestartlabel.text = dateFormatter.string(from: picker.date)
        let  dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "MMM d, YYYY"
        dateString = dateFormatter2.string(from: picker.date)
       
        
        
    }
    
    func textViewDidChange(_ textView: UITextView){
        print(descriptiontext.text!)
        if(event_title.text! != ""){
            placeholderfirst.text = ""
        }
        else if(event_title.text! == "") {
             placeholderfirst.text = "Event Name"
        }
        
        if(descriptiontext.text! != ""){
           evendescriptionplace.text = ""
        }
        else if(descriptiontext.text! == "") {
            evendescriptionplace.text = "Event Description"
        }
        
        
        
        
        
        
    }
    
    @IBAction func postbuttonaction(_ sender: Any) {
          self.presentingViewController?.dismiss(animated: false, completion:nil)
        
        
    }
    @objc func datePickerChanged2(picker: UIDatePicker) {
        endTime = picker.date.timeIntervalSince1970
        let  dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, YYYY h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        endtimelabel.text = dateFormatter.string(from: picker.date)
        
    }
    
    @IBAction func startbuttonaction(_ sender: Any) {
        
         handlePlusPhoto2()
         
        
        //self.view.addSubview(picker)
        
        
    }
    @IBAction func endTimeAct(_ sender: Any) {
    view.endEditing(true)
    datePickerEnd.isEnabled = false
    datePickerEnd.isHidden = true
    
    datepicker.isEnabled = true
    datepicker.isHidden = false
    datepicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
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
    var pickedImage: UIImage?
    
    @IBOutlet weak var addbutton: UIButton!
    
    @IBAction func addbutton(_ sender: Any){
    addbutton.isEnabled = false
        print("put someinfo");
        if(startTime == nil || endTime == nil ){
            presentAlertWithTitle(title: "Warning", message: "You are missing a start time and/or end time", options: "Okay") { (option) in
                print("option: \(option)")
                switch(option) {
                case 0:
                    print("option one")
                    self.endTimeAct(self)
                    break
                  //  return
                case 1:
                    print("option two")
                    self.endTimeAct(self)
                    break
                    //return
                default:
                    print("option two")
                    self.endTimeAct(self)
                    break
                }
            }
            

            return
                     }
        else {
            print("you did put enough info");
        if(photo == false){
         funcwnopic()
        }
        if(photo == true){
            
            funcwapic()
        }
        }
        }
    
    
      fileprivate func funcwapic(){
        guard let image = pickedImage else { return }

           
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
        
     fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
         guard let postImage = pickedImage else { return }
        let uid = Auth.auth().currentUser?.uid
                   let eventTitle = event_title.text
                   let descriptionText = descriptiontext.text

                   if(startTime == nil || endTime == nil ){return}
                   let userId = Int(startTime)
                   let userId2 = Int(endTime)
                  // let userPostRef = Database.database().reference().child("events").child(String(userId)).child(String(userId2))
         let userPostRef = Database.database().reference().child("events").child(String(userId)+String(userId2))
                   let ref = userPostRef
                  // let ref = userPostRef.childByAutoId()
                   var numberofspaces = descriptiontext.numberOfLines()
        if(descriptionText?.count == 0){
            numberofspaces = 0
        }
                   
                   let values = ["ProfileUrl": myProfilePicture, "PosterUsername": myUsername, "StartDate": String(startTime), "EndDate":String(endTime),
                                 "EndDateString": endtimelabel.text,"StartTimeString": timestartlabel.text,
                                 "posterid": uid!, "EventTitle": eventTitle!, "EventDescription": descriptionText!,"Locations": chosenLocation, "DescriptionCount": descriptionCount, "EventCount": titleCount,"DateString": dateString , "numberofspaces": numberofspaces] as [String : Any]
                   
                   
                   let userPostRef2 = Database.database().reference().child("posts")
                   //let ref = userPostRef
                   let userPostRef3 = Database.database().reference().child("popposts")
                
                   // let ref = userPostRef.childByAutoId()
                   let new_date = Int(Date().timeIntervalSince1970 * 100000.0)
                   
                  // let ref2 = userPostRef2.child(String(new_date))
        let ref2 = userPostRef2.childByAutoId()
        let userPost = Database.database().reference().child("users").child(uid!).child("ownposts").child(ref2.key!)
        let uservalues = ["postid": ref2.key!, "global": global] as [String : Any]
        userPost.updateChildValues(uservalues)
        
        
        let userPostloc = Database.database().reference().child("LocationPosts").child(chosenLocation).child(ref2.key!)
        let uservaluesloc = ["postid": ref.key!, "global": global, "userid":uid] as [String : Any]
                   userPostloc.updateChildValues(uservaluesloc)
        for item in friendsList {
            let friendPost = Database.database().reference().child("users").child(item).child("friendposts").child(ref2.key!)
            let uservalues = ["postid": ref2.key!] as [String : Any]
            friendPost.updateChildValues(uservalues)
            
        }
        var numberofspaces2 = descriptiontext.numberOfLines()
               if(descriptionText?.count == 0){
                   numberofspaces2 = 0
               }
                   
                   let values2 = ["imageUrl":imageUrl, "caption": eventTitle!,
                                  "location": chosenLocation,"imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "usersName": uid, "creationDate": Date().timeIntervalSince1970, "numberoflikes":0,"likes": "", "charactercount": descriptionCount , "Audio64": descriptionText!, "Global": global, "postorevent": "event", "EndDateString": endtimelabel.text,"StartTimeString": timestartlabel.text , "numberofspaces": numberofspaces2, "postid": ref2.key, "numberofcomments":0 ,"datestringnotime": dateString] as [String : Any]
                   
                   ref2.updateChildValues(values2) { (err, ref) in
                       if let err = err {
                           self.navigationItem.rightBarButtonItem?.isEnabled = true
                           print("Failed to save post to DB", err)
                           return
                       }
                   }
                   
        ref.updateChildValues(values2) { (err, ref) in
            if let err = err {
                
                print("Failed to save post to DB", err)
                return
            }

        }
                   
                   let commentPostRef = Database.database().reference().child("comments")
                   
                   
        let newref = commentPostRef.child(ref2.key!)
                   print()
                   
                   
                   let newvalues = ["commentnum": 0, "creationDate": Date().timeIntervalSince1970] as [String : Any]
                   newref.updateChildValues(newvalues) { (err, ref) in
                       if let err = err {
                           self.navigationItem.rightBarButtonItem?.isEnabled = true
                           print("Failed to save post to DB", err)
                           return
                       }
                   self.performSegue(withIdentifier: "unwindtoHome", sender: self)
                       
                   }
                    //self.presentingViewController?.dismiss(animated: false, completion:nil)
         }
    
    
    fileprivate func funcwnopic(){
        

        
        let uid = Auth.auth().currentUser?.uid
              let eventTitle = event_title.text
              let descriptionText = descriptiontext.text
              
              if(startTime == nil || endTime == nil ){return}
              let userId = Int(startTime)
              let userId2 = Int(endTime)
              //let userPostRef = Database.database().reference().child("events").child(String(userId)).child(String(userId2))
              let userPostRef = Database.database().reference().child("events").child(String(userId)+String(userId2))
                
              let ref = userPostRef
             // let ref = userPostRef.childByAutoId()
              var numberofspaces3 = descriptiontext.numberOfLines()
                     if(descriptionText?.count == 0){
                         numberofspaces3 = 0
                     }
              
              let values = ["ProfileUrl": myProfilePicture, "PosterUsername": myUsername, "StartDate": String(startTime), "EndDate":String(endTime),
                            "EndDateString": endtimelabel.text,"StartTimeString": timestartlabel.text,
                            "posterid": uid!, "EventTitle": eventTitle!, "EventDescription": descriptionText!,"Locations": chosenLocation, "DescriptionCount": descriptionCount, "EventCount": titleCount,"DateString": dateString , "numberofspaces": numberofspaces3 ] as [String : Any]
              
              
              let userPostRef2 = Database.database().reference().child("posts")
              //let ref = userPostRef
              
           
              // let ref = userPostRef.childByAutoId()
              let new_date = Int(Date().timeIntervalSince1970 * 100000.0)
              
             // let ref2 = userPostRef2.child(String(new_date))
        let ref2 = userPostRef2.childByAutoId()
        let userPost = Database.database().reference().child("users").child(uid!).child("ownposts").child(ref2.key!)
        let uservalues = ["postid": ref2.key!, "global": global] as [String : Any]
        userPost.updateChildValues(uservalues)
        
        let userPostloc = Database.database().reference().child("LocationPosts").child(chosenLocation).child(ref.key!)
        let uservaluesloc = ["postid": ref2.key!, "global": global, "userid":uid] as [String : Any]
                   userPostloc.updateChildValues(uservaluesloc)
        
        
        for item in friendsList {
                  let friendPost = Database.database().reference().child("users").child(item).child("friendposts").child(ref2.key!)
                  let uservalues = ["postid": ref2.key!] as [String : Any]
                  friendPost.updateChildValues(uservalues)
                  
              }
        var numberofspaces4 = descriptiontext.numberOfLines()
                     if(descriptionText?.count == 0){
                         numberofspaces4 = 0
                     }
        
        
              let values2 = ["imageUrl": "noImage", "caption": eventTitle!,
                             "location": chosenLocation,"imageWidth": 0, "imageHeight": 0, "usersName": uid, "creationDate": Date().timeIntervalSince1970, "numberoflikes":0,"likes": "", "charactercount": descriptionCount , "Audio64": descriptionText!, "Global": global, "postorevent": "event", "EndDateString": endtimelabel.text,"StartTimeString": timestartlabel.text , "numberofspaces":numberofspaces4, "postid": ref2.key , "numberofcomments":0 ,"datestringnotime": dateString] as [String : Any]
              
              ref2.updateChildValues(values2) { (err, ref) in
                  if let err = err {
                      self.navigationItem.rightBarButtonItem?.isEnabled = true
                      print("Failed to save post to DB", err)
                      return
                  }
              }
              
        ref.updateChildValues(values2) { (err, ref) in
            if let err = err {
                
                print("Failed to save post to DB", err)
                return
            }

        }
              
              let commentPostRef = Database.database().reference().child("comments")
              
              
        let newref = commentPostRef.child(ref2.key!)
              print()
              
              
              let newvalues = ["commentnum": 0, "creationDate": Date().timeIntervalSince1970] as [String : Any]
              newref.updateChildValues(newvalues) { (err, ref) in
                  if let err = err {
                      self.navigationItem.rightBarButtonItem?.isEnabled = true
                      print("Failed to save post to DB", err)
                      return
                  }
                self.performSegue(withIdentifier: "unwindtoHome", sender: self)
                  
              }
               //self.presentingViewController?.dismiss(animated: false, completion:nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
       
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "chooseLocation")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "chooseLocation")
             cell?.textLabel?.text = self.locations[ indexPath.row]
            cell?.textLabel?.numberOfLines = 0;
            cell?.textLabel?.lineBreakMode = .byWordWrapping
            cell?.textLabel?.font = .systemFont(ofSize: 9)
        }
            cell?.textLabel?.text = self.locations[ indexPath.row]
        cell?.textLabel?.numberOfLines = 0;
        cell?.textLabel?.lineBreakMode = .byWordWrapping
        cell?.textLabel?.font = .systemFont(ofSize: 9)
        return cell!
}
    

}
