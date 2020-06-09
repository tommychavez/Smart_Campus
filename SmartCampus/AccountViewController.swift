//
//  AccountViewController.swift
//  SmartCampus
//
//  Created by Tommy Chavez on 5/2/19.
//  Copyright © 2019 Tommy Chavez. All rights reserved.
//


import UIKit
import Firebase
//import FirebaseDatabase



class AccountViewController: UIViewController, UITableViewDelegate {
     var posts2 = [Post]()
            var miniposts = [String]()
            var name: String?
            var nameID: String?
            var profilePicture = UIImage(named:"unknown")
            
           // @IBOutlet weak var tableheight: NSLayoutConstraint!
            
            
            
             //var heightConstraint: NSLayoutConstraint?
           
            
            let tableView: UITableView = UITableView(frame: CGRect(x: 0, y: 339, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 339));

            // let tableView = UITableView()
            let newCollection: UICollectionView = {
                let layout = UICollectionViewFlowLayout()
                let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
                
                collection.backgroundColor = UIColor.white
                collection.translatesAutoresizingMaskIntoConstraints = false
                // collection.isScrollEnabled = true
                return collection
            }()
            
            let uid = Auth.auth().currentUser?.uid
            
            
            let cellId = "PostCell"
            
            let cellId2 = "cellId";
            
                
          
            

            
           // @objc func onDidReceiveData(_ notification:Notification) {
                // Do something now
         //   }
            var profileImageViewTop: UIImageView = {
                let imageView: UIImageView = UIImageView(frame: CGRect(x: -10, y: 100, width: 100.00, height: 100.00));
                //   let imageView = UIImageView()
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.layer.masksToBounds = true
                imageView.layer.cornerRadius = 24
                imageView.contentMode = .scaleAspectFill
                return imageView
            }()
            
            var numberoffriends = 0
            
            // @IBOutlet weak var dropdownheight: NSLayoutConstraint!
            
            let friendButton: UIButton = {
                let nameImage: UIButton = UIButton(frame: CGRect(x: 125, y: 110, width: 120.00, height: 35));
                // let nameImage = UIButton()
                nameImage.translatesAutoresizingMaskIntoConstraints = false
                nameImage.layer.masksToBounds = true
                nameImage.backgroundColor = UIColor.blue
                
                nameImage.contentMode = .scaleAspectFill
                nameImage.setTitleColor( UIColor.white, for: .normal )
                // nameImage.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
                //nameImage.titleLabel?.numberOfLines = 2
                nameImage.titleLabel?.text = "0 Friends"
                nameImage.titleLabel?.lineBreakMode = .byWordWrapping
                // nameImage.contentHorizontalAlignment = .left
                //   nameImage.setTitle("\(numberoffriends) Friends", for: .normal)
                //  buttonView.backgroundColor = UIColor.blue
                return nameImage
            }()
            

            
            
            let editprof: UIButton = {
                let nameImage: UIButton = UIButton(frame: CGRect(x: 125, y: 110, width: 120.00, height: 35));
                
                nameImage.translatesAutoresizingMaskIntoConstraints = false
                nameImage.layer.masksToBounds = true
                
                nameImage.contentMode = .scaleAspectFill
                nameImage.setTitleColor( UIColor.black, for: .normal )
                
                nameImage.titleLabel?.text = "Edit Profile"
                nameImage.titleLabel?.lineBreakMode = .byWordWrapping
            
                return nameImage
            }()
            
            
            let AddFriendButton: UIButton = {
                let nameImage: UIButton = UIButton(frame: CGRect(x: 10, y: 180, width: 80, height: 20));
                // let nameImage = UIButton()
                nameImage.translatesAutoresizingMaskIntoConstraints = false
                nameImage.layer.masksToBounds = true
                // nameImage.backgroundColor = UIColor.yellow
                nameImage.contentMode = .scaleAspectFill
               // nameImage.setTitleColor( UIColor.black, for: .normal )
                nameImage.backgroundColor = UIColor.green
                
               // nameImage.titleLabel?.adjustsFontSizeToFitWidth = true
               // nameImage.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
                //nameImage.contentHorizontalAlignment = .left
                
                //nameImage.setTitleShadowColor(UIColor.white, for: .normal)
                //nameImage.titleLabel?.shadowOffset = CGSize(width: 2, height: 2)
                nameImage.setTitle("Add Friend", for: .normal)
                // buttonView.backgroundColor = UIColor.blue
                return nameImage
            }()
            
