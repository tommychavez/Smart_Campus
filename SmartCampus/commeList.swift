//
//  commeList.swift
//  SmartCampus
//
//  Created by Tommy Chavez on 6/17/19.
//  Copyright © 2019 Tommy Chavez. All rights reserved.
//
//
//  File.swift
//  SmartCampus
//
//  Created by Tommy Chavez on 6/13/19.
//  Copyright © 2019 Tommy Chavez. All rights reserved.
//

import UIKit
import Firebase
import Foundation
//import FirebaseDatabase
 var replyingToId = "noreply"

 var positiononpush = 450;

class commeListController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate{
    let cellId = "cellId"
    var postId = ""
    var posterid = ""
     let tableView: UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 445));
   // let tableView: UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: Int(UIScreen.main.bounds.height-135)));
   
  let positiononpush = 450;
    
   // let commentArea: UITextView = UITextView(frame: CGRect(x: 10, y: Int(UIScreen.main.bounds.height-120), width: Int(UIScreen.main.bounds.width-90), height: 30));
    let commentArea: UITextView = UITextView(frame: CGRect(x: 10, y: 445, width: Int(UIScreen.main.bounds.width-90), height: 30));
    
  //  let commentButton:UIButton = UIButton(frame: CGRect(x:  Int(UIScreen.main.bounds.width - 60) , y:Int(UIScreen.main.bounds.height-120), width: 40 , height: 30));
    let commentButton:UIButton = UIButton(frame: CGRect(x:  Int(UIScreen.main.bounds.width - 60) , y: 445, width: 40 , height: 30));
    
        let commentButton2:UIButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width/2 - 100 , y: 50, width: 120 , height: 30));
    override func viewDidLoad() {
        
        //print("Comment List")
        print(postId)
        super.viewDidLoad()
         loadPosts2( completion: { message,message2 in
         self.loadPosterInfo(Message: message2, postid: message)
         })
        view.addSubview(tableView)
        view.addSubview(commentArea)
        view.addSubview(commentButton)
         view.addSubview(commentButton2)
        //commentButton2.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        commentButton2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        commentButton2.heightAnchor.constraint(equalToConstant: 120).isActive = true
       
        commentButton2.setTitle(" Load More Comments", for: .normal)
        commentButton2.setTitleColor(UIColor.black, for: .normal)
      commentButton2.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
       
       
        // self.navigationItem.title = "Load More Comments"
        //        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.heavy),NSAttributedString.Key.foregroundColor: UIColor.black]
        view.backgroundColor = UIColor.white
        tableView.register(newsCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        let bottomOffset = CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.frame.size.height)
        self.tableView.setContentOffset(bottomOffset, animated: false)
        commentArea.delegate = self
        keyboardWillDisappear()
       // commentArea.becomeFirstResponder()
        commentArea.layer.borderWidth = 1
        commentArea.layer.cornerRadius = 2//  loadfriendS()
        commentButton.backgroundColor = UIColor.blue
        commentButton.setTitle("Add Comment", for: .normal)
        commentButton.titleLabel?.textAlignment = .center
        commentButton.titleLabel?.adjustsFontSizeToFitWidth = true
        commentButton.titleLabel?.numberOfLines = 2
        commentButton.layer.cornerRadius = 3
        commentButton.addTarget(self, action: #selector(commentButtonAct), for: .touchUpInside)
        commentButton2.addTarget(self, action: #selector(commentbutton2act), for: .touchUpInside)
        tableView.separatorStyle = .none
       tableView.keyboardDismissMode = .onDrag
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
       // NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
   
              AppUtility.lockOrientation(.portrait)
        commentArea.font = .systemFont(ofSize: 16.5)
        commentButton2.isEnabled = true
        self.navigationItem.titleView = commentButton2
        
        }
            
            override func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)

                // Don't forget to reset when view is being removed
                AppUtility.lockOrientation(.all)
               // commentArea.font = .systemFont(ofSize: 18)
            }
    var run = 1;
    @objc func  commentbutton2act(){
        print("Tappy")
       // print(lastcomment2)
       // commentButton2.isHidden = true
        loadPosts3(run:run,  completion: { message,message2 in
                self.loadPosterInfo(Message: message2, postid: message)
                })
        run = run + 1

        
    }
    
    @objc func keyboardWillDisappear() {
        print("keyboard gone")
        //Do something here
        // write code as per your requirementsprin
        UIView.animate(withDuration: 0.5, animations: {
            self.commentArea.frame = CGRect(x: 10, y: Int(UIScreen.main.bounds.height-120), width: Int(UIScreen.main.bounds.width-90), height: 35);
            self.commentButton.frame = CGRect(x:  Int(UIScreen.main.bounds.width - 60) ,y:Int(UIScreen.main.bounds.height-120), width: 40 , height: 35);
            self.tableView.frame  = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: Int(UIScreen.main.bounds.height-135));
            
        })
    }
    var textCount = 0
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
      
        textCount = numberOfChars
          print(textCount)
        return numberOfChars < 140    // 10 Limit Value
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // write code as per your requirementsprin
        UIView.animate(withDuration: 0.5, animations: {
            self.commentArea.frame = CGRect(x: 10, y: 445, width: UIScreen.main.bounds.width-90, height: 30);
            self.commentButton.frame = CGRect(x:  UIScreen.main.bounds.width - 60 , y: 445, width: 40 , height: 30);
             self.tableView.frame  = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 445);
//            let bottomOffset = CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.frame.size.height)
//            self.tableView.setContentOffset(bottomOffset, animated: false)
        })

    }
    
    @objc func commentButtonAct(){
        print("TAPPY")
        print(replyingToId)
        if(replyingToId == "noreply"){
            var commentPostRef = Database.database().reference().child("comments").child(postId).child("comments").childByAutoId()
            
//            let new_date = commentPostRef.childByAutoId()
//            var childid = new_date.key!
//            childid = childid  + "000"
            
            let newref = commentPostRef
            print()
            
            
            
            let newvalues = ["comment": commentArea.text ?? "", "commenterid":uid,"commentername": usersShowName, "commenterurlpic":myProfilePicture, "timeposted": Date().timeIntervalSince1970, "commentorreply": "comment" , "numberofspaces": commentArea.numberOfLines(),"replies": 0] as [String : Any]
            
            
            var useridpluspostid = ""
            var name = postId
           // useridpluspostid = "\(self.uid!)\( String(new_date)) ";
    

                let noti = ["Notification Type": "comment","ID Number": postId,"Userid":self.uid! ] as [String : Any]
            
             //Database.database().reference().child("users").child(posterid).child("notifications").child(String(new_date)).child(useridpluspostid).updateChildValues(noti);
            
            
            newref.updateChildValues(newvalues) { (err, ref) in
                if let err = err {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Failed to save post to DB", err)
                    return
                }
                
                
                print("Successfully saved post to DB")
                //            self.dismiss(animated: true, completion: nil)
                 self.dismissKeyboard()
                self.keyboardWillDisappear()
                self.loadPosts(start: commentPostRef.key!, completion: { message,message2 in
                self.loadPosterInfo(Message: message2, postid: message)
                })
              // self.loadPosts()
            }
            
        
        }
       
        if(replyingToId != "noreply"){
            print("we are in here")
//            replyingToId =
//                replyingToId.substring(with:
//            Range<String.Index>(start: replyingToId.startIndex, end: replyingToId.endIndex))
            
            let commentPostRef =
                Database.database().reference().child("comments").child(postId).child("comments").childByAutoId()
            let new_date = Int(Date().timeIntervalSince1970 * 100000.0)
            
            let newref = commentPostRef
            print()
            
            
         
                let newvalues = ["comment": commentArea.text ?? "", "commenterid":uid,"commentername": usersShowName, "commenterurlpic":myProfilePicture, "timeposted": Date().timeIntervalSince1970, "commentorreply": "comment" , "numberofspaces": commentArea.numberOfLines()] as [String : Any]
        
            
            newref.updateChildValues(newvalues) { (err, ref) in
                if let err = err {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Failed to save post to DB", err)
                    return
                }
                
                
                print("Successfully saved post to DB")
                //            self.dismiss(animated: true, completion: nil)
                //self.tommy123.removeAll()
                self.dismissKeyboard()
                self.keyboardWillDisappear()
                
               
                //self.tableView.reloadData()
            }
            self.loadPosts2( completion: { message,message2 in
             self.loadPosterInfo(Message: message2, postid: message)
             })
            
        }
        
       
        
        commentArea.text = ""
        replyingToId = "noreply"
        Database.database().reference().child("comments").child(postId).child("commentnum").setValue(tommy123.count+1)
    }
    
    let uid = Auth.auth().currentUser?.uid
    
    var tommy123 = [Post]()
    
      func loadPosterInfo(Message: String, postid: String ){
           // print(postid)
            Database.database().reference().child("users").child(Message).observeSingleEvent(of: .value, with: { (snapshot) in
                //print(snapshot.value ?? "")
               
                
                let dictionary = snapshot.value as? [String: Any]
                let username = dictionary?[ "username"] as? String
                
                guard let profileimageURL = dictionary?[ "ProfileImage"] as? String else {return}
                //print(username)
                //print(profileimageURL);
                if let foo = self.tommy123.first(where: { $0.postID == postid}){
                    //print("HERE")
                    foo.usersName = username!;
                   
                    foo.imageUrl = profileimageURL;
                    
                    
                    DispatchQueue.main.async(execute: {
    
                            self.tableView.reloadData()
    
    
                    })
                }
            })
            
        }
    
    fileprivate func loadPosts(start: String, completion: @escaping (_ message: String,_ message2: String) -> Void){
         Database.database().reference().child("comments").child(postId).child("comments").child(start) .observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
           
//            let postid = snapshot.key
//            // print(postid)
//
//            for rest in snapshot.children.allObjects as! [DataSnapshot] {
//                print("KEY")
//                print(rest.key)
       
            let snapid = snapshot.key
            
             let dict = snapshot.value as? [String: Any]
                
            let captionText = dict?["comment"] as? String //let myEvent = event[0] as! [String:Any]. And then myEvent["end_time"] as? String.
                print( "captionText")
                print(captionText)
                //let captionText = "Caption"
            let photoURLString = dict?["commenterurlpic"] as? String
                //backgroundTableCellSize = 400
            let USERNAME = dict?["commenterid"] as? String
            let locationText =  dict?["commentorreply"] as? String
                print(locationText)
                let likes = 0 //dict["numberoflikes"] as! Int
                let postcount = 0 //dict["charactercount"] as! Int
            let spaces =  dict?["numberofspaces"] as? Int
                
                var likedbyme = false ;
                
                
                var likerarray = [User2] ()
                
                
                let postnumber = snapid
            let postTime = dict?["timeposted"] as? TimeInterval
                // let Audio64 = dict["Audio64"] as! String
                let Audio64 = "noAudio"
                //  print(Audio64)
                //405
                
              //  let timeendstring =  dict["EndDateString"] as! String
               // let timestartstring = dict["StartTimeString"] as! String
            
                var timeendstring = ""
            var difference =  Int( Date().timeIntervalSince1970 - postTime!)
                print ("differce")
                print(difference)
                if(difference<60){
                    if(difference<10){
                        timeendstring = "Just Posted"
                    }
                    else {
                        timeendstring = String(difference)
                        timeendstring = ("\(timeendstring) seconds ago")
                        
                        //cell.timeStamp.text = "\(timeStampString) seconds ago"
                    }
                }
                    
                else if(difference < 3600){
                    difference = difference/60
                    timeendstring = String(difference)
                    if(timeendstring == "1"){
                        // cell.timeStamp.text = "\(timeStampString) minute ago"
                        timeendstring = ("\(timeendstring) minute ago ")
                    }
                    else{
                        timeendstring = ("\(timeendstring) minutes ago ")
                    }
                }
                    
                else if(difference < 86400){
                    difference = difference/3600
                    timeendstring = String(difference)
                    if(timeendstring == "1"){
                        timeendstring = ("\(timeendstring) hour ago ")
                    }
                    else{
                        timeendstring = ("\(timeendstring) hours ago ")
                    }
                    
                }
                    
                else {//if(difference < 86400){
                    difference = difference/86400
                    timeendstring = String(difference)
                    if(timeendstring == "1"){
                        timeendstring = ("\(timeendstring) day ago ")
                    }
                    else{
                        timeendstring = ("\(timeendstring) days ago ")
                    }
                    
                }
                
                print(timeendstring)
                
                
                
            let post2 = Post(captionText: captionText!
                , photoURLString: "", USERNAME: "", locationText: locationText!, likes: likes, likedbyme: likedbyme, postid: snapid, postcount: postcount, Audio64: Audio64, postTime: postTime!,likerArray: likerarray, likersString: "",numberOfComments: 0 , Global: true, postOrEvent: "post", timestartstring: "",  timeendstring: timeendstring, displayname: USERNAME!, profimg: "", score: 0, spaces: spaces!)
                
              self.tommy123.append(post2)
            completion(snapid, USERNAME!)
              
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                   let indexPath = IndexPath(row: self.tommy123.count-1, section: 0)
                   self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                })
                
     })
    
            
        
                
                
            
        
        
        
        
        
        }
    
   // var lastcomment = "";
    
    var lastcomment = [String]()
    var lastcomment2 = "";
    var firstcommentid = "";
    fileprivate func loadPosts2( completion: @escaping (_ message: String,_ message2: String) -> Void){
    tommy123.removeAll()
        var count = 0;
       
        Database.database().reference().child("comments").child(postId).child("comments").queryOrderedByKey().queryLimited(toFirst: 1).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
        
         let postid = snapshot.key
         // print(postid)
         
         for rest in snapshot.children.allObjects as! [DataSnapshot] {
             print("KEY")
             print(rest.key)
            self.firstcommentid = rest.key;
        
        
            DispatchQueue.main.async(execute: {
                           })
                           }
        })
        Database.database().reference().child("comments").child(postId).child("comments").queryOrderedByKey().queryLimited(toLast: 6).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
           
          
            // print(postid)
            
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                print("KEY")
                print(rest.key)
                if(count == 0){
                    self.lastcomment.append( rest.key )
                    //self.lastcomment2 = rest.key
                    count = count + 1
                }
                  let postid = rest.key
            if let dict = rest.value as? [String: Any] {
                
            let captionText = dict["comment"] as! String //let myEvent = event[0] as! [String:Any]. And then myEvent["end_time"] as? String.
                print( "captionText")
                print(captionText)
                //let captionText = "Caption"
            let photoURLString = dict["commenterurlpic"] as! String
                //backgroundTableCellSize = 400
            let USERNAME = dict["commenterid"] as! String
            let locationText =  dict["commentorreply"] as! String
                print(locationText)
                let likes = 0 //dict["numberoflikes"] as! Int
                let postcount = 0 //dict["charactercount"] as! Int
            let spaces =  dict["numberofspaces"] as! Int
                
                var likedbyme = false ;
                
                
                var likerarray = [User2] ()
                
                
                let postnumber = postid
            let postTime = dict["timeposted"] as! TimeInterval
                // let Audio64 = dict["Audio64"] as! String
                let Audio64 = "noAudio"
                //  print(Audio64)
                //405
                
              //  let timeendstring =  dict["EndDateString"] as! String
               // let timestartstring = dict["StartTimeString"] as! String
            
                var timeendstring = ""
                var difference =  Int( Date().timeIntervalSince1970 - postTime)
                print ("differce")
                print(difference)
                if(difference<60){
                    if(difference<10){
                        timeendstring = "Just Posted"
                    }
                    else {
                        timeendstring = String(difference)
                        timeendstring = ("\(timeendstring) seconds ago")
                        
                        //cell.timeStamp.text = "\(timeStampString) seconds ago"
                    }
                }
                    
                else if(difference < 3600){
                    difference = difference/60
                    timeendstring = String(difference)
                    if(timeendstring == "1"){
                        // cell.timeStamp.text = "\(timeStampString) minute ago"
                        timeendstring = ("\(timeendstring) minute ago ")
                    }
                    else{
                        timeendstring = ("\(timeendstring) minutes ago ")
                    }
                }
                    
                else if(difference < 86400){
                    difference = difference/3600
                    timeendstring = String(difference)
                    if(timeendstring == "1"){
                        timeendstring = ("\(timeendstring) hour ago ")
                    }
                    else{
                        timeendstring = ("\(timeendstring) hours ago ")
                    }
                    
                }
                    
                else {//if(difference < 86400){
                    difference = difference/86400
                    timeendstring = String(difference)
                    if(timeendstring == "1"){
                        timeendstring = ("\(timeendstring) day ago ")
                    }
                    else{
                        timeendstring = ("\(timeendstring) days ago ")
                    }
                    
                }
                
                print(timeendstring)
                
                
                
                let post2 = Post(captionText: captionText
                    , photoURLString: "", USERNAME: "", locationText: locationText, likes: likes, likedbyme: likedbyme, postid: postid, postcount: postcount, Audio64: Audio64, postTime: postTime,likerArray: likerarray, likersString: "",numberOfComments: 0 , Global: true, postOrEvent: "post", timestartstring: "",  timeendstring: timeendstring, displayname: USERNAME, profimg: "", score: 0, spaces: spaces)
                
              self.tommy123.append(post2)
               completion(postid, USERNAME)
               //  self.tommy123.insert(post2, at: 0 )
              
                      //  print("just added reply")
                    //    self.tommy123.insert(post, at: 0
               // self.tommy123.insert(post, at: 0 )
                DispatchQueue.main.async(execute: {
                 //   self.tableView.reloadData()
                })
                }
            
            }
                
                
            
        })
    }
    
    
    
    
    fileprivate func loadPosts3(run: Int,  completion: @escaping (_ message: String,_ message2: String) -> Void){
      // tommy123.removeAll()
           var count = 0;
        var donotdo = false;
        Database.database().reference().child("comments").child(postId).child("comments").queryOrderedByKey().queryEnding(atValue: lastcomment[run-1]).queryLimited(toLast: 6).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
              
              
               // print(postid)
               
               for rest in snapshot.children.allObjects as! [DataSnapshot] {
                   print("KEY2")
                   print(rest.key)
                 let postid = rest.key
//                   if(count == 0){
//
//                       self.lastcomment = rest.key
//
//                   }
                if( self.firstcommentid == rest.key ){
                    self.commentButton2.isHidden = true
                }
                
                
      if(count == 0){
    self.lastcomment.append( rest.key )
    //self.lastcomment2 = rest.key
    //count = count + 1
}
                
                if(self.lastcomment[run-1] == rest.key){
                    donotdo = true

                }
                
               
            
               if let dict = rest.value as? [String: Any] {
                   
               let captionText = dict["comment"] as! String //let myEvent = event[0] as! [String:Any]. And then myEvent["end_time"] as? String.
                   print( "captionText")
                   print(captionText)
                   //let captionText = "Caption"
               let photoURLString = dict["commenterurlpic"] as! String
                   //backgroundTableCellSize = 400
               let USERNAME = dict["commenterid"] as! String
                
                 //let USERNAME2 = dict["commentername"] as! String
               let locationText =  dict["commentorreply"] as! String
                   print(locationText)
                   let likes = 0 //dict["numberoflikes"] as! Int
                   let postcount = 0 //dict["charactercount"] as! Int
               let spaces =  dict["numberofspaces"] as! Int
                   
                   var likedbyme = false ;
                   
                   
                   var likerarray = [User2] ()
                   
                   
                   let postnumber = postid
               let postTime = dict["timeposted"] as! TimeInterval
                   // let Audio64 = dict["Audio64"] as! String
                   let Audio64 = "noAudio"
                   //  print(Audio64)
                   //405
                   
                 //  let timeendstring =  dict["EndDateString"] as! String
                  // let timestartstring = dict["StartTimeString"] as! String
               
                   var timeendstring = ""
                   var difference =  Int( Date().timeIntervalSince1970 - postTime)
                   print ("differce")
                   print(difference)
                   if(difference<60){
                       if(difference<10){
                           timeendstring = "Just Posted"
                       }
                       else {
                           timeendstring = String(difference)
                           timeendstring = ("\(timeendstring) seconds ago")
                           
                           //cell.timeStamp.text = "\(timeStampString) seconds ago"
                       }
                   }
                       
                   else if(difference < 3600){
                       difference = difference/60
                       timeendstring = String(difference)
                       if(timeendstring == "1"){
                           // cell.timeStamp.text = "\(timeStampString) minute ago"
                           timeendstring = ("\(timeendstring) minute ago ")
                       }
                       else{
                           timeendstring = ("\(timeendstring) minutes ago ")
                       }
                   }
                       
                   else if(difference < 86400){
                       difference = difference/3600
                       timeendstring = String(difference)
                       if(timeendstring == "1"){
                           timeendstring = ("\(timeendstring) hour ago ")
                       }
                       else{
                           timeendstring = ("\(timeendstring) hours ago ")
                       }
                       
                   }
                       
                   else {//if(difference < 86400){
                       difference = difference/86400
                       timeendstring = String(difference)
                       if(timeendstring == "1"){
                           timeendstring = ("\(timeendstring) day ago ")
                       }
                       else{
                           timeendstring = ("\(timeendstring) days ago ")
                       }
                       
                   }
                   
                   print(timeendstring)
                   
                   
                   
                   let post2 = Post(captionText: captionText
                       , photoURLString: "", USERNAME: "", locationText: locationText, likes: likes, likedbyme: likedbyme, postid: postid, postcount: postcount, Audio64: Audio64, postTime: postTime,likerArray: likerarray, likersString: "",numberOfComments: 0 , Global: true, postOrEvent: "post", timestartstring: "",  timeendstring: timeendstring, displayname: USERNAME, profimg: "", score: 0, spaces: spaces)
                   
                //self.tommy123.insert(post2)
                if(donotdo == false){
                   self.tommy123.insert(post2, at: count)
                   completion(postid, USERNAME)
                }
                count = count + 1
                donotdo = false
                 
                         //  print("just added reply")
                       //    self.tommy123.insert(post, at: 0
                  // self.tommy123.insert(post, at: 0 )
                   DispatchQueue.main.async(execute: {
                      // self.tableView.reloadData()
                    print("dispatch")
//                    let indexPath = IndexPath(row: count, section: 0)
//                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    //self.tableView.reloadData()
                   })
                   }
               
               }
                   
                   
               
           })
       }
    
     var onetime = true
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//
//     // print("bottom");
//
//      // UITableView only moves in one direction, y axis
//      let currentOffset = scrollView.contentOffset.y
//      let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
//
//      // Change 10.0 to adjust the distance from bottom
//      if maximumOffset - currentOffset > 10.0 {
//       // if(onetime == true ){
//        print("top")
//
//            onetime = false
//          loadPosts3()
//            print(" 'after load post ' ")
//           //let lastRowIndex = self.tblRequestStatus!.numberOfRows(inSection: 0) - 1
////          let indexPath = IndexPath(row: 5, section: 0)
////            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
////           tableView.reloadData()
//      //  }
//
//
//    }
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! newsCell
      cell.delegate = self
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
      //  print(tommy123[indexPath.row].location)
        cell.threedots.isHidden = false
        cell.threedots2.isHidden = true
        cell.replyprofileImageViewTop.isHidden = true
        cell.replypostText.isHidden = true
       cell.CommentStamp.isHidden = true
        cell.replynameButton.isHidden = true
        cell.replylocationButton.isHidden = true
        
        
        cell.nameButton.isHidden = false
        cell.profileImageViewTop.isHidden = false
        cell.profileImageView.isHidden = false
        cell.postText.isHidden = false
        cell.threedots.isHidden = false
        cell.locationButton.isHidden = false
        cell.nameButton.isEnabled = true

        if(tommy123[indexPath.row].location == "comment"){
           //  print("COMMENT COMMENT COMMENT")
            //cell.replypostText.text = tommy123[indexPath.row].caption;
            cell.nameButton.setTitle(tommy123[indexPath.row].usersName, for: .normal)
        cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: tommy123[indexPath.row].imageUrl)
            
        cell.postText.text  = tommy123[indexPath.row].caption
            let height = tommy123[indexPath.row].Spaces * 24;
                       cell.postText.frame.size.height = CGFloat(height);
            
            cell.threedots.setImage(UIImage(named:"reply_icon"), for: .normal)
        //cell.locationButton.setTitle("2 hours ago", for: .normal)
            print("Time end string")
            print( tommy123[indexPath.row].timeEndString);
            cell.locationButton.setTitle(tommy123[indexPath.row].timeEndString, for: .normal)
            cell.userid = tommy123[indexPath.row].displayName;
            var timeStampString: String
        }
        
        
        
       // else if(tommy123[indexPath.row].location == "reply"){
