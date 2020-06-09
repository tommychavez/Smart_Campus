

import UIKit

class User: NSObject {
    var id: String?
    var name: String?
    var email: String?
    var profileImageUrl: String?
    
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
    }
 
}

//Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
//
//    if let dictionary = snapshot.value as? [String: AnyObject] {
//        let user = User(dictionary: dictionary)
//        user.id = snapshot.key
//        self.users.append(user)
//        
//        //this will crash because of background thread, so lets use dispatch_async to fix
//        DispatchQueue.main.async(execute: {
//            self.tableView.reloadData()
//        })
//
//        //                user.name = dictionary["name"]
//    }
//
//}, withCancel: nil)
//}

