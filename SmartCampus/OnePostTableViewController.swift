//
//  OnePostTableViewController.swift
//  SmartCampus
//
//  Created by Tomas Chavez on 8/12/19.
//  Copyright © 2019 Tommy Chavez. All rights reserved.
//

import UIKit

import FirebaseDatabase
import FirebaseAuth

class OnePostTableViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    let uid = Auth.auth().currentUser?.uid
    var postid = ""
    var posts2 = [Post]()
    let commentArea: UITextView = UITextView(frame: CGRect(x: 10, y: 695, width: Int(UIScreen.main.bounds.width-90), height: 30));
     let tableView: UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 695));
 
    let commentButton:UIButton = UIButton(frame: CGRect(x:  Int(UIScreen.main.bounds.width - 60) , y: 695, width: 40 , height: 30));
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        loadPost(completion: { message in
            
            
            self.loadLikers(Message: message)
            self.loadLikes(Message: message)
            self.loadcomments(Message: message)
            // miniposts.removeAll()
           
            
        })
        print(posts2.count)
        
        tableView.register(newsCell.self, forCellReuseIdentifier: "onecell")
        tableView.delegate = self
        tableView.dataSource = self
        
        
        view.addSubview(tableView)
        view.addSubview(commentArea)
        view.addSubview(commentButton)
        let bottomOffset = CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.frame.size.height)
        //self.tableView.setContentOffset(bottomOffset, animated: false)
       // commentArea.delegate = self
        //commentArea.becomeFirstResponder()
        commentArea.layer.borderWidth = 1
        commentArea.layer.cornerRadius = 2//  loadfriendS()
        commentButton.backgroundColor = UIColor.blue
        commentButton.setTitle("Add Comment", for: .normal)
        commentButton.titleLabel?.textAlignment = .center
        commentButton.titleLabel?.adjustsFontSizeToFitWidth = true
        commentButton.titleLabel?.numberOfLines = 2
        commentButton.layer.cornerRadius = 3
       // commentButton.addTarget(self, action: #selector(commentButtonAct), for: .touchUpInside)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
         self.loadPosts2()
    
              AppUtility.lockOrientation(.portrait)
        }
            
            override func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)

                // Don't forget to reset when view is being removed
                AppUtility.lockOrientation(.all)
            }
    
    var tommy123 = [Post]()
    
    fileprivate func loadPosts2(){
    
        Database.database().reference().child("comments").child(postid).child("comments").observe(.childAdded) {(snapshot: DataSnapshot) in
            //print("HERE")
            let postid = snapshot.key
            //  print(postid)
            if let dict = snapshot.value as? [String: Any]{
                let captionText = dict["comment"] as! String
                print(captionText)
                //let captionText = "Caption"
                let photoURLString = dict["commenterurlpic"] as! String
                //backgroundTableCellSize = 400
                let USERNAME = dict["commentername"] as! String
                let locationText =  dict["commentorreply"] as! String
                print(locationText)
                let likes = 0 //dict["numberoflikes"] as! Int
                let postcount = 0 //dict["charactercount"] as! Int
                
                
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
                    , photoURLString: photoURLString, USERNAME: USERNAME, locationText: locationText, likes: likes, likedbyme: likedbyme, postid: postid, postcount: postcount, Audio64: Audio64, postTime: postTime,likerArray: likerarray, likersString: "",numberOfComments: 0, Global: true, postOrEvent: "post", timestartstring: "",  timeendstring: timeendstring, displayname: "", profimg: "", score: 0, spaces: 0)
                
                self.tommy123.append(post2)
                
                //  self.tommy123.insert(post2, at: 0 )
                var spot = -1
                print("just added comment"); Database.database().reference().child("comments").child(postid).child("comments").child(postid).child("replies").observe(.childAdded) {(snapshot: DataSnapshot) in
                    //print("HERE")
                    let postid2 = postid
                    let postid = snapshot.key
                    //  print(postid)
                    if let dict = snapshot.value as? [String: Any]{
                        let captionText = dict["comment"] as! String
                        print(captionText)
                        //let captionText = "Caption"
                        let photoURLString = dict["commenterurlpic"] as! String
                        //backgroundTableCellSize = 400
                        let USERNAME = dict["commentername"] as! String
                        let locationText =  dict["commentorreply"] as! String
                        //print(locationText)
                        let likes = 0 //dict["numberoflikes"] as! Int
                        let postcount = 0 //dict["charactercount"] as! Int
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
                        
                        
                        
                        
                        
                        
                        let post = Post(captionText: captionText
                            , photoURLString: photoURLString, USERNAME: USERNAME, locationText: locationText, likes: likes, likedbyme: likedbyme, postid: postid, postcount: postcount, Audio64: Audio64, postTime: postTime,likerArray: likerarray, likersString: "",numberOfComments: 0, Global: true, postOrEvent: "post", timestartstring: "",  timeendstring: timeendstring, displayname: "", profimg: "" , score: 0, spaces: 0)
                        //
                        // self.tommy123.append(post2)
                        if(spot == -1){
                            if let foo = self.tommy123.enumerated().first(where: {$0.element.postID == postid2}) {
                                spot = foo.offset + 1
                                self.tommy123.insert(post, at: foo.offset+1 )
                                //self.tommy123[foo.offset+1] = post
                                // do something with foo.offset and foo.element
                            } else {
                                // item could not be found
                            }//close else
                            
                        }//if spot ==-1
                        else {
                            print("We in here baby")
                            self.tommy123.insert(post, at: spot+1)
                        }
                        
                        
                        //  print("just added reply")
                        //    self.tommy123.insert(post, at: 0 )
                        DispatchQueue.main.async(execute: {
                            spot = -1
                            self.tableView.reloadData()
                        })
                    }
                }
                
                
                
                
                // self.tommy123.insert(post, at: 0 )
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
                
                
                
                
            }
        }
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
                
                likedbyme = true
                if let foo = self.posts2.first(where: { $0.postID == Message}){
                    print("WE REALLY IN THERE")
                    print(foo.likedby)
                    foo.likedby =  true
                    print(foo.likedby)
                }
                else {
                    
                }
                //                    print(likedbyme)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    //  completion("loadlikes")
                })
                
            }
        })
        
        
        
    }
    

    
    
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
            if let foo = posts.first(where: { $0.postID == Message}){
                
                
                
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
            print(commentnum)
            if let foo = posts.first(where: { $0.postID == Message}){
                foo.numberofcomments = commentnum
            }
            
            //  print(commentnum)
            
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
                //  completion("loadlikes")
            })
            
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

    // MARK: - Table view data source

      func loadPost(completion: @escaping (_ message: String) -> Void){
        print("im here!");
        print(postid)
        Database.database().reference().child("posts").child(postid).observeSingleEvent(of: .value, with: { (snapshot) in
            print("IN HERE BUDDY")
            let postid = snapshot.key
            //  print(postid)
            if let dict = snapshot.value as? [String: Any]{
                let captionText = dict["caption"] as! String
                //let captionText = "Caption"
                let photoURLString = dict["imageUrl"] as! String
                //backgroundTableCellSize = 400
                let USERNAME = dict["usersName"] as! String
                let locationText = dict["location"] as! String
                let likes = dict["numberoflikes"] as! Int
                let postcount = dict["charactercount"] as! Int
                let global = dict["Global"] as! Bool
                let postorevent = dict["postorevent"] as! String
                print(postorevent)
                var likedbyme = false ;
                var likerarray = [User2] ()
                
                let sizer = Int(posts.count)
                
                
                var likersstring = "";
                
                
                let postnumber = postid
                let postTime = dict["creationDate"] as! TimeInterval
                // let Audio64 = dict["Audio64"] as! String
                let Audio64 = dict["Audio64"] as! String
                //  print(Audio64)
                //405
                let timeendstring =  dict["EndDateString"] as! String
                let timestartstring = dict["StartTimeString"] as! String
                
                
                let post = Post(captionText: captionText
                    , photoURLString: photoURLString, USERNAME: USERNAME, locationText: locationText, likes: likes, likedbyme: likedbyme, postid: postid, postcount: postcount, Audio64: Audio64, postTime: postTime,likerArray: likerarray, likersString: likersstring,numberOfComments: 0, Global: global, postOrEvent: postorevent , timestartstring: timestartstring, timeendstring: timeendstring, displayname: "", profimg: "" , score: 0, spaces: 0)
                // posts.append(post)
                self.posts2.insert(post, at: 0 )
                DispatchQueue.main.async(execute: {
                     completion(postid)
                    self.tableView.reloadData()
                })
             
            }
            
        })
        
        
        
    }//end of load posts

    
    func tableView(  _ tableView: UITableView, heightForRowAt indexPath: IndexPath)->CGFloat{
    if(indexPath.row == 0){
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
    }
        return 80
    }
    
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//      //  return posts2.count + tommy123.count
//      return tommy123.count
//    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return posts2.count + tommy123.count
        return posts2.count + tommy123.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "onecell", for: indexPath) as! newsCell
    
        if(indexPath.row == 0){
            print("liked by")
            print(posts2[indexPath.row].likedby)
        cell.userid = posts2[indexPath.row].usersName;
        
        
        
        
        let toId = posts2[indexPath.row].usersName
        let isGlobal = posts2[indexPath.row].global
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
            var timeStampString: String
            
            var difference =  Int( Date().timeIntervalSince1970 - posts2[indexPath.row].posttime)
            if(difference<60){
                if(difference<10){
                    timeStampString = "Just Posted"
                }
                else {
                    timeStampString = String(difference)
                    cell.timeStamp.text = "\(timeStampString) seconds ago"
                }
            }
                
            else if(difference < 3600){
                difference = difference/60
                timeStampString = String(difference)
                if(timeStampString == "1"){
                    cell.timeStamp.text = "\(timeStampString) minute ago"
                }
                else{
                    cell.timeStamp.text = "\(timeStampString) minutes ago"
                }
            }
                
            else if(difference < 86400){
                difference = difference/3600
                timeStampString = String(difference)
                if(timeStampString == "1"){
                    cell.timeStamp.text = "\(timeStampString) hour ago"
                }
                else{
                    cell.timeStamp.text = "\(timeStampString) hours ago"
                }
                
            }
                
            else {//if(difference < 86400){
                difference = difference/86400
                timeStampString = String(difference)
                if(timeStampString == "1"){
                    cell.timeStamp.text = "\(timeStampString) day ago"
                }
                else{
                    cell.timeStamp.text = "\(timeStampString) days ago"
                }
                
            }
            
            // print(posts[indexPath.row].postID)
            //cell.CommentStamp.text = posts[indexPath.row].
            
            
            
            
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
                
                
                cell.nameButton.setTitle(username, for: .normal)
                cell.cellID = toId
                cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: profileimageURL)
                
                let numberoflines = ((self.posts2[indexPath.row].postCount)/42)+1 // %42
                
                let height = numberoflines * 24
                
                
                
                //cell.postText.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
                
                cell.postText.frame.size.height = CGFloat(height) //https://stackoverflow.com/questions/38391528/how-to-set-dynamic-label-size-in-uitableviewcell
                cell.postText.text = self.posts2[indexPath.row].caption
                var local2    = (self.posts2[indexPath.row].location)
                local2 = "@\(local2)"
                cell.locationButton.setTitle(local2, for: .normal)
                
                
                //cell.songid =  posts2[indexPath.row].audio64;
                cell.songid = "noaudio"
                if(cell.songid != "noaudio"){
                    //  cell.backgroundCell.heightAnchor.constraint(equalToConstant:  80).isActive = true
                    cell.coverartphoto.image = UIImage(named: "kanye"); cell.coverartphoto.heightAnchor.constraint(equalToConstant: 50).isActive = true
                }
                
                if(cell.songid == "noaudio"){ //cell.backgroundCell.heightAnchor.constraint(equalToConstant:  0).isActive = true
                    cell.coverartphoto.heightAnchor.constraint(equalToConstant: 0).isActive = true
                    
                }
                
                //cell.likeLabel.text = String( posts2[indexPath.row].numberoflikes)
                let url = self.posts2[indexPath.row].imageUrl
                cell.postImage.loadImageUsingCacheWithUrlString(urlString: url)
                //cell.likeLabel.text = String(posts2[indexPath.row].numberoflikes)
               // cell.delegate = self //ADDED
                
                //            DispatchQueue.main.async(execute: {
                //                                                                    self.tableView.reloadData()
                //                                                                })
                
                
                
                
                
                
                
                cell.commentAct = { sender in
                    
                    let vc = commeListController()
                    vc.postId = self.posts2[indexPath.row].postID
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }//close comment act
                
                
            })
            
        }
        if(posts2[indexPath.row].postorevent == "event"){
            //cell.nameButton.setTitle(posts[indexPath.row].posterUsername, for: .normal)
            cell.timeStamp.isHidden =  true
            cell.DateStamp.isHidden =  false
            cell.DateStamp2.isHidden = false
            cell.threedots.isHidden =  true
            
            cell.DateStamp.text = (posts2[indexPath.row].timeStartString)
            cell.DateStamp2.text = (posts2[indexPath.row].timeEndString)
            
            cell.locationButton.setTitle("@\(posts2[indexPath.row].location)", for: .normal)
            cell.postText.font = .boldSystemFont(ofSize: 20)
            cell.postText.text = posts2[indexPath.row].caption
            
            cell.descriptionButt.isHidden = false;
            let numberoflines = ((posts2[indexPath.row].postCount)/42)+1 // %42
            
            let height = numberoflines * 24
            
            
            
            
            
            cell.descriptionButt.frame.size.height = CGFloat(height);
            cell.descriptionButt.text = posts2[indexPath.row].audio64;
            
            
            let ref = Database.database().reference().child("users").child(toId)
            Database.database().reference().child("users").child(toId).observeSingleEvent(of: .value, with: { (snapshot) in
                //print(snapshot.value ?? "")
                
                let dictionary = snapshot.value as? [String: Any]
                let username = dictionary?[ "username"] as? String
                
                guard let profileimageURL = dictionary?[ "ProfileImage"] as? String else {return}
                
                
                cell.nameButton.setTitle(username, for: .normal)
                cell.cellID = toId
                cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: profileimageURL)
                
                if(isGlobal){
                    cell.globalButton.setImage(UIImage(named:"earth"), for: .normal)
                }
                else if(isGlobal==false){
                    cell.globalButton.setImage(UIImage(named:"lock"), for: .normal)
                    
                }
                cell.timeStamp.isHidden =  true
                cell.postImage.isHidden = true
                
                
            })
            
        }
        
        
        cell.buttonAct = { sender in
            var useridpluspostid = ""
            var name = cell.userid
            useridpluspostid = "\(self.uid!)\(cell.cellID)";
            if( self.posts2[indexPath.row].likedby == false){
                
                
                let noti = ["Notification Type": "Like","ID Number": cell.cellID,"Userid":self.uid! ] as [String : Any]
                
                Database.database().reference().child("users").child(cell.userid!).child("notifications").child(useridpluspostid).updateChildValues(noti);
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
                print("liked")
                self.loadLikers2( Message: self.posts2[indexPath.row].postID, completion: { message in
                    
                    print("in here")
                    cell.likerstring.text = self.posts2[indexPath.row].likersstring
                })
                
            }
            else if( self.posts2[indexPath.row].likedby == true){
                self.posts2[indexPath.row].likedby = false
                let heartFilled = UIImage(named: "heartempty")
                Database.database().reference().child("users").child(cell.userid!).child("notifications").child(useridpluspostid).removeValue()
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
        
        }
        else {
            if(tommy123[indexPath.row-1].location == "comment"){
                //  print("COMMENT COMMENT COMMENT")
                //cell.replypostText.text = tommy123[indexPath.row].caption;
                cell.nameButton.setTitle(tommy123[indexPath.row-1].usersName, for: .normal)
                cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: tommy123[indexPath.row-1].imageUrl)
                
                cell.postText.text  = tommy123[indexPath.row-1].caption
                
                
                cell.threedots.setImage(UIImage(named:"reply_icon"), for: .normal)
                //cell.locationButton.setTitle("2 hours ago", for: .normal)
                print("Time end string")
                print( tommy123[indexPath.row-1].timeEndString);
                cell.locationButton.setTitle(tommy123[indexPath.row-1].timeEndString, for: .normal)
                
                var timeStampString: String
            }
                
                
                
            else if(tommy123[indexPath.row-1].location == "reply"){
                cell.threedots.isHidden =  true
                // print("REPLY REPLY REPLY")
                cell.replynameButton.setTitle(tommy123[indexPath.row-1].usersName, for: .normal)
                cell.replyprofileImageViewTop.loadImageUsingCacheWithUrlString(urlString: tommy123[indexPath.row-1].imageUrl)
                cell.replypostText.text  = tommy123[indexPath.row-1].caption
                
                var timeStampString: String
                
                cell.replylocationButton.setTitle(tommy123[indexPath.row-1].timeEndString, for: .normal)
                
                //cell.timeStamp.text = "\(timeStampString) seconds ago"
            }
            
            
            cell.commentButton.isHidden = true
            cell.likeButton.isHidden = true
            cell.CommentStamp.isHidden = true
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
            
            
            
            
            
            
            
        }
        return cell;
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
}
