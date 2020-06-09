//
//  File.swift
//  SmartCampus
//
//  Created by Tommy Chavez on 6/13/19.
//  Copyright © 2019 Tommy Chavez. All rights reserved.
//

import UIKit
import Firebase



class friendsListController: UITableViewController{
       let cellId = "cellId"
   var  userid = "0"
 
    override func viewDidLoad() {
        super.viewDidLoad()
      view.backgroundColor = UIColor.white
        
      tableView.register(searchCell.self, forCellReuseIdentifier: cellId)
       // tableView.dataSource = self
        //tableView.delegate = self
        loadfriendS(completion: { message in
            self.loadusers(Message: message)
    })
    
              AppUtility.lockOrientation(.portrait)
        }
            
            override func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)

                // Don't forget to reset when view is being removed
                AppUtility.lockOrientation(.all)
            }
    
    
    func loadusers(Message: String){
        Database.database().reference().child("users").child(Message).observeSingleEvent(of: .value, with: { (snapshot) in
            print("snap")
            print(snapshot.value)
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                //id = snapshot.key
                let dictionary = snapshot.value as? [String: Any]
                let snapshotkey = snapshot.key
                let username = dictionary?[ "username"] as? String
                guard let profileimageURL = dictionary?[ "ProfileImage"] as? String else {return}
                let user = User(dictionary: dictionary as! [String : AnyObject])
                user.id = snapshotkey
                print("name")
                print(username)
                user.name = username
                user.profileImageUrl = profileimageURL
                
                
                self.tommy123.append(user)
                //self.usersimageURL.append(profileimageURL)
                
                //this will crash because of background thread, so lets use dispatch_async to fix
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
                //                user.name = dictionary["name"]
            }
            
        }, withCancel: nil)
    }
    let uid = Auth.auth().currentUser?.uid
    
    var tommy123 = [User]()
    
    fileprivate func loadfriendS(completion: @escaping (_ message: String) -> Void){
        if(userid == "0"){
          userid = uid!
        }
        let ref = Database.database().reference().child("users").child(userid).child("friendsList")
        .observe(.childAdded) {(snapshot: DataSnapshot) in
            //print(snapshot.value)
            print(snapshot.key)
          
            guard let dict = snapshot.value as? [String: Any] else { return }
            print("SNAP:")
            
            let user = dict["username"] as! String
            print(user)
           completion(user)
            
            
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
            
        }
    }
    

    
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! searchCell
        print("HERE")

    cell.nameLabel2.text = tommy123[indexPath.row].name
    cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: tommy123[indexPath.row].profileImageUrl!)
    cell.userid  = tommy123[indexPath.row].id!
    return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tommy123.count
       // return friendsList.count
    }
    
    
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! searchCell
    
    
                let vc = AccountViewController()
                vc.name = tommy123[indexPath.row].name
                vc.nameID = tommy123[indexPath.row].id
                let profimage = UIImageView()
                profimage.loadImageUsingCacheWithUrlString(urlString: tommy123[indexPath.row].profileImageUrl!)
                vc.profilePicture =
                    profimage.image
                self.navigationController?.pushViewController(vc, animated: true)
            }
    
}