//            cell.locationButton.isHidden = true
//            cell.nameButton.isHidden = true
//            cell.profileImageViewTop.isHidden = true
//
//            cell.postText.isHidden = true
//
//
//            cell.threedots.isHidden = true
//                print("Time end string")
//                print( tommy123[indexPath.row].timeEndString);
//                cell.locationButton.isHidden = true
//            cell.threedots.isHidden =  true
//            cell.replyprofileImageViewTop.isHidden = false
//                   cell.replypostText.isHidden = false
//            cell.replynameButton.isHidden = false
//            cell.replylocationButton.isHidden = false
//
//
//
//            // print("REPLY REPLY REPLY")
//            cell.replynameButton.setTitle(tommy123[indexPath.row].usersName, for: .normal)
//            cell.replyprofileImageViewTop.loadImageUsingCacheWithUrlString(urlString: tommy123[indexPath.row].imageUrl)
//            cell.replypostText.text  = tommy123[indexPath.row].caption
//
//            let height = tommy123[indexPath.row].Spaces * 24;
//            cell.replypostText.frame.size.height = CGFloat(height);
//            var timeStampString: String
//
//           // cell.replylocationButton.titleColor(for: UIColor.lightGray);
//
//            cell.replylocationButton.setTitle(tommy123[indexPath.row].timeEndString, for: .normal)
//
//                    //cell.timeStamp.text = "\(timeStampString) seconds ago"
//                }
        
        
        cell.commentButton.isHidden = true
        cell.likeButton.isHidden = true
        cell.CommentStamp.isHidden = true
        cell.nameButton.isHidden = false
        cell.nameButton.isEnabled = true
        //cell.threedots.setImage(UIImage(named:"reply_icon"), for: .normal)
       // isHidden = true
        cell.replyAct = { sender in
            self.commentArea.text = "@\(cell.nameButton.titleLabel!.text!) "
          //  print("postid")
           // print(self.tommy123[indexPath.row].postID)
           // self.changeid(postid: self.tommy123[indexPath.row].postID)
            replyingToId = self.tommy123[indexPath.row].postID
          //  print(replyingToId)
        }//
            
        
        
       // tableView.delegate = self
        return cell
    }
    
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tommy123[indexPath.row].location == "comment"){
//            let numberoflines = ((tommy123[indexPath.row].caption.count)/37)+1 //
//                   print("post count")
//                 //  print(String(tommy123[indexPath.row].postCount.count))
            
            var height  = tommy123[indexPath.row].Spaces * 24;
                   return (CGFloat(70 + height))//80
        }
        else {
        let numberoflines = ((tommy123[indexPath.row].caption.count)/42)+1 //
        print("post count")
      //  print(String(tommy123[indexPath.row].postCount.count))
          var height  = tommy123[indexPath.row].Spaces * 24;
        return (CGFloat(70 + height))//80
        }
    }

        
      func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
          return true
      }

     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("in here")
        if(tommy123[indexPath.row].displayName == uid){
            print("J")
            
            //let index = indexPath(forRow: indexPath.row, inSection: 0)
            
            print(tommy123[indexPath.row].postID);
            Database.database().reference().child("comments").child(postId).child("comments").child(tommy123[indexPath.row].postID).removeValue { (error, ref) in
                                       if error != nil {
                                           print("error \(error)")
                                       }
            }
            tommy123.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            //tableView.reloadData()
        }
