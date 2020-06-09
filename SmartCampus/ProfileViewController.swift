//
//  ProfileViewController.swift
//  SmartCampus
//
//  Created by Tommy Chavez on 1/9/19.
//  Copyright © 2019 Tommy Chavez. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController:  UIViewController, UITableViewDelegate {
    var posts2 = [Post]()
    var miniposts = [String]()
    var name: String?
    var nameID: String?
    var profilePicture = UIImage(named:"unknown")
    
    @IBOutlet weak var tableheight: NSLayoutConstraint!
    
    
    
     var heightConstraint: NSLayoutConstraint?
   
    
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
    
        
  
    

    
    @objc func onDidReceiveData(_ notification:Notification) {
        // Do something now
    }
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
    
     @IBOutlet weak var dropdownheight: NSLayoutConstraint!
    
    let friendButton: UIButton = {
        let nameImage: UIButton = UIButton(frame: CGRect(x: 125, y: 110, width: 120.00, height: 35));
        // let nameImage = UIButton()
        nameImage.translatesAutoresizingMaskIntoConstraints = false
        nameImage.layer.masksToBounds = true
        nameImage.backgroundColor = UIColor.orange
        
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
        nameImage.setTitleColor( UIColor.black, for: .normal )
        nameImage.titleLabel?.adjustsFontSizeToFitWidth = true
        nameImage.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        nameImage.contentHorizontalAlignment = .left
        
        nameImage.setTitleShadowColor(UIColor.white, for: .normal)
        nameImage.titleLabel?.shadowOffset = CGSize(width: 2, height: 2)
        nameImage.setTitle("ADD FRIEND", for: .normal)
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
    
    @IBOutlet weak var editprofile: UIButton!
    
    @IBOutlet weak var infobutt: UIButton!
    
    @IBOutlet weak var logoutButt: UIButton!
    
    @objc func methodOfReceivedNotification(notification: Notification) {
       // setupCollection()
        checkbio();
        //addprof();
        if(addedPicture == true ){
            profileImageViewTop.image = profilePhotoEdit!
             tableView.reloadData()
           // profileImageViewTop.s
        }
         //tableheight.constant = 0
    
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
       addprof();
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
      
        editprofile.isHidden = true
        infobutt.isHidden = true
        logoutButt.isHidden = true
        
        nameID = uid
        name = myUsername!
        dropdownheight.constant = 0
        
//        let profileTemp = UIImageView()
//        profileTemp.loadImageUsingCacheWithUrlString(urlString: myProfilePicture!)
//        profilePicture = profileTemp.image
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
        
        //tableView.rowHeight = 450
        self.view.addSubview(newCollection)
        newCollection.register(CustomeCell.self, forCellWithReuseIdentifier: cellId2)
        newCollection.delegate = self
        newCollection.dataSource = self
        loadFriends()
        setupCollection()
        view.bringSubviewToFront(backgroundofbuttons)
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
//        tableView.reloadData()
//
//
//    }
    
        func addprof(){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
               Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                   //print(snapshot.value ?? "")
                 //  let postid = snapshot.key
                let dictionary = snapshot.value as? [String: Any]
     
                   myProfilePicture = dictionary?[ "ProfileImage"] as? String
                
                self.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: myProfilePicture!)
                       DispatchQueue.main.async {
                           //self.ProPic.image = image
                   }
               })
    }
    
    func addButtons(){
        
       
    }
    

    @IBOutlet weak var backgroundofbuttons: UIView!
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
                   // print(likersstring)
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
    
    
    @IBAction func settingbutton(_ sender: Any) {
    
        
        if( dropdownheight.constant == 100){
           // print("IN HERE")
            UIView.animate(withDuration: 0.5) {
                self.dropdownheight.constant = 0
                self.editprofile.isHidden = true
                self.infobutt.isHidden = true
                self.logoutButt.isHidden = true
                self.view.layoutIfNeeded()
                
            }
            
        }
            
        else{
            UIView.animate(withDuration: 0.5) {
                self.dropdownheight.constant = 100
                self.editprofile.isHidden = false
                self.infobutt.isHidden = false
                self.logoutButt.isHidden = false
                self.view.layoutIfNeeded()
            }
    }
    }
    
    
    func loadLikers2(Message: String, completion: @escaping (_ message: String) -> Void){
            print("HERE")
            // print("LOADLIKERS")
            //print(posts.count)
            var likerarray = [User2]()
            var likersstring = "";
            
            //print("adding string likers")
            var postid =  Message
            var likedbyme2 = false
             print(postid);
            
                 
            //print(postid);
           
           Database.database().reference().child("posts").child(postid).observeSingleEvent(of: .value, with: { (snapshot) in

                if snapshot.hasChild("likers"){

                    
                }else{
    print("we in here")
                    if let foo = self.posts2.first(where: { $0.postID == Message}){
                     
                    print("default")
                                         
                                                let total_count = likerarray.count
                         print(likerarray.count)
                                              //print(total_count)
                                                 foo.numberoflikes = total_count
                                                var likersstring = ""
                                                 // print("ZERO!")
                         foo.likedby = false
                                                    likersstring =  ""
                                                 foo.numberoflikes = total_count
                                                    //print(likersstring)
                                                    foo.likersstring = likersstring
                                                   // print("size = 0")
                                                   
                     
                                                
                      completion("done");
                                            }
                   
                }


            })
            
            Database.database().reference().child("posts").child(postid).child("likers").observe(.childAdded) {( snapshot: DataSnapshot) in
                // print("HERE")
                // var likerarray = [User2]()
               
                
                            if let dict = snapshot.value as? [String: Any]{
                                
                    print(dict)
                                print("not zero!")
                    //print(snapshot)
                    let usersname = dict["likerName"] as! String
                    print(usersname)
                    let userid = dict["likersid"] as! String
                    let likerurl = ""
                    
                    let liker = User2(profileImageUrl: likerurl, usersName: usersname, usersId: userid)
                    //print(liker)
                    likerarray.append(liker)
                    if(liker.usersid == self.uid! ){
                        likedbyme2 = true;
                    }
                    //print("liker size in closure")
                    // print(likerarray.count)
                    
                    DispatchQueue.main.async(execute: {
                
                       if let foo = self.posts2.first(where: { $0.postID == Message}){
                             print(likerarray.count)
                             print("in here")
                        foo.likedby = likedbyme2
                                      let total_count = likerarray.count
                        print(total_count)
                                       foo.numberoflikes = total_count
                                      var likersstring = ""
                                      if(total_count  == 0){
                                          likersstring =  ""
                                         print ("im zero")
                                          foo.likersstring = likersstring
                                        //  print("size = 0")
                                          completion("done")
                                          
                                      }
                                      else  if(total_count == 1){
                                          //print("size =1")
                                          likersstring =  "\(likerarray[total_count-1].usersname) liked the post"
                                          //print(likersstring)
                                          foo.likersstring = likersstring
                                          //print("size = 1")
                                          completion("done")
                                          
                                      }
                                      else if(total_count == 2){
                                          likersstring =  "\(likerarray[total_count-2].usersname) and \(likerarray[total_count-1].usersname) liked the post"
                                         // print("size =2")
                                          //print(likersstring)
                                          
                                          foo.likersstring = likersstring
                                          completion("done")
                                      }
                                          
                                      else if(total_count > 2){
                                          likersstring =  "\(likerarray[total_count-2].usersname) and \(likerarray[total_count-1].usersname) and \(total_count - 2) others liked the post"
                                          //print("size =3")
                                          //print(likersstring)
                                          foo.likersstring = likersstring
                                          completion("done")
                                      }
                                  }
                                  else {
                                      print("error")
                                      
                                      
                                  }
                                  
                              
                        
    //                    if let foo = posts.first(where: { $0.postID == Message}){
    //
    //
    //                           foo.likedby = likedbyme2
    //                           let total_count = likerarray.count
    //                         //print(total_count)
    //                            foo.numberoflikes = total_count
    //                           var likersstring = ""
    //                           if(total_count  == 0){
    //                               likersstring =  ""
    //                               //print(likersstring)
    //                               foo.likersstring = likersstring
    //                              // print("size = 0")
    //                               completion("done")
    //
    //                           }
    //
    //                       }
                    })
                    
                }
            }
            
           // print("liker size")
          //  print(likerarray.count)
            
       
            
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
    var friendsList: [String] = Array()
    
    func loadFriends(){
        friendsList.removeAll()
        var friendcounter = 0
        let ref = Database.database().reference().child("users").child(nameID!).child("friendsList")
        ref.observe(.childAdded, with: { (snapshot) in
            
            let userId = snapshot.key
           
            self.friendsList.append(userId)
            //numberoffriends = friendcounter
            // self.friendButton.setTitle("\(self.friendsList.count) Friends", for: .normal)
            DispatchQueue.main.async(execute: {
              
                
                if(self.friendsList.count == 1){
                    self.friendButton.setTitle("\(self.friendsList.count) Friend", for: .normal)
                }
                else{ self.friendButton.setTitle("\(self.friendsList.count) Friends", for: .normal)
                }
                // friendsList.reloadData()
            })
            
        })
        
        
        friendButton.setTitle("\(friendsList.count) Friends", for: .normal)
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
      //ptext.backgroundColor = UIColor.blue
        ptext.dataDetectorTypes = .all 
        return ptext
    }()
    
    func checkbio(){
        
        Database.database().reference().child("users").child(self.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
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
                           }
                           if(biography == ""){
                              self.biobutton.isHidden = false
                               self.biographyLabel.isHidden = true
                               
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
        
        
        
        
        Database.database().reference().child("users").child(self.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            let dictionary = snapshot.value as? [String: Any]
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
        
        AddFriendButton.bottomAnchor.constraint(equalTo: profileImageViewTop.bottomAnchor, constant: 0).isActive = true
        AddFriendButton.centerXAnchor.constraint(equalTo: profileImageViewTop.centerXAnchor, constant: 0).isActive = true
        AddFriendButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        AddFriendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
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
    
    @objc func handleMessage() {
        
    }
    
    
    func  loadfirst5posts(completion: @escaping (_ message2: String) -> Void){
        print("load5posts"); Database.database().reference().child("users").child(uid!).child("ownposts").queryLimited(toLast: 5).observe(.childAdded){(snapshot: DataSnapshot) in
                   //print("HERE")
                   let postid = snapshot.key
            print("posterid")
                     print(postid)
            completion(postid)
               
         
        }
        
        
     }
    var doneloadposts = false
    var counter = 0
    
    func  loadfirst5posts2(completion: @escaping (_ message2: String) -> Void){
          print("load5posts");
        counter = 0; Database.database().reference().child("users").child(uid!).child("ownposts").queryOrderedByKey().queryEnding(atValue: posts2[posts2.count-1].postID).queryLimited(toLast: 5).observe(.childAdded){(snapshot: DataSnapshot) in
        self.counter = self.counter + 1;
                     print("childrensize")
//            if(snapshot.childrenCount == 1){
//                self.doneloadposts  = true;
//            }
           // else {
                     let postid = snapshot.key
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
                let post = Post(captionText: captionText
                    , photoURLString: photoURLString, USERNAME: USERNAME, locationText: locationText, likes: likes, likedbyme: likedbyme, postid: postid, postcount: postcount, Audio64: Audio64, postTime: postTime,likerArray: likerarray,  likersString: "",numberOfComments: 0, Global: true, postOrEvent: postorevent , timestartstring: timestartstring, timeendstring: timeendstring, displayname: "", profimg: "" , score: 0, spaces: spaces)
                print(USERNAME )
                print("VS")
                print(self.nameID)
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
                    self.posts2.insert(post, at: 0 )
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
            
   
       
    
    
    
    
}

extension ProfileViewController: UITableViewDataSource {
    func tableView( _ tableView:UITableView, numberOfRowsInSection section: Int)-> Int {
        return posts2.count
    }//how many cells
    
    
    func tableView(  _ tableView: UITableView, heightForRowAt indexPath: IndexPath)->CGFloat{
        if(self.posts2[indexPath.row].postorevent == "post"){
                
                    let imageyesorno = self.posts2[indexPath.row].imageUrl
        //            var realcount = self.posts2[indexPath.row].postCount
        //            // %42
        //            var spaces = self.posts2[indexPath.row].Spaces/2
        //             let spaces2 = self.posts2[indexPath.row].Spaces%2
        //            if(spaces2 == 1){
        //                spaces = spaces + 1;
        //            }
        //            realcount = realcount - spaces
                    var numberoflines = self.posts2[indexPath.row].Spaces
                    print("Posttext height")
                   
                //let audioyesorno =f self.posts2[indexPath.row].audio64
                let audioyesorno = "noaudio"
                var height = numberoflines * 22
                
                if(audioyesorno != "noaudio"){
                    height = height + 80
                }

                if(imageyesorno == "noImage") {
                    
                   
                    return (CGFloat(120 + height))//80
                }
                    
                    if(imageyesorno != "noImage") {
                               
                              
                               return (CGFloat(430 + height))//80
                           }
                  //return (CGFloat(380 + height))
                return (CGFloat(420 + height))
                    
                }
                
                 else if (self.posts2[indexPath.row].postorevent == "event"){
                    let imageyesorno = self.posts2[indexPath.row].imageUrl
                   
                    let numberoflines =  self.posts2[indexPath.row].Spaces// %42
                    //let audioyesorno =f self.posts2[indexPath.row].audio64
                    let audioyesorno = "noaudio"
                    var height = numberoflines * 22
                    
                    if(audioyesorno != "noaudio"){
                        height = height + 80
                    }

                    if(imageyesorno == "noImage") {
                        
                       
                        return (CGFloat(160 + height))//80
                    }
                    if(imageyesorno != "noImage") {
                                   
                                  
                                   return (CGFloat(460 + height))//80
            }
        }
        return 180
        }
    
    
//    cell.nameButton.setTitle(myUsername, for: .normal)
//           cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: myProfilePicture!)
//           if(addedPicture == true ){
//           cell.profileImageViewTop.image = profilePhotoEdit!
//           }
    
    func tableView(  _ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! newsCell;
        //      print(posts.count)
                    cell.postImage2.isHidden = true
                    cell.selectionStyle = .none;
                cell.cellID = self.posts2[indexPath.row].postID
                cell.userid = self.posts2[indexPath.row].usersName;
               
                   
                    cell.replypostText.isHidden = true
                cell.globalButton2.isHidden = true
                    cell.threedots2.isHidden = true
                
                 let toId = self.posts2[indexPath.row].usersName
                    cell.globalButton.isHidden = false
                 let isGlobal = self.posts2[indexPath.row].global
                    if(isGlobal==true){
                        cell.globalButton.setImage(UIImage(named:"earth"), for: .normal)
                    }
                    else if(isGlobal==false){
                        cell.globalButton.setImage(UIImage(named:"lock"), for: .normal)
                        
                    }
                 cell.CommentStamp.text = String(self.posts2[indexPath.row].numberofcomments)
                  
                 self.loadLikers2( Message: self.posts2[indexPath.row].postID, completion: { message in
                  
                 // print("in here")
                 cell.likeLabel.text = String(self.posts2[indexPath.row].numberoflikes);
                  cell.likerstring.text = self.posts2[indexPath.row].likersstring
                    })
            
                if(self.posts2[indexPath.row].likedby == true){
                    let heartFilled = UIImage(named: "heartfilled")
                    cell.likeButton.setImage(heartFilled, for: .normal)
                }//close if
                if(self.posts2[indexPath.row].likedby == false){
                    let heartEmpty = UIImage(named: "heartempty")
                    cell.likeButton.setImage(heartEmpty, for: .normal)
                }//close if
                
              if(self.posts2[indexPath.row].postorevent == "post"){
            //    print(self.posts2[indexPath.row].postorevent )
                cell.postText.font = .systemFont(ofSize: 15)
                cell.postText.text = self.posts2[indexPath.row].caption
              cell.descriptionButt.isHidden = true
                
        cell.likeLabel.text = String(self.posts2[indexPath.row].numberoflikes)
                //print(indexPath.row)
                let backgroundView = UIView()
                backgroundView.backgroundColor = UIColor.white
                cell.selectedBackgroundView = backgroundView
               
              
               
                
                 cell.timeStamp.isHidden =  false
                cell.DateStamp.isHidden =  true
                cell.DateStamp2.isHidden = true
              cell.threedots.isHidden =  false
                cell.postImage.isHidden = false
               // cell.threedots2.isHidden = true
                var timeStampString: String = findStringOfTime(newDate: Int(self.posts2[indexPath.row].posttime))
               
                
                        cell.timeStamp.text = timeStampString
                
                    
                
                
               // print(self.posts2[indexPath.row].postID)
          //cell.CommentStamp.text = self.posts2[indexPath.row].
                
                
                
               
                if( self.posts2[indexPath.row].likedby == true){
                  
                    let heartFilled = UIImage(named: "heartfilled")
                    cell.likeButton.setImage(heartFilled, for: .normal)
                }//close if
            
                
          
                    
                    //cell.nameButton.setTitle(username, for: .normal)
                  // cell.cellID = toId 8/12/2019
                    //cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: profileimageURL)
                    cell.nameButton.setTitle(myUsername, for: .normal)
                    cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: myProfilePicture!)
                    if(addedPicture == true ){
                    cell.profileImageViewTop.image = profilePhotoEdit!
                    }
                  let numberoflines = self.posts2[indexPath.row].Spaces // %42
                    
                   let height = numberoflines * 22
                

                    
                    //cell.postText.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
                    
                    cell.postText.frame.size.height = CGFloat(height) //https://stackoverflow.com/questions/38391528/how-to-set-dynamic-label-size-in-uitableviewcell
                    cell.postText.text = self.posts2[indexPath.row].caption
                    var local2    = (self.posts2[indexPath.row].location)
                     local2 = "@\(local2)"
                    cell.locationButton.setTitle(local2, for: .normal)
                   
                    
                   //cell.songid =  self.posts2[indexPath.row].audio64;
                   
                    
                    
                    //cell.likeLabel.text = String( self.posts2[indexPath.row].numberoflikes)
                    let url = self.posts2[indexPath.row].imageUrl
                    cell.postImage.loadImageUsingCacheWithUrlString(urlString: url)
                    //cell.likeLabel.text = String(self.posts2[indexPath.row].numberoflikes)
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

                    
               
                
                }
                 if(self.posts2[indexPath.row].postorevent == "event"){
                     cell.postImage2.isHidden = false //cell.nameButton.setTitle(self.posts2[indexPath.row].posterUsername, for: .normal)
                    cell.timeStamp.isHidden =  true
                    cell.DateStamp.isHidden =  false
                    cell.DateStamp2.isHidden = false
                    cell.threedots.isHidden = true
                   
                    cell.globalButton.isHidden = true
                    cell.globalButton2.isHidden =  false
                    let isGlobal = self.posts2[indexPath.row].global
                    if(isGlobal==true){
                        cell.globalButton2.setImage(UIImage(named:"earth"), for: .normal)
                    }
                    else if(isGlobal==false){
                        cell.globalButton2.setImage(UIImage(named:"lock"), for: .normal)
                        
                    }
                    
                    
                    cell.DateStamp.text = (self.posts2[indexPath.row].timeStartString)
                    cell.DateStamp2.text = (self.posts2[indexPath.row].timeEndString)
                    cell.threedots2.isHidden =  false
                    //cell.threedots2.setImage(UIImage(named:"earth"), for: .normal)
                    cell.locationButton.setTitle("@\(self.posts2[indexPath.row].location)", for: .normal)
                    cell.postText.font = .boldSystemFont(ofSize: 20)
                    cell.postText.text = self.posts2[indexPath.row].caption
                    cell.postText.frame.size.height = CGFloat(22)
                 
                    cell.descriptionButt.isHidden = false;
                    let numberoflines = self.posts2[indexPath.row].Spaces
                    
                    let height = numberoflines * 22
                    
                    
                    
                    

                    cell.descriptionButt.frame.size.height = CGFloat(height);
                    cell.descriptionButt.text=self.posts2[indexPath.row].audio64;
                   
                    cell.likeLabel.text = String(self.posts2[indexPath.row].numberoflikes)
                    cell.postImage2.loadImageUsingCacheWithUrlString(urlString: (self.posts2[indexPath.row].imageUrl))
        //            let ref = Database.database().reference().child("users").child(toId)
        //            Database.database().reference().child("users").child(toId).observeSingleEvent(of: .value, with: { (snapshot) in
        //                //print(snapshot.value ?? "")
        //
        //                let dictionary = snapshot.value as? [String: Any]
        //                let username = dictionary?[ "username"] as? String
        //
        //                guard let profileimageURL = dictionary?[ "ProfileImage"] as? String else {return}
                    
                        
                        cell.nameButton.setTitle(myUsername, for: .normal)
                                           cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: myProfilePicture!)
                                           if(addedPicture == true ){
                                           cell.profileImageViewTop.image = profilePhotoEdit!
                                           }
                        
                      
                          cell.timeStamp.isHidden =  true
                        cell.postImage.isHidden = true

                        
                   // })
                    
               }
                    
                    
                    cell.replyAct = { sender in
                           print("in here now")
                    if(cell.nameButton.titleLabel?.text == myUsername){
                           self.presentAlertWithTitle(title: "Would you like to delete your post?", message: "This action cannot be undone", options: "Yes", "No") { (option) in
                                              print("option: \(option)")
                                              switch(option) {
                                              case 0:
                                                  print("option one")
                                                  self.posts2.remove(at: indexPath.row)
                                                  tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                                                  break
                                              //  return
                                              case 1:
                                                  print("option two")
                                                  break
                                              //return
                                              default:
                                                  print("option two")
                                                  break
                                              }
                                          }
                    }
                    
                    else{
                                          self.presentAlertWithTitle(title: "Would you like to report this post?", message: "If you would like WRUD to know the reason behind this report email us directly.", options: "Yes", "No") { (option) in
                                                             print("option: \(option)")
                                                             switch(option) {
                                                             case 0:
                                                                 print("option one")
                                                                 break
                                                             //  return
                                                             case 1:
                                                                 print("option two")
                                                                 break
                                                             //return
                                                             default:
                                                                 print("option two")
                                                                 break
                                                             }
                                                         }
                                   }
                           
                    
                    
                       }
                
                
                cell.buttonAct = { sender in
                    var useridpluspostid = ""
                    var name = cell.userid
                    useridpluspostid = "\(self.uid!)\(cell.cellID)";
                    
                    Database.database().reference().child("posts").child(self.posts2[indexPath.row].postID).observeSingleEvent(of: .value, with: { (snapshot) in
                     if let dict = snapshot.value as? [String: Any]{
                     
                       let likes = dict["numberoflikes"] as! Int
                    
                    DispatchQueue.main.async(execute: {
                                                    
                                                    
                Database.database().reference().child("posts").child(self.posts2[indexPath.row].postID).child("likers").child(self.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                    if snapshot.exists(){
                        if( self.posts2[indexPath.row].likedby == false){
                                
                             
                                 let noti = ["Notification Type": "Like","ID Number": cell.cellID,"Userid":self.uid! ] as [String : Any]
                                
                                 let new_date = Int(Date().timeIntervalSince1970 * 100000.0)
                                 Database.database().reference().child("users").child(cell.userid!).child("notifications").child(String(new_date)).child(useridpluspostid).updateChildValues(noti);
                                 self.posts2[indexPath.row].likedby = true
                                 let heartFilled = UIImage(named: "heartfilled")
                                 cell.likeButton.setImage(heartFilled, for: .normal)
                                 var liked = self.posts2[indexPath.row].numberoflikes
                                liked =  likes
                                 //self.posts2[indexPath.row].numberoflikes = likes
                                 //                 print(liked)
                                 //                    ref.child("numberoflikes").setValue(1)
                                 let newValues = ["likerName":usersShowName!, "likersid": self.uid!] as [String : Any]
                                 Database.database().reference().child("posts").child(self.posts2[indexPath.row].postID).updateChildValues(["numberoflikes": liked])
                                // cell.likeLabel.text = String(liked);
                                 //Database.database().reference().child("posts").child(posts[indexPath.row].postID).child("likers").child(self.uid!).updateChildValues(newValues)
                                 
                                  cell.likeLabel.text = String(liked)
                                 //
                                // print("liked")
                                 self.loadLikers2( Message: self.posts2[indexPath.row].postID, completion: { message in
                                     
                                    // print("in here")
                                    cell.likeLabel.text = String(self.posts2[indexPath.row].numberoflikes);
                                     cell.likerstring.text = self.posts2[indexPath.row].likersstring
                                    if(self.posts2[indexPath.row].likedby == true){
                                        let heartFilled = UIImage(named: "heartfilled")
                                        cell.likeButton.setImage(heartFilled, for: .normal)
                                    }//close if
                                    if(self.posts2[indexPath.row].likedby == false){
                                        let heartEmpty = UIImage(named: "heartempty")
                                        cell.likeButton.setImage(heartEmpty, for: .normal)
                                    }//close if
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
                                 liked =  likes-1;
                                 self.posts2[indexPath.row].numberoflikes = liked
                                 Database.database().reference().child("posts").child(self.posts2[indexPath.row].postID).updateChildValues(["numberoflikes": liked])
                                 Database.database().reference().child("posts").child(self.posts2[indexPath.row].postID).child("likers").child(self.uid!).removeValue()
                                 
                                 cell.likeLabel.text = String(liked);
                                
                                 
                                 self.loadLikers2( Message: self.posts2[indexPath.row].postID, completion: { message in
                                     print("in here")
                                     cell.likerstring.text = self.posts2[indexPath.row].likersstring
                                     cell.likeLabel.text = String(self.posts2[indexPath.row].numberoflikes);
                                    if(self.posts2[indexPath.row].likedby == true){
                                        let heartFilled = UIImage(named: "heartfilled")
                                        cell.likeButton.setImage(heartFilled, for: .normal)
                                    }//close if
                                    if(self.posts2[indexPath.row].likedby == false){
                                        let heartEmpty = UIImage(named: "heartempty")
                                        cell.likeButton.setImage(heartEmpty, for: .normal)
                                    }//close if
                                 })
                                 
                                 
                                 
                                 
                             }
                        
                             
                             
                      
                        
                    }else{
                        if( self.posts2[indexPath.row].likedby == false){
                                
                             
                                 let noti = ["Notification Type": "Like","ID Number": cell.cellID,"Userid":self.uid! ] as [String : Any]
                                
                                 let new_date = Int(Date().timeIntervalSince1970 * 100000.0)
                                 Database.database().reference().child("users").child(cell.userid!).child("notifications").child(String(new_date)).child(useridpluspostid).updateChildValues(noti);
                                 self.posts2[indexPath.row].likedby = true
                                 let heartFilled = UIImage(named: "heartfilled")
                                 cell.likeButton.setImage(heartFilled, for: .normal)
                                 var liked = self.posts2[indexPath.row].numberoflikes
                                 liked =  likes  + 1
                                 self.posts2[indexPath.row].numberoflikes = liked
                                 //                 print(liked)
                                 //                    ref.child("numberoflikes").setValue(1)
                                 let newValues = ["likerName":usersShowName!, "likersid": self.uid!] as [String : Any]
                                 Database.database().reference().child("posts").child(self.posts2[indexPath.row].postID).updateChildValues(["numberoflikes": liked])
                                 cell.likeLabel.text = String(liked);
                                 Database.database().reference().child("posts").child(self.posts2[indexPath.row].postID).child("likers").child(self.uid!).updateChildValues(newValues)
                                 
                                 cell.likeLabel.text = String(liked)
                                 //
                                // print("liked")
                                 self.loadLikers2( Message: self.posts2[indexPath.row].postID, completion: { message in
                                     
                                    // print("in here")
                                    cell.likeLabel.text = String(self.posts2[indexPath.row].numberoflikes);
                                     cell.likerstring.text = self.posts2[indexPath.row].likersstring;
                                    if(self.posts2[indexPath.row].likedby == true){
                                        let heartFilled = UIImage(named: "heartfilled")
                                        cell.likeButton.setImage(heartFilled, for: .normal)
                                    }//close if
                                    if(self.posts2[indexPath.row].likedby == false){
                                        let heartEmpty = UIImage(named: "heartempty")
                                        cell.likeButton.setImage(heartEmpty, for: .normal)
                                    }//close if
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
                                 liked =  likes
                                 self.posts2[indexPath.row].numberoflikes = liked
                                 Database.database().reference().child("posts").child(self.posts2[indexPath.row].postID).updateChildValues(["numberoflikes": liked])
                                 Database.database().reference().child("posts").child(self.posts2[indexPath.row].postID).child("likers").child(self.uid!).removeValue()
                                 
                                 cell.likeLabel.text = String(liked);
                                
                                 
                                 self.loadLikers2( Message: self.posts2[indexPath.row].postID, completion: { message in
                                     print("in here")
                                     cell.likerstring.text = self.posts2[indexPath.row].likersstring
                                     cell.likeLabel.text = String(self.posts2[indexPath.row].numberoflikes);
                                    
                                    
                                 })
                                 
                                 
                                 
                                 
                             }
                        
                    
                             
                         }//close buttonAct
                        
                    })
                                   
                        })
                            }})
               
                    
                }//close buttonAct
        
        
        return cell;
    }
    
    func loadLikes(Message: String){
        
        
        var likedbyme = false
        //        for i in 0...self.posts2.count-1 {
        //         var postid =  self.posts2[i].postID
        var postid =  Message; Database.database().reference().child("posts").child(postid).child("likers").child(self.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any]{
                                likedbyme = true
                if let foo = self.self.posts2.first(where: { $0.postID == Message}){
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



extension ProfileViewController: newsCellDelegate {
    func didTapLocationButton(local: String) {
        // print("HERE")
        let vc = AnnotationTableViewController()
        vc.spot = local
        let navController = UINavigationController(rootViewController: vc)
        
        present(navController, animated: true, completion: nil)
    }
    
    func didTapProfile(name: String, profilePicture: UIImage, nameid: String){
        //print("now im here")
        
        let vc = AccountViewController()
        // print(id)
        vc.profilePicture = profilePicture
        vc.name = name
        vc.nameID = uid!
        let navController = UINavigationController(rootViewController: vc)
        
        present(navController, animated: true, completion: nil)
    }
}

extension ProfileViewController: UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
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









