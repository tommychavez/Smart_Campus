

import UIKit
import Firebase
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}


// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


class MessageViewController: UITableViewController, UITabBarControllerDelegate{
    
    let cellId = "cellId"
    
    @IBOutlet weak var messoractorreq: UISegmentedControl!
    
    @IBAction func topbuttonpush(_ sender: UISegmentedControl) {
    tableView.reloadData()
        print("HERE")
    }
    
    let activityTable: UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height));
    
    let friendrequestTable: UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height));
   
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let tabBarIndex = tabBarController.selectedIndex
        
        // print(tabBarIndex)
        
        if tabBarIndex == 0 {
            selectedIndex = 1
            
        }
        
        if tabBarIndex == 1 {
            
            // screenShotMethod()
            selectedIndex = 1
            
        }
        if tabBarIndex == 2 {
            if(selectedIndex == 3){
                screenShotMethod()
            }
            
            //shouldbeimage.image = screenshot
            
        }
        
        if tabBarIndex == 3 {
            //screenShotMethod()
            selectedIndex = 3
            
        }
        
        if tabBarIndex == 4 {
            // screenShotMethod()
            selectedIndex = 4
            
        }
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        selectedIndex = 3
        self.tabBarController?.delegate = self
        
        activityTable.register(UserCell.self, forCellReuseIdentifier: "activityCell")
        activityTable.delegate = self
        activityTable.dataSource = self
        //activityTable.backgroundColor = UIColor.red
       self.view.addSubview(activityTable)
        activityTable.isHidden = true
        
        friendrequestTable.register(UserCell.self, forCellReuseIdentifier: "friendCell")
        friendrequestTable.delegate = self
        friendrequestTable.dataSource = self
       
        self.view.addSubview(friendrequestTable)
        
       friendrequestTable.isHidden = true
        
        let image = UIImage(named: "new_message_icon")
        //navigationItem.title = "MESSAGES"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        checkIfUserIsLoggedIn()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        observeUserMessages()
        loadfriendrequests(completion: {
            message in
            self.friendrequestTable.reloadData()
            self.messoractorreq.setTitle("Requests (\(self.friendrequests.count))", forSegmentAt: 2)
            print("we here a")
        })
        loadnotifications(completion: {
            message in
            self.activityTable.reloadData()
            self.messoractorreq.setTitle("Activity (\(self.notiList.count))", forSegmentAt: 1)
          print("we here b")
        })
        print("we here")
         self.messoractorreq.setTitle("Requests (\(self.friendrequests.count))", forSegmentAt: 2)
        
        messoractorreq.setTitle("Messages (0)", forSegmentAt: 0)
        
        
    }
      let uid = Auth.auth().currentUser?.uid
    
     func loadnotifications(completion: @escaping (_ message: String) -> Void){
        
        Database.database().reference().child("users").child(uid!).child("notifications").observe(.childAdded, with: { (snapshot) in
            print("true")
            
           let postid2 = snapshot.key
            Database.database().reference().child("users").child(self.uid!).child("notifications").child(postid2).observe(.childAdded, with: {
                (snapshot) in
                let postid = snapshot.key
                
            let dictionary = snapshot.value as? [String: Any]
            var likerArray = [User2]()
            let userid = dictionary?[ "Userid"] as? String
            let notiType = dictionary?[ "Notification Type"] as? String
            let postnumber = dictionary?[ "ID Number"] as? String
            
                let post = Post(captionText: "", photoURLString: "", USERNAME: postid, locationText: postnumber!, likes: 0, likedbyme: true, postid: userid!, postcount: 0, Audio64: "", postTime: 0,likerArray: likerArray, likersString: "",numberOfComments: 0, Global: true, postOrEvent: notiType! , timestartstring: "", timeendstring: "", displayname: "", profimg: "", score: 0, spaces: 0)
            //self.notiList.append(post)
            self.notiList.insert(post, at: 0)
            self.fetchUsers(userid: userid!, postid: postid)
            DispatchQueue.main.async(execute: {
                completion("done")
              //  self.activityTable.reloadData()
            })
        })
        })
    }
    
    func fetchUsers(userid: String, postid: String ){
        Database.database().reference().child("users").child(userid).observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot.value ?? "")
            //  let postid = snapshot.key
            let dictionary = snapshot.value as? [String: Any]
            
            let username = dictionary?[ "username"] as? String
        
           let myProfilePicture = dictionary?[ "ProfileImage"] as? String
            
            if let foo = self.notiList.first(where: { $0.usersName == postid}){
                foo.usersName = username!
                foo.imageUrl = myProfilePicture!
                print("How many times")
            }
            
            
            DispatchQueue.main.async {
                //self.ProPic.image = image
                self.activityTable.reloadData()
            }
        })
    }
    
    var notiList = [Post]()
    
    func loadfriendrequests(completion: @escaping (_ message: String) -> Void){
        Database.database().reference().child("users").child(uid!).child("friendRequests").observe(.childAdded, with: { (snapshot) in
            print("true")
            print(snapshot.key)
            self.friendrequests.insert(snapshot.key, at: 0)
            
            DispatchQueue.main.async(execute: {
                completion("done")
               // self.friendrequestTable.reloadData()
            })
        })
    }
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    var friendrequests: [String] = Array()
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let message = self.messages[indexPath.row]
        
        if let chatPartnerId = message.chatPartnerId() {
            Database.database().reference().child("user-messages").child(uid).child(chatPartnerId).removeValue(completionBlock: { (error, ref) in
                
                if error != nil {
                    print("Failed to delete message:", error!)
                    return
                }
                
                self.messagesDictionary.removeValue(forKey: chatPartnerId)
                self.attemptReloadOfTable()
                
                //                //this is one way of updating the table, but its actually not that safe..
                //                self.messages.removeAtIndex(indexPath.row)
                //                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                
            })
        }
    }
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let userId = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                
                let messageId = snapshot.key
                self.fetchMessageWithMessageId(messageId)
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    fileprivate func fetchMessageWithMessageId(_ messageId: String) {
        let messagesReference = Database.database().reference().child("messages").child(messageId)
        
        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                
                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                }
                
                self.attemptReloadOfTable()
            }
            
        }, withCancel: nil)
    }
    
    fileprivate func attemptReloadOfTable() {
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    var timer: Timer?
    
    @objc func handleReloadTable() {
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            
            return message1.timestamp?.int32Value > message2.timestamp?.int32Value
        })
        
        //this will crash because of background thread, so lets call this on dispatch_async main thread
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == activityTable){
            return notiList.count
        }
        if(tableView == friendrequestTable){
          //  return 20
            return friendrequests.count
        }
            
        else{
        var count = 0
         if(messoractorreq.selectedSegmentIndex == 0){
        return messages.count
        }
        if(messoractorreq.selectedSegmentIndex == 1){
            return friendrequests.count
        }
        if (messoractorreq.selectedSegmentIndex == 2){
        return friendrequests.count
        }
        return count
        }
        return 100
    }
    
    @IBAction func actionforcontrolbar(_ sender: Any) {
        if(messoractorreq.selectedSegmentIndex == 0){
           activityTable.isHidden = true
            friendrequestTable.isHidden = true
            let image = UIImage(named: "new_message_icon")
            //navigationItem.title = "MESSAGES"
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
            
        }
        if(messoractorreq.selectedSegmentIndex == 1){
         activityTable.isHidden = false
            friendrequestTable.isHidden = true
            navigationItem.rightBarButtonItem = nil
            //tableView.isHidden  = true
        }
        if (messoractorreq.selectedSegmentIndex == 2){
            activityTable.isHidden = true
            friendrequestTable.isHidden = false
            navigationItem.rightBarButtonItem = nil
            //friendrequestTable.reloadData()
            //tableView.isHidden = true
        }
     
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == activityTable){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as! UserCell
           // cell.textLabel?.text = "activity"
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: notiList[indexPath.row].imageUrl)
            if(notiList[indexPath.row].postorevent == "Like" ){
            cell.friendLabel
                .text = "\(notiList[indexPath.row].usersName) liked your post"
            }
            if(notiList[indexPath.row].postorevent == "comment" ){
                cell.friendLabel
                    .text = "\(notiList[indexPath.row].usersName) commented on your post"
            }
            //cell.textLabel?.text = notiList[indexPath.row].postID
            cell.acceptButton.isHidden = true
            cell.declineButton.isHidden = true
            return cell
        }
            
        if(tableView == friendrequestTable){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! UserCell
           
            cell.buttonAct = { sender in
                print("DELETE"); Database.database().reference().child("users").child(cell.friendid).child("friendsList").child(self.uid!).setValue(["username": self.uid
                    ])
                
                
                Database.database().reference().child("users").child(self.uid!).child("friendsList").child( cell.friendid).setValue(["username": cell.friendid
                    ])
                Database.database().reference().child("users").child(self.uid!).child("friendRequests").child(cell.friendid).removeValue()
                self.friendrequests.remove(at: indexPath.row)
                tableView.reloadData()
            }
            Database.database().reference().child("users").child(friendrequests[indexPath.row]).observeSingleEvent(of: .value, with: { (snapshot) in
                cell.friendid = snapshot.key
                let dictionary = snapshot.value as? [String: Any];
                let username = dictionary?[ "username"] as? String;
                print(username)
                cell.friendLabel.text = username
                let url = dictionary?[ "ProfileImage"] as? String;
                cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: url!)
            })
            
            cell.nameLabel.text = ""
            cell.friendLabel.isHidden = false
            //  cell.friendLabel.text = friendrequests[indexPath.row]
            //friendrequests[indexPath.row]
            cell.acceptButton.isHidden = false
            cell.declineButton.isHidden = false
            cell.profileImageView.isHidden = false
            cell.profileImageView.image = UIImage(named: "whitesquare")
            cell.detailTextLabel?.text = ""
            cell.timeLabel.text = ""
            navigationItem.setRightBarButton(nil, animated: true)
            return cell
        }
        
        else {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        if(tableView == activityTable){
            print("HERE BABY")
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
            activityTable.delegate = self
            cell.profileImageView.image = UIImage(named: "whitesquare")
            return cell
        }
        if(messoractorreq.selectedSegmentIndex == 0){
        
            cell.acceptButton.isHidden = true
            cell.friendLabel.isHidden = true
              cell.declineButton.isHidden = true
          cell.profileImageView.isHidden = false
        let message = messages[indexPath.row]
        cell.message = message
            
        
        }
        if(messoractorreq.selectedSegmentIndex == 1){
            
            cell.nameLabel.text = ""
            cell.acceptButton.isHidden = true
              cell.friendLabel.isHidden = true
            cell.declineButton.isHidden = true
             cell.profileImageView.isHidden = true
            cell.profileImageView.image = UIImage(named: "whitesquare")
            cell.detailTextLabel?.text = ""
            cell.timeLabel.text = ""
            let image = UIImage(named: "whitesquare")
            //navigationItem.title = "MESSAGES"
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        
        
        if(messoractorreq.selectedSegmentIndex == 2){
           
            cell.buttonAct = { sender in
                print("DELETE"); Database.database().reference().child("users").child(cell.friendid).child("friendsList").updateChildValues(["\(self.uid!)": "1"])
                Database.database().reference().child("users").child(self.uid!).child("friendsList").updateChildValues(["\( cell.friendid)": "1"])
                Database.database().reference().child("users").child(self.uid!).child("friendRequests").child(cell.friendid).removeValue()
                self.friendrequests.remove(at: indexPath.row)
                tableView.reloadData()
            }
            Database.database().reference().child("users").child(friendrequests[indexPath.row]).observeSingleEvent(of: .value, with: { (snapshot) in
                cell.friendid = snapshot.key
                let dictionary = snapshot.value as? [String: Any];
                let username = dictionary?[ "username"] as? String;
                print(username)
                 cell.friendLabel.text = username
                 let url = dictionary?[ "ProfileImage"] as? String;
                cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: url!)
            })
            
            cell.nameLabel.text = ""
            cell.friendLabel.isHidden = false
          //  cell.friendLabel.text = friendrequests[indexPath.row]
            //friendrequests[indexPath.row]
            cell.acceptButton.isHidden = false
            cell.declineButton.isHidden = false
            cell.profileImageView.isHidden = false
            cell.profileImageView.image = UIImage(named: "whitesquare")
            cell.detailTextLabel?.text = ""
            cell.timeLabel.text = ""
            navigationItem.setRightBarButton(nil, animated: true)
        }
       return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as! UserCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == activityTable){
            print("im also in here")
            
            return 72
        }
        if(tableView == friendrequestTable){
            print("friends:)")
            
            return 72
        }
            
        else {
            return 72
        }
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView == activityTable){
            if(messoractorreq.selectedSegmentIndex == 1){
                
                let vc = OnePostTableViewController()
                vc.postid = notiList[indexPath.row].location;
                
                print(notiList[indexPath.row].location)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else{
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User(dictionary: dictionary)
            
            user.id = chatPartnerId
            let username = dictionary[ "username"] as? String
            user.name = username; self.showChatControllerForUser(user)
            
        }, withCancel: nil)
        }
    
       
    }
    
    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetupNavBarTitle()
        }
    }
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //                self.navigationItem.title = dictionary["name"] as? String
                
                let user = User(dictionary: dictionary)
                self.setupNavBarWithUser(user)
            }
            
        }, withCancel: nil)
    }
    
    func setupNavBarWithUser(_ user: User) {
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        observeUserMessages()
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        //        titleView.backgroundColor = UIColor.redColor()
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        containerView.addSubview(profileImageView)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        
        containerView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        //need x,y,width,height anchors
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
       // self.navigationItem.titleView = titleView
        
        //        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
    }
    
    func showChatControllerForUser(_ user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
    }
    
}
