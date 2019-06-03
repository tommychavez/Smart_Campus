//
//  AccountViewController.swift
//  SmartCampus
//
//  Created by Tommy Chavez on 5/2/19.
//  Copyright © 2019 Tommy Chavez. All rights reserved.
//


import UIKit
import Firebase
import FirebaseDatabase

class AccountViewController: UIViewController {
    var name: String?
    var profilePicture = UIImage(named:"unknown")
    let tableView: UITableView = UITableView(frame: CGRect(x: 0, y: 200, width: 400.00, height: 700.00));
    var posts = [Post]()
    let cellId = "PostCell"
    
    let profileImageViewTop: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 100, width: 100.00, height: 100.00));
        //let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 24
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.title = name
        self.view.addSubview(tableView)
        tableView.register(newsCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        loadPosts()
        tableView.rowHeight = 450
       self.view.addSubview(profileImageViewTop)
        profileImageViewTop.image = profilePicture
        print("NAME")
        print(name)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
 
    func loadPosts(){
        Database.database().reference().child("posts").observe(.childAdded) {(snapshot: DataSnapshot) in
            //print("HERE")
            //print(snapshot.value)
            if let dict = snapshot.value as? [String: Any]{
                let captionText = dict["caption"] as! String
                //let captionText = "Caption"
                let photoURLString = dict["imageUrl"] as! String
                let USERNAME = dict["usersName"] as! String
                let locationText = dict["location"] as! String
                let likes = dict["numberoflikes"] as! Int
                let likedbyme = false
                let postid = ""
                let postcount = dict["charactercount"] as! Int
                let post = Post(captionText: captionText
                    , photoURLString: photoURLString, USERNAME: USERNAME, locationText: locationText, likes: likes, likedbyme: likedbyme, postid: postid, postcount: postcount)
                // posts.append(post)
               // if(locationText == self.spot){
                
            Database.database().reference().child("users").child(USERNAME).observeSingleEvent(of: .value, with: { (snapshot) in
                    //print(snapshot.value ?? "")
                    
                    let dictionary = snapshot.value as? [String: Any]
                    let username = dictionary?[ "username"] as? String
                if(username == self.name){
                    self.posts.insert(post, at: 0 )
                }
                print(self.posts)
                //print(snapshot.value)
                self.tableView.reloadData()
            })
            
            }
        }
    }
}

extension AccountViewController: UITableViewDataSource {
    func tableView( _ tableView:UITableView, numberOfRowsInSection section: Int)-> Int {
        return posts.count
    }//how many cells
    
    
    func tableView(  _ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! newsCell
        //  cell.backgroundColor = UIColor.gray
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
        let toId = posts[indexPath.row].usersName
        let ref = Database.database().reference().child("users").child(toId)
        Database.database().reference().child("users").child(toId).observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot.value ?? "")
            
            let dictionary = snapshot.value as? [String: Any]
            let username = dictionary?[ "username"] as? String
            
            guard let profileimageURL = dictionary?[ "ProfileImage"] as? String else {return}
            cell.nameButton.setTitle(username, for: .normal)
            
            cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: profileimageURL)
        })
        
        // cell.detailTextLabel?.text = posts[indexPath.row].caption
        cell.postText.text = posts[indexPath.row].caption
        let local2    = posts[indexPath.row].location
        cell.locationButton.setTitle(local2, for: .normal)
        let url = posts[indexPath.row].imageUrl
        guard let url2 = URL(string: url) else {
            return cell
        }
        
        cell.postImage.loadImageUsingCacheWithUrlString(urlString: url)
        cell.delegate = self //ADDED
        return cell
    }
    
}

extension AccountViewController: newsCellDelegate {
    func didTapLocationButton(local: String) {
        print("HERE")
        let vc = AnnotationTableViewController()
        vc.spot = local
        let navController = UINavigationController(rootViewController: vc)
        
        present(navController, animated: true, completion: nil)
    }
    
    func didTapProfile(name: String, profilePicture: UIImage){
        print("now im here")
        
        let vc = AccountViewController()
        print(id)
        vc.profilePicture = profilePicture
        vc.name = name
        let navController = UINavigationController(rootViewController: vc)
        
        present(navController, animated: true, completion: nil)
    }
}