//          if (editingStyle == .delete) {
//            print(indexPath.row)
//               // handle delete (by removing the data from your array and updating the tableview)
//            confirmDelete(postid: indexPath.row)
//          }
      }
        
//return 180
    
    
    func confirmDelete(postid: Int) {
        let alert = UIAlertController(title: "Delete Planet", message: "Are you sure you want to permanently delete this comment?", preferredStyle: .actionSheet)
     
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeletePlanet)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeletePlanet)
    
            alert.addAction(DeleteAction)
            alert.addAction(CancelAction)
    
            // Support display in iPad
            alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
    
        self.present(alert, animated: true, completion: nil)
        }
    func handleDeletePlanet(alertAction: UIAlertAction!) -> Void {
        
//        Database.database().reference().child("comments").child(postId).child().removeValue { (error, ref) in
//              if error != nil {
//                  print("error \(error)")
//              }
//
//
//          }
            }
    
       func cancelDeletePlanet(alertAction: UIAlertAction!) {
          
     }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      print("post size ")
      print(tommy123.count)
        return tommy123.count
        
        // return friendsList.count
    }
    
    
}


extension commeListController: newsCellDelegate {
    func didTapLocationButton(local: String) {
        print("HERE")
        let vc = AnnotationTableViewController()
        vc.spot = local
        let navController = UINavigationController(rootViewController: vc)
        
        present(navController, animated: true, completion: nil)
    }
    
    func didTapProfile(name: String, profilePicture: UIImage, nameid: String){
        print("tappppp prof")
        
        let vc = AccountViewController()
        print(id)
        vc.profilePicture = profilePicture
        vc.name = name
        vc.nameID = nameid
        
        let navController = UINavigationController(rootViewController: vc)
        //
        present(navController, animated: true, completion: nil)
        //        navigationController?.pushViewController(vc, animated: true)
    }
}
