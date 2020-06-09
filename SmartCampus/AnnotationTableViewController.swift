//
//  AnnotationTableViewController.swift
//  SmartCampus
//
//  Created by Tommy Chavez on 4/26/19.
//  Copyright © 2019 Tommy Chavez. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class AnnotationTableViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate{
    let uid = Auth.auth().currentUser?.uid
    var photo = false
    var spot: String?
    var pickedImage: UIImage?
    var postText: String?
    var global = true
    let tableView: UITableView = UITableView(frame: CGRect(x: 0, y: 200, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-200));
    let myTextField: UITextView = UITextView(frame: CGRect(x: 10, y: 100, width: 250, height: 100.00));
    
    
    var posts2 = [Post]()
    let cellId = "PostCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        
  
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<BACK", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.title = spot
        self.view.addSubview(tableView)
        tableView.register(newsCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        
        loadfirst5posts(completion: { message2 in
                       self.loadPost(postidforload: message2,completion: { message, message2 in
                      // print("MINIPOST in closure SIZE")
                       //print( self.miniposts.count)
                       // self.setupCollection()
                    //   self.newCollection.reloadData()
                        self.loadPosterInfo(Message: message2, postid: message)
                       self.loadLikers(Message: message)
                       self.loadLikes(Message: message)
                       self.loadcomments(Message: message)
                       // miniposts.removeAll()
                       // self.loadFriends()
                       self.tableView.reloadData()
                       //print("POST COUNT")
                       //print(self.posts2.count)
                   })
        })
        
        tableView.tableFooterView = UIView()
        //tableView.rowHeight = 450
        
        let rectSpace: UIImageView = UIImageView(frame: CGRect(x: 0, y: 100, width: 400.00, height: 200.00));
       
//        myTextField.borderStyle = UITextField.BorderStyle.roundedRect
//        myTextField.textAlignment = .left
//        myTextField.contentVerticalAlignment = .top
//        myTextField.placeholder = "What would you like to say about \(spot!).."
        myTextField.clipsToBounds = true
        myTextField.layer.cornerRadius = 10
        self.myTextField.layer.borderWidth = 1.0;
        self.myTextField.layer.borderColor = UIColor.black.cgColor
        
        let postButt: UIButton = UIButton(frame: CGRect(x: 280, y: 175, width: 20, height: 20.00));
       // postButt.setTitle("Add Photo", for: .normal
        //)
        let postButt2: UIButton = UIButton(frame: CGRect(x: 265, y: 170, width: 50, height: 30.00));
        postButt.setBackgroundImage(UIImage(named: "camera-1"), for: .normal)
        
        postButt.backgroundColor = UIColor.lightGray
        postButt2.backgroundColor = UIColor.lightGray
        
        POST.setTitle("Share", for: .normal
        )
        POST.setTitleColor(UIColor.black, for: .normal)
        POST.backgroundColor = UIColor.lightGray
         POST2.backgroundColor = UIColor.lightGray
        self.view.addSubview(rectSpace)
        self.view.addSubview(myTextField)
        self.view.addSubview(postButt2)
        self.view.addSubview(postButt)
          self.view.addSubview(POST2)
        self.view.addSubview(POST)
        postButt.addTarget(self, action: #selector(handlePlusPhoto2), for: .touchUpInside)
        postButt2.addTarget(self, action: #selector(handlePlusPhoto2), for: .touchUpInside)
        POST.addTarget(self, action: #selector(handlePost), for: .touchUpInside)
        POST2.addTarget(self, action: #selector(handlePost), for: .touchUpInside)
       
        view.addSubview(textcount)
        textcount.textAlignment = .right
        textcount.text = "0 / 280"
        myTextField.delegate = self
       
        view.addSubview(littlePreview)
        view.addSubview(cancelButton)
        cancelButton.setTitleColor(UIColor.red, for: .normal)
        cancelButton.setTitle("X", for: .normal)
       // littlePreview.backgroundColor = UIColor.blue
         cancelButton.addTarget(self, action: #selector(cancelPost), for: .touchUpInside)
        cancelButton.borderColorV = UIColor.red
        cancelButton.cornerRadiusV =  0.5 * cancelButton.bounds.size.width
        cancelButton.borderWidthV  = 1.0
        cancelButton.isHidden = true
        view.addSubview(placeholdertext)
        placeholdertext.textColor = UIColor.lightGray
        placeholdertext.text = "What would you like to say about \(spot!)"
        placeholdertext.numberOfLines = 0
       // placeholdertext.adjustsFontSizeToFitWidth = true
        view.addSubview(globalButton)
        globalButton.setImage(UIImage(named: "earth"), for: .normal)
        globalButton.addTarget(self, action: #selector(globButt), for: .touchUpInside)
        myTextField.font = .systemFont(ofSize: 15)
        let refreshControl = UIRefreshControl()
         refreshControl.addTarget(self, action:  #selector(refreshit), for: .valueChanged)
         // tableView.addSubview(refreshControl)
        tableView.refreshControl = refreshControl
              AppUtility.lockOrientation(.portrait)
        }
            
            override func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)

                // Don't forget to reset when view is being removed
                AppUtility.lockOrientation(.all)
            }
    
    @objc func refreshit(refreshControl: UIRefreshControl) {
           //print("here")
          // posts.sort { $0.numberoflikes > $1.numberoflikes }
           tableView.reloadData()
           refreshControl.endRefreshing()
       }
    
    
    @objc func cancelPost(){
        
        if(cancelButton.isHidden == false ){
            photo = false
            littlePreview.image = UIImage(named: "whitesquare")
            cancelButton.isHidden = true
        }
    }
    
    @objc func globButt(){
        if(global){
            globalButton.setImage(UIImage(named:"lock"), for: .normal)
            global = false
        }
        else if(global==false){
            globalButton.setImage(UIImage(named:"earth"), for: .normal)
            global = true
            
        }
        
    }
    var textCount = 0
    
    let POST: UIButton = UIButton(frame: CGRect(x: 315, y: 170, width: 50.00, height: 30.00));
    let POST2: UIButton = UIButton(frame: CGRect(x: 365, y: 170, width: 5.00, height: 30.00));
    
     let textcount: UILabel = UILabel(frame: CGRect(x: 275, y: 135, width: 90.00, height: 30.00));
    
     let globalButton: UIButton = UIButton(frame: CGRect(x: 265, y: 135, width: 30, height: 30.00));
    
     let placeholdertext: UILabel = UILabel(frame: CGRect(x: 15, y: 90, width: 220.00, height: 90.00));
    
     let littlePreview: UIImageView = UIImageView(frame: CGRect(x: 295, y: 105, width: 30, height: 30.00));
    
     let cancelButton: UIButton = UIButton(frame: CGRect(x: 335, y: 105, width: 30, height: 30.00));
    
    
    func loadLikes(Message: String){
        //  print("loadlikes")
        //  print(Message)
        // print("loadlikes")
        
        var likedbyme = false
        //        for i in 0...posts.count-1 {
        //         var postid =  posts[i].postID
        var postid =  Message; Database.database().reference().child("posts").child(postid).child("likers").child(self.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any]{
                //print("in closure")
                likedbyme = true
                if let foo = self.posts2.first(where: { $0.postID == Message}){
                    foo.likedby =  true
                }
                else {
                    
                }
                //                    print(likedbyme)
                DispatchQueue.main.async(execute: {
                    //self.tableView.reloadData()
                    //  completion("loadlikes")
                })
                
            }
        })
        
        
        
    }
    
    func  loadfirst5posts(completion: @escaping (_ message2: String) -> Void){
       print("load5postsbaby");
        var counter = 0;
        var actualcounter = 0;
        var nextpost = ""; Database.database().reference().child("LocationPosts").child(spot!).queryLimited(toLast: 5).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
         
        
          // print(postid)
          
          for rest in snapshot.children.allObjects as! [DataSnapshot] {
             
                let postid = rest.key
          if let dict = rest.value as? [String: Any] {
                           let global = dict["global"] as! Bool
                let userid = dict["userid"] as! String
                if(counter == 0){
                 nextpost = postid
                }
            counter = counter + 1;
                    print(postid)
                if global == true || friendsList.contains(userid) || userid == self.uid{
                    actualcounter = actualcounter + 1
           completion(postid)
                }
                    print("we do not need 5 more")
                    print(counter)
                    print(actualcounter)
                    if(counter == 5 && actualcounter < 5){
                        print("we need more!"); self.load5moreposts(actualcounter:actualcounter ,nextpost: nextpost, completion: { message2 in self.loadPostbackwords(actualcounter: actualcounter, postidforload: message2,completion: { message, message2 in
                                     // print("MINIPOST in closure SIZE")
                                      //print( self.miniposts.count)
                                      // self.setupCollection()
                            self.loadPosterInfo(Message: message2, postid: message)
                                      self.loadLikers(Message: message)
                                      self.loadLikes(Message: message)
                                      self.loadcomments(Message: message)
                                      // miniposts.removeAll()
                                      // self.loadFriends()
                                         self.tableView.reloadData()

                                     })
                                     })

                    
                    
                }
            }
        
       }
        })
       
    }
    
    
    
    func loadPostbackwords(actualcounter: Int, postidforload: String, completion: @escaping (_ message: String, _ message2:String ) -> Void){
                
              // var actualcount = actualcounter
           Database.database().reference().child("posts").child(postidforload).observeSingleEvent(of: .value) {(snapshot: DataSnapshot) in
                    //print("HERE")
                    let postid = snapshot.key
                    
                    if let dict = snapshot.value as? [String: Any]{
                        let captionText = dict["caption"] as! String
                        //let captionText = "Caption"
                        let photoURLString = dict["imageUrl"] as! String
                        //backgroundTableCellSize = 400
                        let USERNAME = dict["usersName"] as! String
                        let locationText = dict["location"] as! String
                        let likes = dict["numberoflikes"] as! Int
                        let postcount = dict["charactercount"] as! Int
                        var likedbyme = false
                        let spaces =  dict["numberofspaces"] as! Int
                         let postorevent = dict["postorevent"] as! String
                        //405
                        
                        
                        
                        var likerarray = [User2] ()
                        Database.database().reference().child("posts").child(postid).child("likers").observe(.childAdded) {(snapshot: DataSnapshot) in
                            //print("HERE")
                            if let dict = snapshot.value as? [String: Any]{
                                let usersname = dict["likerName"] as! String
                               
                                let userid = dict["likersid"] as! String
                                let likerurl = ""
                                
                                let liker = User2(profileImageUrl: likerurl, usersName: usersname, usersId: userid)
                                likerarray.append(liker)
                                DispatchQueue.main.async(execute: {
                                    self.tableView.reloadData()
                                })
                                
                            }
                        }
                        
                        let Audio64 = dict["Audio64"] as! String
                        //405
                        let postTime = dict["creationDate"] as! TimeInterval
                        let timeendstring =  dict["EndDateString"] as! String
                        let timestartstring = dict["StartTimeString"] as! String
                         let global = dict["Global"] as! Bool
                        let post = Post(captionText: captionText
                            , photoURLString: photoURLString, USERNAME: USERNAME, locationText: locationText, likes: likes, likedbyme: likedbyme, postid: postid, postcount: postcount, Audio64: Audio64, postTime: postTime,likerArray: likerarray,  likersString: "",numberOfComments: 0, Global: global, postOrEvent: postorevent , timestartstring: timestartstring, timeendstring: timeendstring, displayname: "", profimg: "" , score: 0, spaces: spaces)
                        print(USERNAME )
                       // print("VS")
                       // print(self.nameID)
                     
                            self.posts2.insert(post, at: actualcounter)
                       
                            
                            print("INSIDE")
                           
                            DispatchQueue.main.async(execute: {
                                completion(postid, USERNAME)
                                self.tableView.reloadData()
                            })
                        
                    
                  }
                    
                }
                
            }
       
    
    
    func  load5moreposts(actualcounter: Int,nextpost: String, completion: @escaping (_ message2: String) -> Void){
        print("getting 5 more")
        var actualcounter = actualcounter
        var counter = 0;
        var nextpost2 = "";
       print(nextpost)
        Database.database().reference().child("LocationPosts").child(spot!).queryOrderedByKey().queryEnding(atValue: nextpost).queryLimited(toFirst: 5).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
         
        
          // print(postid)
          
          for rest in snapshot.children.allObjects as! [DataSnapshot] {
          
                let postid = rest.key
          if let dict = rest.value as? [String: Any] {
                            let global = dict["global"] as! Bool
                  nextpost2 = postid
             counter = counter + 1;
                     print(postid)
                  let userid = dict["userid"] as! String
                 if postid != nextpost && (global == true || friendsList.contains(userid) || userid == self.uid){
                     actualcounter = actualcounter + 1
            completion(postid)
                    if(counter == 5 && actualcounter < 5){ self.load5moreposts(actualcounter:actualcounter ,nextpost: nextpost, completion: { message2 in self.loadPost(postidforload: message2,completion: { message, message2 in
                                      // print("MINIPOST in closure SIZE")
                                       //print( self.miniposts.count)
                                       // self.setupCollection()
                                       //self.newCollection.reloadData()
                                       self.loadLikers(Message: message)
                  
                                       self.loadcomments(Message: message)
                                       // miniposts.removeAll()
                                       // self.loadFriends()
                                          self.tableView.reloadData()
                                          
                                      })
                                      })
                     
                     
                    }
                 }
             }
         
        }
        
        })
        
        
    }
    
    var counter = 0
    var doneloadposts = false
       
       func  loadfirst5posts2(completion: @escaping (_ message2: String) -> Void){
                 //print("load5posts");
               counter = 0; Database.database().reference().child("LocationPosts").child(spot!).queryOrderedByKey().queryEnding(atValue: posts2[posts2.count-1].postID).queryLimited(toLast: 5).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
                
               
                 // print(postid)
                 
                 for rest in snapshot.children.allObjects as! [DataSnapshot] {
                      self.counter = self.counter + 1;
                       let postid = rest.key
                 if let dict = rest.value as? [String: Any] {
            
                           let global = dict["global"] as! Bool
                let userid = dict["userid"] as! String
                   
                     completion(postid)
                        
                
                   
                   DispatchQueue.main.async(execute: {
                       if(self.counter == 1){
                           self.doneloadposts  = true;
                       }
                   })
                 }
                }
        })
                 
                  
               }
           
    
    
    func loadPost2(postidforload: String, completion: @escaping (_ message: String,_ message2: String ) -> Void){
           var last_post = posts2[posts2.count-1].postID;
        var lengthcount =  posts2.count; Database.database().reference().child("posts").child(postidforload).observeSingleEvent(of: .value) {(snapshot: DataSnapshot) in
            //print("HERE")
            let postid = snapshot.key
            
            if let dict = snapshot.value as? [String: Any]{
                let captionText = dict["caption"] as! String
                //let captionText = "Caption"
                let photoURLString = dict["imageUrl"] as! String
                //backgroundTableCellSize = 400
                let USERNAME = dict["usersName"] as! String
                let locationText = dict["location"] as! String
                let likes = dict["numberoflikes"] as! Int
                let postcount = dict["charactercount"] as! Int
                var likedbyme = false
                let spaces =  dict["numberofspaces"] as! Int
                 let postorevent = dict["postorevent"] as! String
                //405
                
                
                
                var likerarray = [User2] ()
                Database.database().reference().child("posts").child(postid).child("likers").observe(.childAdded) {(snapshot: DataSnapshot) in
                    //print("HERE")
                    if let dict = snapshot.value as? [String: Any]{
                        let usersname = dict["likerName"] as! String
                       
                        let userid = dict["likersid"] as! String
                        let likerurl = ""
                        
                        let liker = User2(profileImageUrl: likerurl, usersName: usersname, usersId: userid)
                        likerarray.append(liker)
                        DispatchQueue.main.async(execute: {
                            self.tableView.reloadData()
                        })
                        
                    }
                }
                
                let Audio64 = dict["Audio64"] as! String
                //405
                let postTime = dict["creationDate"] as! TimeInterval
                let timeendstring =  dict["EndDateString"] as! String
                let timestartstring = dict["StartTimeString"] as! String
                 let global = dict["Global"] as! Bool
                let post = Post(captionText: captionText
                    , photoURLString: photoURLString, USERNAME: USERNAME, locationText: locationText, likes: likes, likedbyme: likedbyme, postid: postid, postcount: postcount, Audio64: Audio64, postTime: postTime,likerArray: likerarray,  likersString: "",numberOfComments: 0, Global: true, postOrEvent: postorevent , timestartstring: timestartstring, timeendstring: timeendstring, displayname: "", profimg: "" , score: 0, spaces: spaces)
                print(USERNAME )
                print("VS")
                //print(self.nameID)
                  if global == true || friendsList.contains(USERNAME) || USERNAME == self.uid{
                 if(last_post != postid){
                self.posts2.insert(post, at: lengthcount)
                    
                    print("INSIDE")
                     
                }
                    DispatchQueue.main.async(execute: {
                        completion(postid, USERNAME)
                        self.tableView.reloadData()
                    })
                
            }
            }
        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

            print("bottom");
            // UITableView only moves in one direction, y axis
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
          
            // Change 10.0 to adjust the distance from bottom
           
            
            if maximumOffset - currentOffset <= 10.0 {
               if(doneloadposts==false){
            loadfirst5posts2(completion: { message2 in
                self.loadPost2(postidforload: message2,completion: { message, message2 in
               // print("MINIPOST in closure SIZE")
                //print( self.miniposts.count)
                // self.setupCollection()
                    self.loadPosterInfo(Message: message2, postid: message)
                self.loadLikers(Message: message)
                self.loadLikes(Message: message)
                self.loadcomments(Message: message)
                // miniposts.removeAll()
                // self.loadFriends()
                self.tableView.reloadData()
                //print("POST COUNT")
                //print(self.posts2.count)
            })
            })

                }
                }
                }//if segmented ==0
    
    
    func loadLikers(Message: String){
        // print("LOADLIKERS")
        //print(posts.count)
        var likerarray = [User2]()
        var likersstring = "";
        
        print("adding string likers")
        var postid =  Message
        
        print(postid); Database.database().reference().child("posts").child(postid).child("likers").observe(.childAdded) {( snapshot: DataSnapshot) in
            // print("HERE")
            // var likerarray = [User2]()
            if let dict = snapshot.value as? [String: Any]{
                print(snapshot)
                let usersname = dict["likerName"] as! String
                // print(usersname)
                let userid = dict["likersid"] as! String
                let likerurl = ""
                
                let liker = User2(profileImageUrl: likerurl, usersName: usersname, usersId: userid)
                //print(liker)
                likerarray.append(liker)
                //print("liker size in closure")
                // print(likerarray.count)
                
                DispatchQueue.main.async(execute: {
                    
                })
                
            }
            if let foo = self.posts2.first(where: { $0.postID == Message}){
                
                
                
                let total_count = likerarray.count
                var likersstring = ""
                if(total_count  == 0){
                    print("size is 0")
                    foo.likersstring = ""
                }
                else  if(total_count == 1){
                    print("size =1")
                    likersstring =  "\(likerarray[total_count-1].usersname) liked the post"
                    print(likersstring)
                    foo.likersstring = likersstring
                    print("size = 1")
                    
                }
                else if(total_count == 2){
                    likersstring =  "\(likerarray[total_count-2].usersname) and \(likerarray[total_count-1].usersname) liked the post"
                    print("size =2")
                    print(likersstring)
                    
                    foo.likersstring = likersstring
                }
                    
                else if(total_count > 2){
                    likersstring =  "\(likerarray[total_count-2].usersname) and \(likerarray[total_count-1].usersname) and \(total_count - 2) others liked the post"
                    print("size =3")
                    print(likersstring)
                    foo.likersstring = likersstring
                }
            }
            else {
                print("error")
                
                
            }
            
        }
        
        print("liker size")
        print(likerarray.count)
        
        
        
    }
    
   var firstimer = true
    func loadcomments(Message: String){
        let postid = Message
        Database.database().reference().child("comments").child( postid).observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot.value ?? "")
            let dict = snapshot.value as? [String: Any]
            //print(snapshot)
            // print(snapshot.value)
            //print("snapshot")
            //print(snapshot.key)
            let commentnum = dict?[ "commentnum"] as! Int
           // print("Number of comments!")
            //print(commentnum)
            if let foo = self.posts2.first(where: { $0.postID == Message}){
                foo.numberofcomments = commentnum
                }
          
            //  print(commentnum)
            
            DispatchQueue.main.async(execute: {
                if(self.firstimer==true ){
                   // popposts = posts;
               
                self.tableView.reloadData()
                
                    self.firstimer=false;
                }
                //  completion("loadlikes")
            })
            
        })
        
    }
    
    
     func loadPosterInfo(Message: String, postid: String ){
           // print(postid)
            Database.database().reference().child("users").child(Message).observeSingleEvent(of: .value, with: { (snapshot) in
                //print(snapshot.value ?? "")
               
                
                let dictionary = snapshot.value as? [String: Any]
                let username = dictionary?[ "username"] as? String
                
                guard let profileimageURL = dictionary?[ "ProfileImage"] as? String else {return}
                //print(username)
                //print(profileimageURL);
                if let foo = self.posts2.first(where: { $0.postID == postid}){
                    //print("HERE")
                    foo.displayName = username!;
                   
                    foo.profImg = profileimageURL;
                    
                    
//                    DispatchQueue.main.async(execute: {
//
//                            self.tableView.reloadData()
//
//
//                    })
                }
            })
            
        }
        
    
    func loadLikers2(Message: String, completion: @escaping (_ message: String) -> Void){
        // print("LOADLIKERS")
        //print(posts.count)
        var likerarray = [User2]()
        var likersstring = "";
        
        print("adding string likers")
        var postid =  Message
        
        print(postid); Database.database().reference().child("posts").child(postid).child("likers").observe(.childAdded) {( snapshot: DataSnapshot) in
            // print("HERE")
            // var likerarray = [User2]()
            if let dict = snapshot.value as? [String: Any]{
                print(snapshot)
                let usersname = dict["likerName"] as! String
                // print(usersname)
                let userid = dict["likersid"] as! String
                let likerurl = ""
                
                let liker = User2(profileImageUrl: likerurl, usersName: usersname, usersId: userid)
                //print(liker)
                likerarray.append(liker)
                //print("liker size in closure")
                // print(likerarray.count)
                
                DispatchQueue.main.async(execute: {
                    
                })
                
            }
            if let foo = self.posts2.first(where: { $0.postID == Message}){
                
                
                
                let total_count = likerarray.count
                var likersstring = ""
                if(total_count  == 0){
                    likersstring =  ""
                    print(likersstring)
                    foo.likersstring = likersstring
                    print("size = 0")
                    completion("done")
                    
                }
                else  if(total_count == 1){
                    print("size =1")
                    likersstring =  "\(likerarray[total_count-1].usersname) liked the post"
                    print(likersstring)
                    foo.likersstring = likersstring
                    print("size = 1")
                    completion("done")
                    
                }
                else if(total_count == 2){
                    likersstring =  "\(likerarray[total_count-2].usersname) and \(likerarray[total_count-1].usersname) liked the post"
                    print("size =2")
                    print(likersstring)
                    
                    foo.likersstring = likersstring
                    completion("done")
                }
                    
                else if(total_count > 2){
                    likersstring =  "\(likerarray[total_count-2].usersname) and \(likerarray[total_count-1].usersname) and \(total_count - 2) others liked the post"
                    print("size =3")
                    print(likersstring)
                    foo.likersstring = likersstring
                    completion("done")
                }
            }
            else {
                print("error")
                
                
            }
            
        }
        
        print("liker size")
        print(likerarray.count)
        
        if let foo = posts2.first(where: { $0.postID == Message}){
            
            
            
            let total_count = likerarray.count
            var likersstring = ""
            if(total_count  == 0){
                likersstring =  ""
                print(likersstring)
                foo.likersstring = likersstring
                print("size = 0")
                completion("done")
                
            }
            
        }
        
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        textCount = numberOfChars
        
        
        textcount.text = "\(numberOfChars) /280"
        
        if(textCount > 0){
            placeholdertext.text = ""
        }
        if(textCount == 0){
            placeholdertext.text = "What would you like to say about \(spot!)"
        }
        return numberOfChars < 280    // 10 Limit Value
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func handleCancel() {
       // dismiss(animated: true, completion: nil)
        _ = navigationController?.popViewController(animated: true)
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
    
    @objc func handlePost() {
        POST.isEnabled = false
            print("post")
            
            
            if(photo == false) {
                saveToDatabaseWithNoMedia()
            }
            else {
            guard let caption = myTextField.text, !caption.isEmpty else { return }
            
            // guard let locationText = locationTextField.text, !locationText.isEmpty else { return }
            let locationText = spot
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
         var audioString = "noaudio"
        
        fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
            guard let postImage = pickedImage else { return }
            guard let caption = myTextField.text else { return }
            // guard let locationText = locationTextField.text, !locationText.isEmpty else { return }
            let locationText = spot
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            
            
            
            
            print(caption)
            // guard let uid = Auth.auth().currentUser?.uid else { return }
            
            // let userPostRef = Database.database().reference().child("posts").child(uid)
            let userPostRef = Database.database().reference().child("posts")
            //let ref = userPostRef

            let commentPostRef = Database.database().reference().child("comments")
            // let ref = userPostRef.childByAutoId()
            let new_date = Int(Date().timeIntervalSince1970 * 100000.0)
            
            let ref = userPostRef.child(String(new_date))
            let newref = commentPostRef.child(String(new_date))
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
            
            
            
            
            let values = ["imageUrl": imageUrl, "caption": caption,
                          "location": locationText,"imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "usersName": uid, "creationDate": Date().timeIntervalSince1970, "numberoflikes":0,"likes": "", "charactercount": textCount , "Audio64": audioString, "Global": global, "postorevent": "post" , "EndDateString": "","StartTimeString": ""] as [String : Any]
            //Date().timeIntervalSince1970,
            ref.updateChildValues(values) { (err, ref) in
                if let err = err {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Failed to save post to DB", err)
                    return
                }
                
                 //ref.child("likes").updateChildValues(["123": "like"])
                 // ref.child("likes").updateChildValues(["124": "like"])
                
              self.POST.isEnabled = true
                           self.myTextField.text = ""
                           self.textCount = 0;
                           self.textcount.text = "0 / 280"
                self.placeholdertext.text = "What would you like to say about \(self.spot!)"
                           self.photo = false
                           self.view.endEditing(true)
                self.littlePreview.image = UIImage(named: "whitesquare")
                self.cancelButton.isHidden = true
                
                
                print("Successfully saved post to DB")
             //   self.dismiss(animated: true, completion: nil)
            }
            self.tabBarController!.selectedIndex = selectedIndex ?? 0
            
        }
        
        
        
        fileprivate func saveToDatabaseWithNoMedia() {
            //guard let postImage = pickedImage else { return }
            guard let caption = myTextField.text else { return }
            // guard let locationText = locationTextField.text, !locationText.isEmpty else { return }
            let locationText = spot
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            print(caption)

            let userPostRef = Database.database().reference().child("posts")
            let commentPostRef = Database.database().reference().child("comments")
          // let ref = userPostRef.childByAutoId()
            let new_date = Int(Date().timeIntervalSince1970 * 100000.0)
            
            let ref = userPostRef.child(String(new_date))
            let newref = commentPostRef.child(String(new_date))
            print()
            
           
            let values = ["imageUrl": "noImage", "caption": caption,
                          "location": locationText,"imageWidth": 0, "imageHeight": 0, "usersName": uid, "creationDate": Date().timeIntervalSince1970, "numberoflikes":0,"likes": "", "charactercount": textCount , "Audio64": audioString, "Global": global, "postorevent": "post" , "EndDateString": "","StartTimeString": ""] as [String : Any]
            
            let newvalues = ["commentnum": 0, "creationDate": Date().timeIntervalSince1970] as [String : Any]
            newref.updateChildValues(newvalues) { (err, ref) in
                if let err = err {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Failed to save post to DB", err)
                    return
                }
                
                
                print("Successfully saved post to DB")
                self.POST.isEnabled = true
                self.myTextField.text = ""
                self.textCount = 0;
                self.textcount.text = "0 / 280"
                self.placeholdertext.text = "What would you like to say about \(self.spot!)"
                self.photo = false
                self.view.endEditing(true)
                self.littlePreview.image = UIImage(named: "whitesquare")
                self.cancelButton.isHidden = true
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
            self.tabBarController!.selectedIndex = selectedIndex ?? 0
            
        }
        
    
    
    
    
    func loadPost(postidforload: String, completion: @escaping (_ message: String,_ message2: String) -> Void){
       
       Database.database().reference().child("posts").child(postidforload).observeSingleEvent(of: .value) {(snapshot: DataSnapshot) in
           //print("HERE")
           let postid = snapshot.key
           
           if let dict = snapshot.value as? [String: Any]{
               let captionText = dict["caption"] as! String
               //let captionText = "Caption"
               let photoURLString = dict["imageUrl"] as! String
               //backgroundTableCellSize = 400
               let USERNAME = dict["usersName"] as! String
               let locationText = dict["location"] as! String
               let likes = dict["numberoflikes"] as! Int
               let postcount = dict["charactercount"] as! Int
               var likedbyme = false
               let spaces =  dict["numberofspaces"] as! Int
                let postorevent = dict["postorevent"] as! String
               //405
               
               
               
               var likerarray = [User2] ()
               Database.database().reference().child("posts").child(postid).child("likers").observe(.childAdded) {(snapshot: DataSnapshot) in
                   //print("HERE")
                   if let dict = snapshot.value as? [String: Any]{
                       let usersname = dict["likerName"] as! String
                      
                       let userid = dict["likersid"] as! String
                       let likerurl = ""
                       
                       let liker = User2(profileImageUrl: likerurl, usersName: usersname, usersId: userid)
                       likerarray.append(liker)
                       DispatchQueue.main.async(execute: {
                           self.tableView.reloadData()
                       })
                       
                   }
               }
               
               let Audio64 = dict["Audio64"] as! String
               //405
               let postTime = dict["creationDate"] as! TimeInterval
               let timeendstring =  dict["EndDateString"] as! String
               let timestartstring = dict["StartTimeString"] as! String
                let global = dict["Global"] as! Bool
               let post = Post(captionText: captionText
                   , photoURLString: photoURLString, USERNAME: USERNAME, locationText: locationText, likes: likes, likedbyme: likedbyme, postid: postid, postcount: postcount, Audio64: Audio64, postTime: postTime,likerArray: likerarray,  likersString: "",numberOfComments: 0, Global: global, postOrEvent: postorevent , timestartstring: timestartstring, timeendstring: timeendstring, displayname: "", profimg: "" , score: 0, spaces: spaces)
               print(USERNAME )
               print("VS")
               //print(self.nameID)
            // if( (global == false )  || global == true  ){
                   self.posts2.insert(post, at: 0 )
//                   if(photoURLString != "noImage"){
//                      // self.miniposts.insert(photoURLString, at: 0)
//                   }
                   print("INSIDE")
                 
                     //  self.miniposts.count)
                   DispatchQueue.main.async(execute: {
                       completion(postid, USERNAME)
                       self.tableView.reloadData()
                   })
               
         //  }
         }
           
       }
       
   }
    
}



extension AnnotationTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView( _ tableView:UITableView, numberOfRowsInSection section: Int)-> Int {
        print("post size")
        print(posts2.count)
        return posts2.count
        
    }//how many cells
    
    
    
    func tableView(  _ tableView: UITableView, heightForRowAt indexPath: IndexPath)->CGFloat{
        
        if(posts2[indexPath.row].postorevent == "post"){
            let imageyesorno = posts2[indexPath.row].imageUrl
            let numberoflines = ((posts2[indexPath.row].postCount)/42)+1 // %42
            //let audioyesorno =f posts2[indexPath.row].audio64
            let audioyesorno = "noaudio"
            var height = numberoflines * 24
            
            if(audioyesorno != "noaudio"){
                height = height + 80
            }
            
            if(imageyesorno == "noImage") {
                
                
                return (CGFloat(120 + height))//80
            }
            //return (CGFloat(380 + height))
            return (CGFloat(420 + height))
            
        }
            
        else if (posts2[indexPath.row].postorevent == "event"){
            return 180
        }
        return 180
    }
    
    
    func tableView(  _ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! newsCell
        //  cell.backgroundColor = UIColor.gray
        cell.globalButton2.isHidden = true
                               cell.replypostText.isHidden = true
                               cell.globalButton2.isHidden = true
                                   cell.threedots2.isHidden = true
                       cell.postImage2.isHidden = true
       cell.cellID = posts2[indexPath.row].postID
                cell.userid = posts2[indexPath.row].usersName;
                
                 
                cell.globalButton2.isHidden = true
                
                 let toId = posts2[indexPath.row].usersName
                    cell.globalButton.isHidden = false
                 let isGlobal = posts2[indexPath.row].global
                    if(isGlobal==true){
                        cell.globalButton.setImage(UIImage(named:"earth"), for: .normal)
                    }
                    else if(isGlobal==false){
                        cell.globalButton.setImage(UIImage(named:"lock"), for: .normal)
                        
                    }
                 cell.CommentStamp.text = String(posts2[indexPath.row].numberofcomments)
                 cell.likerstring.text = posts2[indexPath.row].likersstring
                if(posts2[indexPath.row].likedby == true){
                    let heartFilled = UIImage(named: "heartfilled")
                    cell.likeButton.setImage(heartFilled, for: .normal)
                }//close if
                if(posts2[indexPath.row].likedby == false){
                    let heartEmpty = UIImage(named: "heartempty")
                    cell.likeButton.setImage(heartEmpty, for: .normal)
                }//close if
                
              if(posts2[indexPath.row].postorevent == "post"){
            //    print(posts2[indexPath.row].postorevent )
                cell.postText.font = .systemFont(ofSize: 15)
                cell.postText.text = posts2[indexPath.row].caption
              cell.descriptionButt.isHidden = true
                
        cell.likeLabel.text = String(posts2[indexPath.row].numberoflikes)
                //print(indexPath.row)
                let backgroundView = UIView()
                backgroundView.backgroundColor = UIColor.white
                cell.selectedBackgroundView = backgroundView
               
              
               
                
                 cell.timeStamp.isHidden =  false
                cell.DateStamp.isHidden =  true
                cell.DateStamp2.isHidden = true
              cell.threedots.isHidden =  false
                cell.postImage.isHidden = false
                cell.threedots2.isHidden = true
                var timeStampString: String = findStringOfTime(newDate: Int(posts2[indexPath.row].posttime))
               
                
                        cell.timeStamp.text = timeStampString
                
                    
                
                
               // print(posts2[indexPath.row].postID)
          //cell.CommentStamp.text = posts2[indexPath.row].
                
                
                
               
                if( posts2[indexPath.row].likedby == true){
                  
                    let heartFilled = UIImage(named: "heartfilled")
                    cell.likeButton.setImage(heartFilled, for: .normal)
                }//close if
            
                
                let ref = Database.database().reference().child("users").child(toId)
                Database.database().reference().child("users").child(toId).observeSingleEvent(of: .value, with: { (snapshot) in
                    //print(snapshot.value ?? "")
                    
                    let dictionary = snapshot.value as? [String: Any]
                    let username = dictionary?[ "username"] as? String
                    
                    guard let profileimageURL = dictionary?[ "ProfileImage"] as? String else {return}
                   
                    
                    //cell.nameButton.setTitle(username, for: .normal)
                  // cell.cellID = toId 8/12/2019
                    //cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: profileimageURL)
                    cell.nameButton.setTitle(self.posts2[indexPath.row].displayName, for: .normal)
                    // cell.cellID = toId
                    cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: self.posts2[indexPath.row].profImg)
                    let numberoflines = ((self.posts2[indexPath.row].postCount)/42)+1 // %42
                    
                   let height = numberoflines * 24
                

                    
                    //cell.postText.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
                    
                    cell.postText.frame.size.height = CGFloat(height) //https://stackoverflow.com/questions/38391528/how-to-set-dynamic-label-size-in-uitableviewcell
                    cell.postText.text = self.posts2[indexPath.row].caption
                    var local2    = (self.posts2[indexPath.row].location)
                     local2 = "@\(local2)"
                    cell.locationButton.setTitle(local2, for: .normal)
                   
                    
                   //cell.songid =  posts2[indexPath.row].audio64;
                   
                    
                    
                    //cell.likeLabel.text = String( posts2[indexPath.row].numberoflikes)
                    let url = self.posts2[indexPath.row].imageUrl
                    cell.postImage.loadImageUsingCacheWithUrlString(urlString: url)
                    //cell.likeLabel.text = String(posts2[indexPath.row].numberoflikes)
                    cell.delegate = self //ADDED
                    
        //            DispatchQueue.main.async(execute: {
        //                                                                    self.tableView.reloadData()
        //                                                                })
                    
                    
                  
                    
                    
                    
                    
                    
                    cell.commentAct = { sender in
                        
                        let vc = commeListController()
                        vc.postId = self.posts2[indexPath.row].postID
                        vc.posterid = self.posts2[indexPath.row].usersName
                    
                        self.navigationController?.pushViewController(vc, animated: true)

                    }//close comment act

                    
                })
                
                }
                 if(posts2[indexPath.row].postorevent == "event"){
                    //cell.nameButton.setTitle(posts2[indexPath.row].posterUsername, for: .normal)
                    cell.timeStamp.isHidden =  true
                    cell.DateStamp.isHidden =  false
                    cell.DateStamp2.isHidden = false
                    cell.threedots.isHidden = true
                    cell.threedots2.isHidden =  false
                    cell.globalButton.isHidden = true
                    cell.globalButton2.isHidden =  false
                    let isGlobal = posts2[indexPath.row].global
                    if(isGlobal==true){
                        cell.globalButton2.setImage(UIImage(named:"earth"), for: .normal)
                    }
                    else if(isGlobal==false){
                        cell.globalButton2.setImage(UIImage(named:"lock"), for: .normal)
                        
                    }
                    
                    
                    cell.DateStamp.text = (posts2[indexPath.row].timeStartString)
                    cell.DateStamp2.text = (posts2[indexPath.row].timeEndString)
                    
                    cell.locationButton.setTitle("@\(posts2[indexPath.row].location)", for: .normal)
                    cell.postText.font = .boldSystemFont(ofSize: 20)
                    cell.postText.text = posts2[indexPath.row].caption
                   
                    cell.descriptionButt.isHidden = false;
                    let numberoflines = ((posts2[indexPath.row].postCount)/42)+1 // %42
                    
                    let height = numberoflines * 24
                    
                    
                    
                    

                    cell.descriptionButt.frame.size.height = CGFloat(height);
                    cell.descriptionButt.text=posts2[indexPath.row].audio64;
                    
                    
        //            let ref = Database.database().reference().child("users").child(toId)
        //            Database.database().reference().child("users").child(toId).observeSingleEvent(of: .value, with: { (snapshot) in
        //                //print(snapshot.value ?? "")
        //
        //                let dictionary = snapshot.value as? [String: Any]
        //                let username = dictionary?[ "username"] as? String
        //
        //                guard let profileimageURL = dictionary?[ "ProfileImage"] as? String else {return}
                    
                        
                        cell.nameButton.setTitle(posts2[indexPath.row].displayName, for: .normal)
                       // cell.cellID = toId
                    cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: posts2[indexPath.row].profImg)
                        
                      
                          cell.timeStamp.isHidden =  true
                        cell.postImage.isHidden = true

                        
                   // })
                    
               }
                
                
                cell.buttonAct = { sender in
                    var useridpluspostid = ""
                    var name = cell.userid
                    useridpluspostid = "\(self.uid!)\(cell.cellID)";
                    if( self.posts2[indexPath.row].likedby == false){
                       
                    
                        let noti = ["Notification Type": "Like","ID Number": cell.cellID,"Userid":self.uid! ] as [String : Any]
                       
                        let new_date = Int(Date().timeIntervalSince1970 * 100000.0)
                        Database.database().reference().child("users").child(cell.userid!).child("notifications").child(String(new_date)).child(useridpluspostid).updateChildValues(noti);
                        self.posts2[indexPath.row].likedby = true
                        let heartFilled = UIImage(named: "heartfilled")
                        cell.likeButton.setImage(heartFilled, for: .normal)
                        var liked = self.posts2[indexPath.row].numberoflikes
                        liked =  liked  + 1
                        self.posts2[indexPath.row].numberoflikes = liked
                        //                 print(liked)
                        //                    ref.child("numberoflikes").setValue(1)
                        let newValues = ["likerName":usersShowName!, "likersid": self.uid!] as [String : Any]
                        Database.database().reference().child("posts").child(self.posts2[indexPath.row].postID).updateChildValues(["numberoflikes": liked])
                        cell.likeLabel.text = String(liked);
                        Database.database().reference().child("posts").child(self.posts2[indexPath.row].postID).child("likers").child(self.uid!).updateChildValues(newValues)
                        
                        // cell.likeLabel.text = String(liked)
                        //
                       // print("liked")
                        self.loadLikers2( Message: self.posts2[indexPath.row].postID, completion: { message in
                            
                           // print("in here")
                            cell.likerstring.text = self.posts2[indexPath.row].likersstring
                        })
                        
                    }
                    else if( self.posts2[indexPath.row].likedby == true){
                        self.posts2[indexPath.row].likedby = false
                        let heartFilled = UIImage(named: "heartempty")
                        Database.database().reference().child("users").child(self.posts2[indexPath.row].usersName).child("notifications").observe(.childAdded, with: { (snapshot) in
                          //  print("true")
                            
                            let postid2 = snapshot.key
                            Database.database().reference().child("users").child(self.posts2[indexPath.row].usersName).child("notifications").child(postid2).observe(.childAdded, with: {
                                (snapshot) in
                                
                                let postid3 = snapshot.key
                                if(postid3 == useridpluspostid){
                                    Database.database().reference().child("users").child(self.posts2[indexPath.row].usersName).child("notifications").child(postid2).child(postid3).removeValue()
                                }
                                DispatchQueue.main.async(execute: {
                                
                                
                                })
                            })
                        })
                    
                        
                        
                        
                        
                        cell.likeButton.setImage(heartFilled, for: .normal)
                        var liked = self.posts2[indexPath.row].numberoflikes
                        liked =  liked-1;
                        self.posts2[indexPath.row].numberoflikes = liked
                        Database.database().reference().child("posts").child(self.posts2[indexPath.row].postID).updateChildValues(["numberoflikes": liked])
                        Database.database().reference().child("posts").child(self.posts2[indexPath.row].postID).child("likers").child(self.uid!).removeValue()
                        
                        cell.likeLabel.text = String(liked);
                        
                        
                        self.loadLikers2( Message: self.posts2[indexPath.row].postID, completion: { message in
                            print("in here")
                            cell.likerstring.text = self.posts2[indexPath.row].likersstring
                        })
                        
                        
                        
                        
                    }
                    
                    
                }//close buttonAct
        
        
        return cell;
    }
}

extension AnnotationTableViewController: newsCellDelegate {
    func didTapLocationButton(local: String) {
        print("HERE")
        let vc = AnnotationTableViewController()
        vc.spot = local
        let navController = UINavigationController(rootViewController: vc)
        
        present(navController, animated: true, completion: nil)
    }
    
    func didTapProfile(name: String, profilePicture: UIImage, nameid: String){
        
        
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
