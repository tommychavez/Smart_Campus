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

class AnnotationTableViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var photo = false
    var spot: String?
    var pickedImage: UIImage?
    var postText: String?
    
    let tableView: UITableView = UITableView(frame: CGRect(x: 0, y: 200, width: 400.00, height: 700.00));
    let myTextField: UITextField = UITextField(frame: CGRect(x: 0, y: 100, width: 200, height: 100.00));
    
    
    var posts = [Post]()
    let cellId = "PostCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.title = spot
        self.view.addSubview(tableView)
        tableView.register(newsCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        loadPosts()
        tableView.rowHeight = 450
        
        let rectSpace: UIImageView = UIImageView(frame: CGRect(x: 0, y: 100, width: 400.00, height: 200.00));
       
        myTextField.borderStyle = UITextField.BorderStyle.roundedRect
        myTextField.textAlignment = .left
        myTextField.contentVerticalAlignment = .top
        myTextField.placeholder = "What would you like to say about \(spot!).."
       
        let postButt: UIButton = UIButton(frame: CGRect(x: 300, y: 100, width: 75.00, height: 25.00));
        postButt.setTitle("Add Photo", for: .normal
        )
        postButt.backgroundColor = UIColor.purple
        let POST: UIButton = UIButton(frame: CGRect(x: 300, y: 150, width: 50.00, height: 25.00));
        POST.setTitle("Post", for: .normal
        )
        POST.backgroundColor = UIColor.green
        self.view.addSubview(rectSpace)
        self.view.addSubview(myTextField)
        self.view.addSubview(postButt)
        self.view.addSubview(POST)
        postButt.addTarget(self, action: #selector(handlePlusPhoto2), for: .touchUpInside)
        POST.addTarget(self, action: #selector(handlePost), for: .touchUpInside)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
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
            
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            pickedImage = originalImage
        }
        photo = true
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func handlePost() {
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
        let ref = userPostRef.childByAutoId()
        
        
        
        let values = ["imageUrl": imageUrl, "caption": caption,
                      "location": locationText,"imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "usersName": uid, "creationDate": Date().timeIntervalSince1970] as [String : Any]
        
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to DB", err)
                return
            }
            
            print("Successfully saved post to DB")
            //   self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    fileprivate func saveToDatabaseWithNoMedia() {
        //guard let postImage = pickedImage else { return }
        guard let caption = myTextField.text else { return }
        // guard let locationText = locationTextField.text, !locationText.isEmpty else { return }
        let locationText = spot
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        print(caption)
        
        let userPostRef = Database.database().reference().child("posts")
        let ref = userPostRef.childByAutoId()
        
        let values = ["imageUrl": "noImage", "caption": caption,
                      "location": locationText,"imageWidth": 0, "imageHeight": 0, "usersName": uid, "creationDate": Date().timeIntervalSince1970] as [String : Any]
        
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to DB", err)
                return
            }
            
            print("Successfully saved post to DB")
             self.tableView.reloadData()
            //            self.dismiss(animated: true, completion: nil)
        }
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
                let postid = ""
                let likedbyme = false 
                let likes = dict["numberoflikes"] as! Int
                let postcount = dict["charactercount"] as! Int
                let post = Post(captionText: captionText
                    , photoURLString: photoURLString, USERNAME: USERNAME, locationText: locationText, likes: likes, likedbyme: likedbyme, postid: postid, postcount: postcount )
                // posts.append(post)
                if(locationText == self.spot){
                    self.posts.insert(post, at: 0 )
                }
                print(self.posts)
                //print(snapshot.value)
                self.tableView.reloadData()
                self.myTextField.text = ""
                self.myTextField.placeholder = "What would you like to say ..."
                self.pickedImage = nil
                self.photo = false
            }
        }
    }
}//end


extension AnnotationTableViewController: UITableViewDataSource {
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

extension AnnotationTableViewController: newsCellDelegate {
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