            let locationFavButton: UIButton = {
                let nameImage: UIButton = UIButton(frame: CGRect(x: 125, y: 150, width: 120.00, height: 35));
                // let nameImage = UIButton()
                nameImage.translatesAutoresizingMaskIntoConstraints = false
                nameImage.layer.masksToBounds = true
                nameImage.backgroundColor = UIColor.purple
                nameImage.contentMode = .scaleAspectFill
                nameImage.setTitleColor( UIColor.white, for: .normal )
                // nameImage.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
                // nameImage.titleLabel?.numberOfLines = 2
                //nameImage.titleLabel?.lineBreakMode = .byWordWrapping
                // nameImage.contentHorizontalAlignment = .left
                nameImage.setTitle("10 Locations", for: .normal)
                //  buttonView.backgroundColor = UIColor.blue
                return nameImage
            }()
            

            
            
            @IBAction func logOutAct(_ sender: Any) {
                do{
                    try Auth.auth().signOut();
                }catch{
                    print("Error while signing out!")
                }
            }
            
           // @IBOutlet weak var editprofile: UIButton!
            
           // @IBOutlet weak var infobutt: UIButton!
            
          //  @IBOutlet weak var logoutButt: UIButton!
            
    //        @objc func methodOfReceivedNotification(notification: Notification) {
    //           // setupCollection()
    //            checkbio();
    //            //addprof();
    //            if(addedPicture == true ){
    //                profileImageViewTop.image = profilePhotoEdit!
    //                 tableView.reloadData()
    //               // profileImageViewTop.s
    //            }
    //             //tableheight.constant = 0
    //
    //        }
    var friends = false;
            override func viewDidLoad() {
                
                super.viewDidLoad()
                
                Database.database().reference().child("users").child(nameID!).child("friendRequests").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists(){
                     
                    self.AddFriendButton.setTitle("Pending", for: .normal)
                    
                    self.AddFriendButton.backgroundColor = UIColor.orange
                    
                    self.AddFriendButton.isEnabled = false
                  
                    
                    }
                })
                   
                
               addprof();
                let image = UIImage(named: "new_message_icon")
                //navigationItem.title = "MESSAGES"
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleMessage))
               
                
                posts2.removeAll()
                miniposts.removeAll()
                //var myProfilePicture: String?
                self.view.backgroundColor = .white
               
               
                //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SETTINGS", style: .plain, target: self, action: #selector(handleMessage))
                
                navigationItem.title = name
                self.view.addSubview(tableView)
                
                       
                tableView.register(newsCell.self, forCellReuseIdentifier: cellId)
                tableView.dataSource = self
                tableView.delegate = self
                print("userid")
                print(nameID)
                print("friendlist")
                for element in friendsList {
                    print(element)
                }
                if friendsList.contains(nameID!) || nameID == uid {
                    print("friends")
                    friends = true
                    self.AddFriendButton.setTitle("Remove Friend ", for: .normal)
                    self.AddFriendButton.titleLabel!.adjustsFontSizeToFitWidth = true
                    
                    self.AddFriendButton.backgroundColor = UIColor.red
                   // AddFriendButton.isHidden = true
                    
             loadfirst5posts(completion: { message2 in
                 self.loadPost(postidforload: message2,completion: { message in
                // print("MINIPOST in closure SIZE")
                 //print( self.miniposts.count)
                 // self.setupCollection()
                 self.newCollection.reloadData()
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
                else {
                    print("not friends")
                    friends = false
                    
                    
                    //AddFriendButton.isHidden = false
                    print("we are not friends")
                     Database.database().reference().child("users").child(nameID!).child("friendRequests").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                                  if snapshot.exists(){
                                       
                                      self.AddFriendButton.setTitle("Pending", for: .normal)
                                      
                                      self.AddFriendButton.backgroundColor = UIColor.orange
                                      
                                      self.AddFriendButton.isEnabled = false
                                    
                                      
                                      }
                                  else {
                                     self.AddFriendButton.setTitle("Remove Friend ", for: .normal)
                                     
                                     self.AddFriendButton.backgroundColor = UIColor.red
                                     
                                    // self.AddFriendButton.isEnabled = false
                         }
                                  })
                     
                     
                   loadfirst5posts(completion: { message2 in self.loadPost(postidforload: message2,completion: { message in
                    // print("MINIPOST in closure SIZE")
                     //print( self.miniposts.count)
                     // self.setupCollection()
                     self.newCollection.reloadData()
                     self.loadLikers(Message: message)
                     self.loadLikes(Message: message)
                     self.loadcomments(Message: message)
                     // miniposts.removeAll()
                     // self.loadFriends()
                        self.tableView.reloadData()
                        
                    })
                    })
                }
                
                //tableView.rowHeight = 450
                self.view.addSubview(newCollection)
                newCollection.register(CustomeCell.self, forCellWithReuseIdentifier: cellId2)
                newCollection.delegate = self
                newCollection.dataSource = self
                loadFriends()
                setupCollection()
                //view.bringSubviewToFront(backgroundofbuttons)
                addButtons()
                // loadSmallPictures()
                tableView.tableFooterView = UIView()
                

                      AppUtility.lockOrientation(.portrait)
                }
                    
                    override func viewWillDisappear(_ animated: Bool) {
                        super.viewWillDisappear(animated)

                        // Don't forget to reset when view is being removed
                        AppUtility.lockOrientation(.all)
                    }
            
        //    override func viewWillAppear(_ animated: Bool) {
        //        super.viewWillAppear(animated)
        //        print("HERE EVERYTIME")
        //        checkbio()
        //
        //
        //    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           
           //view.addBackground()
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
             self.loadPost2(postidforload: message2,completion: { message in
            // print("MINIPOST in closure SIZE")
             //print( self.miniposts.count)
             // self.setupCollection()
             self.newCollection.reloadData()
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
             
    
        
    
    func  loadfirst5posts(completion: @escaping (_ message2: String) -> Void){
       print("load5postsbaby");
        var counter = 0;
        var actualcounter = 0;
        var nextpost = ""; Database.database().reference().child("users").child(nameID!).child("ownposts").queryLimited(toLast: 5).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
         
        
          // print(postid)
          
          for rest in snapshot.children.allObjects as! [DataSnapshot] {
             
                let postid = rest.key
          
          if let dict = rest.value as? [String: Any] {
        
           print("posterid")
            print(counter)
          //  if let dict = snapshot.value as? [String: Any]{
                           let global = dict["global"] as! Bool
                if(counter == 0){
                 nextpost = postid
                }
            counter = counter + 1;
                    print(postid)
                if( (global == false && self.friends == true)  || global == true  ){
                    actualcounter = actualcounter + 1
           completion(postid)
                }
                    print("we do not need 5 more")
                    print(counter)
                    print(actualcounter)
                    if(counter == 5 && actualcounter < 5){
                        print("we need more!"); self.load5moreposts(actualcounter:actualcounter ,nextpost: nextpost, completion: { message2 in self.loadPostbackwords(actualcounter: actualcounter, postidforload: message2,completion: { message in
                                     // print("MINIPOST in closure SIZE")
                                      //print( self.miniposts.count)
                                      // self.setupCollection()
                                      self.newCollection.reloadData()
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
    
    
    func  load5moreposts(actualcounter: Int,nextpost: String, completion: @escaping (_ message2: String) -> Void){
        print("getting 5 more")
        var actualcounter = actualcounter
        var counter = 0;
        var nextpost2 = "";
       print(nextpost)
        Database.database().reference().child("users").child(nameID!).child("ownposts").queryOrderedByKey().queryEnding(atValue: nextpost).queryLimited(toFirst: 5).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
         
        
          // print(postid)
          
          for rest in snapshot.children.allObjects as! [DataSnapshot] {
             
                let postid = rest.key
          if let dict = rest.value as? [String: Any] {
            print("posterid")
             print(counter)
             //if let dict = snapshot.value as? [String: Any]{
                            let global = dict["global"] as! Bool
                  nextpost2 = postid
             counter = counter + 1;
                     print(postid)
               // if postid != nextpost
                 if(   (global == false && self.friends == true)  || global == true  ){
                     actualcounter = actualcounter + 1
            completion(postid)
                    if(counter == 5 && actualcounter < 5){ self.load5moreposts(actualcounter:actualcounter ,nextpost: nextpost, completion: { message2 in self.loadPost(postidforload: message2,completion: { message in
                                      // print("MINIPOST in closure SIZE")
                                       //print( self.miniposts.count)
                                       // self.setupCollection()
                                       self.newCollection.reloadData()
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
    
    func loadPost2(postidforload: String, completion: @escaping (_ message: String) -> Void){
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
                print(self.nameID)
                 if( (global == false && self.friends == true)  || global == true  ){
                 if(last_post != postid){
                self.posts2.insert(post, at: lengthcount)
                    if(photoURLString != "noImage"){
                        self.miniposts.insert(photoURLString, at: 0)
                    }
                    print("INSIDE")
                    print(
                        self.miniposts.count)
                }
                    DispatchQueue.main.async(execute: {
                        completion(postid)
                        self.tableView.reloadData()
                    })
                
            }
            }
        }
        
    }
    var counter = 0
     var doneloadposts = false
    
    func  loadfirst5posts2(completion: @escaping (_ message2: String) -> Void){
              //print("load5posts");
            counter = 0; Database.database().reference().child("users").child(nameID!).child("ownposts").queryOrderedByKey().queryEnding(atValue: posts2[posts2.count-1].postID).queryLimited(toLast: 5).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
             
            
              // print(postid)
              
              for rest in snapshot.children.allObjects as! [DataSnapshot] {
                 
                  
            self.counter = self.counter + 1;
                         print("childrensize")
    //            if(snapshot.childrenCount == 1){
    //                self.doneloadposts  = true;
    //            }
               // else {
                         let postid = rest.key
                  print("inload5poster")
                           print(postid)
                  completion(postid)
                     
               // }
                
                DispatchQueue.main.async(execute: {
                    if(self.counter == 1){
                        self.doneloadposts  = true;
                    }
                })
              }
              
        })
               
            }
        
            
                func addprof(){
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                    Database.database().reference().child("users").child(nameID!).observeSingleEvent(of: .value, with: { (snapshot) in
                           //print(snapshot.value ?? "")
                         //  let postid = snapshot.key
                        let dictionary = snapshot.value as? [String: Any]
             
                          // myProfilePicture = dictionary?[ "ProfileImage"] as? String
                        
                        //self.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: myProfilePicture!)
                               DispatchQueue.main.async {
                                   //self.ProPic.image = image
                           }
                       })
            }
            
            func addButtons(){
                
               
            }
            

    
    @objc func handleMessage() {
      //  dismiss(animated: true, completion: nil)
        
        Database.database().reference().child("users").child(self.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            let dictionary = snapshot.value as? [String: Any]
            let user10 = User(dictionary: dictionary! as [String : AnyObject])
            user10.name = self.name
            user10.id = self.nameID
        self.showChatControllerForUser(user10)
        })
    }
    func showChatControllerForUser(_ user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
           // @IBOutlet weak var backgroundofbuttons: UIView!
            func loadLikers(Message: String){
                // print("LOADLIKERS")
                //print(posts.count)
                var likerarray = [User2]()
                var likersstring = "";
                
               // print("adding string likers")
                var postid =  Message
                
               // print(postid);
                Database.database().reference().child("posts").child(postid).child("likers").observe(.childAdded) {( snapshot: DataSnapshot) in
                    // print("HERE")
                    // var likerarray = [User2]()
                    if let dict = snapshot.value as? [String: Any]{
                       // print(snapshot)
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
                            //print("size is 0")
                            foo.likersstring = ""
                        }
                        else  if(total_count == 1){
                           // print("size =1")
                            likersstring =  "\(likerarray[total_count-1].usersname) liked the post"
                            print(likersstring)
                            foo.likersstring = likersstring
                          //  print("size = 1")
                            
                        }
                        else if(total_count == 2){
                            likersstring =  "\(likerarray[total_count-2].usersname) and \(likerarray[total_count-1].usersname) liked the post"
                           // print("size =2")
                            //print(likersstring)
                            
                            foo.likersstring = likersstring
                        }
                            
                        else if(total_count > 2){
                            likersstring =  "\(likerarray[total_count-2].usersname) and \(likerarray[total_count-1].usersname) and \(total_count - 2) others liked the post"
                            //print("size =3")
                            //print(likersstring)
                            foo.likersstring = likersstring
                        }
                    }
                    else {
                      //  print("error")
                        
                        
                    }
                    
                }
                
               // print("liker size")
                //print(likerarray.count)
                
                
                
            }
            
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
                    print("Number of comments!")
                    //print(commentnum)
                    if let foo = self.posts2.first(where: { $0.postID == Message}){
                        foo.numberofcomments = commentnum
                    }
                    
                    //  print(commentnum)
                    
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                        //  completion("loadlikes")
                    })
                    
                })
                
            }
            
            
    //        @IBAction func settingbutton(_ sender: Any) {
    //
    //
    //            if( dropdownheight.constant == 100){
    //               // print("IN HERE")
    //                UIView.animate(withDuration: 0.5) {
    //                    self.dropdownheight.constant = 0
    //                    self.editprofile.isHidden = true
    //                    self.infobutt.isHidden = true
    //                    self.logoutButt.isHidden = true
    //                    self.view.layoutIfNeeded()
    //
    //                }
    //
    //            }
    //
    //            else{
    //                UIView.animate(withDuration: 0.5) {
    //                    self.dropdownheight.constant = 100
    //                    self.editprofile.isHidden = false
    //                    self.infobutt.isHidden = false
    //                    self.logoutButt.isHidden = false
    //                    self.view.layoutIfNeeded()
    //                }
    //        }
    //        }
            
            
            func loadLikers2(Message: String, completion: @escaping (_ message: String) -> Void){
                // print("LOADLIKERS")
                //print(posts.count)
                var likerarray = [User2]()
                var likersstring = "";
                
                //print("adding string likers")
                var postid =  Message
                
               
            //print(postid);
                Database.database().reference().child("posts").child(postid).child("likers").observe(.childAdded) {( snapshot: DataSnapshot) in
                    // print("HERE")
                    // var likerarray = [User2]()
                    if let dict = snapshot.value as? [String: Any]{
                       // print(snapshot)
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
                           // print(likersstring)
                            foo.likersstring = likersstring
                           // print("size = 0")
                            completion("done")
                            
                        }
                        else  if(total_count == 1){
                            //print("size =1")
                            likersstring =  "\(likerarray[total_count-1].usersname) liked the post"
                            //print(likersstring)
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
            
            
            
            
            func loadSmallPictures(){
                var i = 0
                //print(posts2.count )
                while(miniposts.count < 10 && miniposts.count > i){
                    if(posts2[i].imageUrl != "noImage" ) {
                        // print(posts2[i].imageUrl)
                        
                        miniposts.append(posts2[i].imageUrl)
                    }
                    i = i+1
                }
                
            }
            var friendsList2: [String] = Array()
            
            func loadFriends(){
                friendsList2.removeAll()
                
                var friendcounter = 0
                let ref = Database.database().reference().child("users").child(nameID!).child("friendsList")
                ref.observe(.childAdded, with: { (snapshot) in
                    
                    let userId = snapshot.key
                    print(userId)
                    self.friendsList2.append(userId)
                    //numberoffriends = friendcounter
                    // self.friendButton.setTitle("\(self.friendsList.count) Friends", for: .normal)
                    DispatchQueue.main.async(execute: {
                        print( "friendsList:")
                        print(self.friendsList2.count)
                        
                        if(self.friendsList2.count == 1){
                            self.friendButton.setTitle("\(self.friendsList2.count) Friend", for: .normal)
                        }
                        else{ self.friendButton.setTitle("\(self.friendsList2.count) Friends", for: .normal)
                        }
                        // friendsList.reloadData()
                    })
                    
                })
                
                
                friendButton.setTitle("\(friendsList2.count) Friends", for: .normal)
            }
            
            let biographyLabel: UITextView = {
                let ptext = UITextView()
                ptext.translatesAutoresizingMaskIntoConstraints = false
                ptext.layer.masksToBounds = true
                ptext.contentMode = .scaleAspectFill
                ptext.font = .boldSystemFont(ofSize: 15)
                ptext.isEditable = false
                ptext.isScrollEnabled = false;
                //ptext.text = "0"
                //ptext.backgroundColor = UIColor.red
                ptext.textColor = UIColor.black
                ptext.textAlignment = .left
                ptext.dataDetectorTypes = .all 
              //ptext.backgroundColor = UIColor.blue
                return ptext
            }()
            
            func checkbio(){
                
                Database.database().reference().child("users").child(nameID!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let dictionary = snapshot.value as? [String: Any]
                    
                    myProfilePicture = dictionary?[ "ProfileImage"] as? String
                    
                    let profileTemp = UIImageView()
                    profileTemp.loadImageUsingCacheWithUrlString(urlString: myProfilePicture!)
                    self.profilePicture = profileTemp.image
                   // self.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: myProfilePicture!)
                    
                    if snapshot.hasChild("biography"){
                        var biography = dictionary?[ "biography"] as? String
                                  
                                   if(biography != ""){
                                       self.biobutton.isHidden = true
                                       self.biographyLabel.isHidden = false
                                       print("trueeee")
                                   }
                                   if(biography == ""){
                                      self.biobutton.isHidden = false
                                       self.biographyLabel.isHidden = true
                                       print("falseeee")
                                   }
                                   
                                   
                                 
                                   // let height = 1000*(biography!.count / 40)+1;
                                   //self.biographyLabel.heightAnchor.constraint(equalToConstant: CGFloat(height) ).isActive = true
                                   //self.biographyLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
                                   self.biographyLabel.text = biography
                                   self.biographyLabel.topAnchor.constraint(equalTo: self.profileImageViewTop.bottomAnchor, constant: 0).isActive = true
                                                  self.biographyLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
                                                  self.biographyLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-114).isActive = true
                        

                    }
                    else {
                      
                                                 self.biobutton.isHidden = false
                                                  self.biographyLabel.isHidden = true
                                                  print("nobio")
                                              
                       
                        
                    }
                    
                    
                    DispatchQueue.main.async {
                        //self.ProPic.image = image
                        
                        self.tableView.frame = CGRect(x: 0, y: self.biographyLabel.bounds.height + self.profileImageViewTop.bounds.height + 100 , width: self.tableView.frame.size.width, height: UIScreen.main.bounds.height - self.biographyLabel.bounds.height - self.profileImageViewTop.bounds.height - 100 )

                        print( self.biographyLabel.bounds.height)
                        
                        
                    }
                })
                
               
            }
            
            func setupCollection(){
                
                self.view.addSubview(profileImageViewTop)
                self.view.addSubview(friendButton)
                //        if(uid != nameID){
                self.view.addSubview(AddFriendButton)
                //        }
                self.view.addSubview(locationFavButton)
                self.view.addSubview(biographyLabel)
                locationFavButton.isHidden = true
                
                
               
               
                
                
                newCollection.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
                newCollection.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
                newCollection.heightAnchor.constraint(equalToConstant: 100 ).isActive = true
                newCollection.widthAnchor.constraint(equalToConstant: 100).isActive = true
                
                
                profileImageViewTop.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
                profileImageViewTop.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
                profileImageViewTop.heightAnchor.constraint(equalToConstant: 100 ).isActive = true
                profileImageViewTop.widthAnchor.constraint(equalToConstant: 100).isActive = true
                profileImageViewTop.image = profilePicture
                
                // biogrraphyLabel
                
        //               tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        //                tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        //                tableView.heightAnchor.constraint(equalToConstant: 100 ).isActive = true
        //                tableView.widthAnchor.constraint(equalToConstant: 100).isActive = true
                
                
                
                
                Database.database().reference().child("users").child(nameID!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let dictionary = snapshot.value as? [String: Any]
                    if snapshot.hasChild("biography"){
                        var biography = dictionary?[ "biography"] as? String
                                   
                                   if(biography != ""){
                                       //self.biobutton.isHidden = true
                                       self.biographyLabel.isHidden = false
                                       print("trueeee")
                                   }
                                   if(biography == ""){
                                      //self.biobutton.isHidden = false
                                       self.biographyLabel.isHidden = true
                                       print("falseeee")
                                   }
                                   
                                   
                                 
                                   // let height = 1000*(biography!.count / 40)+1;
                                   //self.biographyLabel.heightAnchor.constraint(equalToConstant: CGFloat(height) ).isActive = true
                                   //self.biographyLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
                                   self.biographyLabel.text = biography
                                   self.biographyLabel.topAnchor.constraint(equalTo: self.profileImageViewTop.bottomAnchor, constant: 0).isActive = true
                                                  self.biographyLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
                                                  self.biographyLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-114).isActive = true
                        

                    }
                    else {
                      
//                                                 self.biobutton.isHidden = false
                                                  self.biographyLabel.isHidden = true
                                                  print("nobio")
                                              
                       
                        
                    }
                    
                   
                    DispatchQueue.main.async {
                        //self.ProPic.image = image
                        
                       
                        
                   
                        // 19 size
                        //self.heightConstraint = self.biographyLabel.heightAnchor.constraint(equalToConstant: CGFloat(lines))
                        
                        
                        //self.heightConstraint!.isActive = true
                        self.tableView.heightAnchor.constraint(equalToConstant: 525 - self.biographyLabel.bounds.height).isActive = true
                       // let tableView: UITableView = UITableView(frame: CGRect(x: 0, y: 339, width: UIScreen.main.bounds.width, height: 525 - self.biographyLabel.bounds.height));
                        
                        
                        self.tableView.frame = CGRect(x: 0, y: self.biographyLabel.bounds.height + self.profileImageViewTop.bounds.height + 100 , width: self.tableView.frame.size.width, height: UIScreen.main.bounds.height - self.biographyLabel.bounds.height - self.profileImageViewTop.bounds.height - 100)

                        
                         print(self.biographyLabel.bounds.height)
                    }
                })
                

                
                friendButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 110).isActive = true
                friendButton.leftAnchor.constraint(equalTo: profileImageViewTop.rightAnchor, constant: 10).isActive = true
                friendButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
                friendButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
                
                locationFavButton.topAnchor.constraint(equalTo: friendButton.bottomAnchor, constant: 10).isActive = true
                locationFavButton.leftAnchor.constraint(equalTo: profileImageViewTop.rightAnchor, constant: 10).isActive = true
                locationFavButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
                locationFavButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
                
                AddFriendButton.topAnchor.constraint(equalTo: friendButton.bottomAnchor, constant: 10).isActive = true
                AddFriendButton.leftAnchor.constraint(equalTo: profileImageViewTop.rightAnchor, constant: 10).isActive = true
                AddFriendButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
               AddFriendButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
                
                AddFriendButton.addTarget(self, action: #selector(handleFriend), for: .touchUpInside)
                if(uid == nameID){
                    AddFriendButton.isHidden =  true
                }
                friendButton.addTarget(self, action: #selector(showFriends), for: .touchUpInside)
                
                
            }
            
            override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                view.endEditing(true)
            }
            
         
            @IBOutlet weak var biobutton: UIButton!
            @objc func showFriends() {
                let vc = friendsListController()
                vc.userid = nameID!
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            @objc func handleCancel() {
                // dismiss(animated: true, completion: nil)
                _ = navigationController?.popViewController(animated: true)
            }
            
            @objc func handleFriend() {
                //        print(nameID!)
                
                
                Database.database().reference().child("users").child(nameID!).child("friendRequests").updateChildValues(["\(uid!)": "1"])
            }
            
        
  
        
        
    var nextuser: String?
   
    
    func loadPost(postidforload: String, completion: @escaping (_ message: String) -> Void){
          
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
                  print(self.nameID)
                if( (global == false && self.friends == true)  || global == true  ){
                      self.posts2.insert(post, at: 0 )
                      
    
                      DispatchQueue.main.async(execute: {
                          completion(postid)
                          self.tableView.reloadData()
                      })
                  
              }
            }
              
          }
          
      }
    
    
    func loadPostbackwords(actualcounter: Int, postidforload: String, completion: @escaping (_ message: String) -> Void){
             
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
                     print("VS")
                     print(self.nameID)
                   if( (global == false && self.friends == true)  || global == true  ){
                         self.posts2.insert(post, at: actualcounter)
                    
                         if(photoURLString != "noImage"){
                             self.miniposts.insert(photoURLString, at: 0)
                         }
                         print("INSIDE")
                         print(
                             self.miniposts.count)
                         DispatchQueue.main.async(execute: {
                             completion(postid)
                             self.tableView.reloadData()
                         })
                     
                 }
               }
                 
             }
             
         }
    
    
}
            

        extension AccountViewController: UITableViewDataSource {
            func tableView( _ tableView:UITableView, numberOfRowsInSection section: Int)-> Int {
                return posts2.count
            }//how many cells
            
            
            func tableView(  _ tableView: UITableView, heightForRowAt indexPath: IndexPath)->CGFloat{
                
                if(posts2[indexPath.row].postorevent == "post"){
                    let imageyesorno = posts2[indexPath.row].imageUrl
                    let numberoflines = ((posts2[indexPath.row].postCount)/42)+1 // %42
                    //let audioyesorno =f posts[indexPath.row].audio64
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
                cell.selectionStyle = .none;
                        cell.cellID = posts2[indexPath.row].postID
                        cell.userid = posts2[indexPath.row].usersName;
                        
                        cell.globalButton2.isHidden = true
                        cell.replypostText.isHidden = true
                        cell.globalButton2.isHidden = true
                            cell.threedots2.isHidden = true
                cell.postImage2.isHidden = true
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
                    //    print(posts[indexPath.row].postorevent )
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
                            cell.nameButton.setTitle(self.name, for: .normal)
                            // cell.cellID = toId
                            cell.profileImageViewTop.image = self.profilePicture
//                             if(addedPicture == true ){
//                            cell.profileImageViewTop.image = profilePhotoEdit!
//                            }
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
                            //cell.likeLabel.text = String(posts[indexPath.row].numberoflikes)
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
                             cell.profileImageViewTop.image = profilePicture
                                
                              
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
                                Database.database().reference().child("posts").child(posts[indexPath.row].postID).updateChildValues(["numberoflikes": liked])
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
            
            
        }



        extension AccountViewController: newsCellDelegate {
            func didTapLocationButton(local: String) {
                let vc = AnnotationTableViewController()
                vc.spot = local
              self.navigationController?.pushViewController(vc, animated: true)
            }
            
            func didTapProfile(name: String, profilePicture: UIImage, nameid: String){
                print("now im here")
                
                let vc = AccountViewController()
                // print(id)
                vc.profilePicture = profilePicture
                vc.name = name
                vc.nameID = nameID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }

    extension AccountViewController: UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
            
            
            func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                print("minipost count post collection view")
                print(miniposts.count)
                return miniposts.count
            }
            
            func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let cell = newCollection.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! CustomeCell
                cell.backgroundColor  = .black
                //        cell.layer.cornerRadius = 5
                //        cell.layer.shadowOpacity = 3
                cell.imageView.image = UIImage(named: "unknown")
                //print(postit[indexPath.row])
                //print(miniposts.count)
                cell.imageView.loadImageUsingCacheWithUrlString(urlString: miniposts[indexPath.row])
                
                
                return cell
            }
            
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                return CGSize(width: 25, height: 25)
            }
            
            
            //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            //        return UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100)
            //    }
            
            
        }


class CustomeCell: UICollectionViewCell {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.backgroundColor = UIColor.black
//        image.layer.borderColor = UIColor.blue as! CGColor
        return image
    }()
    
    
    
    func  setupView(){
        addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

