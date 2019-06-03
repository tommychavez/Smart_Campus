//
//  ProfileViewController.swift
//  SmartCampus
//
//  Created by Tommy Chavez on 1/9/19.
//  Copyright © 2019 Tommy Chavez. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController:  UIViewController {
    
    @IBOutlet weak var ProfileName: UINavigationItem!
    
    @IBOutlet weak var UsernameLabel: UILabel!
    var usernameString = ""{
        didSet{
            UsernameLabel.text = (usernameString)
        }
    }
    @IBOutlet weak var EmailLabel: UILabel!
    var emailString = ""{
        didSet{
            EmailLabel.text = (emailString)
        }
    }
    @IBOutlet weak var ProPic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    // ProfileName.title = Auth.auth().currentUser?.uid
        ProPic.layer.cornerRadius = ProPic.frame.width/2
        ProPic.layer.masksToBounds = true
        ProPic.layer.borderColor = UIColor.black.cgColor
        ProPic.layer.borderWidth = 3

        fetchUser()
        //setupProfileImage()
     
    }
    
    
    var user: User?
    fileprivate func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot.value ?? "")
            
             let dictionary = snapshot.value as? [String: Any]
            
            let username = dictionary?[ "username"] as? String
            let email = dictionary?["email"] as? String
            
            self.usernameString = username ?? "nil"
            self.emailString = email ?? "nil"
            guard let profileimageURL = dictionary?[ "ProfileImage"] as? String else {return}
            //print(username ?? "")
           //print(profileimageURL)
            self.ProfileName.title = username
            
            guard let url = URL(string: profileimageURL) else {return}
            URLSession.shared.dataTask(with: url ) { (data, repsonse,err) in
                guard let data = data else {return}
               // print(data)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                   self.ProPic.image = image
                }
            //print("Failed to fetch user:", err)
        } .resume()
        })
    }
    
    
    /**
plusphotobutton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
}

plusphotobutton.layer.cornerRadius = plusphotobutton.frame.width/2
plusphotobutton.layer.masksToBounds = true
plusphotobutton.layer.borderColor = UIColor.black.cgColor
plusphotobutton.layer.borderWidth = 3

dismiss(animated: true, completion: nil)
*/
}

