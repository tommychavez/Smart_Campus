//
//  SearchViewController.swift
//  SmartCampus
//
//  Created by Tommy Chavez on 1/9/19.
//  Copyright © 2019 Tommy Chavez. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import AVKit


protocol searchCellDelegate {
   func didTapProfile(name: String, profilePicture: UIImage, nameid: String)
    
}

class SearchViewController: UIViewController,UITabBarControllerDelegate {
    
   
    @IBOutlet weak var locationLine: UIButton!
    
    @IBOutlet weak var PeopleLine: UIButton!
    @IBOutlet weak var SEARCHBUTTON: UIButton!
    
    @IBOutlet weak var peoplebutton: UIButton!
    @IBOutlet weak var locationbutton: UIButton!
    
    @IBAction func LocationButtonGo(_ sender: Any) {
       // mapline.isHidden = true;
        searchLocation = true
        searching = false
        searchBar.placeholder = "Search Location"
        searchBar.text = ""
        locationLine.backgroundColor = UIColor.black
        PeopleLine.backgroundColor = UIColor.white
        peoplebutton.setTitleColor(UIColor.lightGray, for: .normal)
        locationbutton.setTitleColor(UIColor.black, for: .normal)
         self.myTableView.reloadData()
        users.removeAll()
        myTableView.setContentOffset(.zero, animated: true)
        
       // self.myTableView.reloadData()
    }
    @IBAction func PeopleButtonGo(_ sender: Any) {
        searchLocation = false
        searchBar.placeholder = "Search People"
        locationLine.backgroundColor = UIColor.white
        PeopleLine.backgroundColor =    UIColor.black
        
        peoplebutton.setTitleColor(UIColor.black, for: .normal)
        locationbutton.setTitleColor(UIColor.lightGray, for: .normal)
        self.myTableView.reloadData()
        myTableView.setContentOffset(.zero, animated: true)
        //mapline.isHidden = true;
       // self.myTableView.reloadData()
    }
    
    
    
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
            if(selectedIndex == 1){
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
    
    var delegate: searchCellDelegate?
    var searching = false
    var searchLocation = true
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var myTableView: UITableView!
    var searchedCountry:[String] = Array()
    var searchPeople :[User] = Array()
    let mapLoc = ["Art Building","Book Store","Business Center","CEFCU Stadium","Dorms","Engineering Building", "Downtown San Jose","Event Center","Greek Life","Health Center","Housing","MLK Jr Library","Music Building", "Parking","San Jose State University","Science Building","SRAC", "Student Union"]
    var location = ""
    var users :[User] = Array()
    var usersimageURL:[String] = Array()
    var usersimageURL2:[String] = Array()
    
   // var video64: NSString?
    override func viewDidLoad() {
        super.viewDidLoad()
      //  screenShotMethod()
        selectedIndex = 1
        PeopleLine.isHidden = true
        
        
        //locationLine.isHidden = true ;
        //locationbutton.setTitleColor(UIColor.gray, for: .normal);
         peoplebutton.setTitleColor(UIColor.gray, for: .normal);
        print("in search")
        searchBar.delegate = self
        searchBar.cornerRadiusV = 10.0
        
        
       
        
        //searchBar.backgroundColor = UIColor.white
       
    
        
        
        self.hideKeyBoardWhenTappedAround()
        myTableView.register(searchCell.self, forCellReuseIdentifier: "cell")
        
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.rowHeight = 50
        myTableView.tableFooterView = UIView()
         self.tabBarController?.delegate = self
     //   myTableView.separatorStyle = .none
     
              AppUtility.lockOrientation(.portrait)
        }
            
            override func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)

                // Don't forget to reset when view is being removed
                AppUtility.lockOrientation(.all)
            }

    
    @IBAction func locationButtonAct(_ sender: Any) {
        locationLine.isHidden = false;
        searchBar.text = ""
        searching = false
        searchLocation = true;
        //    mapbutt.setTitleColor(UIColor.gray, for: .normal);
         myTableView.setContentOffset(.zero, animated: true)
        print("here")
      //  self.myTableView.reloadData()
    }
    

    
    @IBAction func profileButtonAct(_ sender: Any) {
        PeopleLine.isHidden = false
         searchBar.text = ""
        searching = false
        searchLocation = false
        myTableView.setContentOffset(.zero, animated: true)
        print("here")
       //  self.myTableView.reloadData()
       // mapbutt.setTitleColor(UIColor.gray, for: .normal);
    }
    
    
    
    
   // @IBOutlet weak var mapbutt: UIButton!
    
   // @IBOutlet weak var mapline: UIButton!
    
//    @IBAction func mapbutton(_ sender: Any) {
//        locationLine.isHidden = true;
//        PeopleLine.isHidden = true;
//        mapline.isHidden = false;
//         mapbutt.setTitleColor(UIColor.black, for: .normal);
//         locationbutton.setTitleColor(UIColor.gray, for: .normal);
//          peoplebutton.setTitleColor(UIColor.gray, for: .normal);
//
//    }
    func fetchUser(SearchText: String) {
        var us = "US"
        
        Database.database().reference().child("users").queryOrdered(byChild: "username").queryStarting(atValue:SearchText).queryLimited(toFirst: 1).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
        
       
         // print(postid)
         
         for rest in snapshot.children.allObjects as! [DataSnapshot] {
            
         if let dictionary = rest.value as? [String: Any] {
            //id = snapshot.key
          //  let dictionary = snapshot.value as? [String: Any]
            let snapshotkey = snapshot.key
            let username = dictionary[ "username"] as? String
            print("username1:")
            print(username)
            if(username!.prefix(SearchText.count) == SearchText ){
                self.fetchuser2(SearchText: SearchText)
            }
        }}
        })
        
        
    }
    
    
    @objc func SearchRecords() {
        
        print("HERE")
        
        print(location)
        
    }
    
func fetchuser2(SearchText: String) {
    Database.database().reference().child("users").queryOrdered(byChild: "username").queryStarting(atValue:SearchText).queryLimited(toFirst: 10).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
     
    
      // print(postid)
      
      for rest in snapshot.children.allObjects as! [DataSnapshot] {
         
      if let dictionary = rest.value as? [String: Any] {
            //id = snapshot.key
            //let dictionary = snapshot.value as? [String: Any]
            let snapshotkey = snapshot.key
        
        let username = dictionary[ "username"] as? String
        print("username2:")
        print(username)
        guard let profileimageURL = dictionary[ "ProfileImage"] as? String else {return}
            let user = User(dictionary: dictionary as! [String : AnyObject])
            user.id = snapshotkey
            //print("name")
            //print(username)
            user.name = username
            user.profileImageUrl = profileimageURL
            
            
            self.users.append(user)
            //self.usersimageURL.append(profileimageURL)
            
            //this will crash because of background thread, so lets use dispatch_async to fix
            DispatchQueue.main.async(execute: {
                self.myTableView.reloadData()
            })
            
            //                user.name = dictionary["name"]
        }
        
    }
    })
    }
}



extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
  
    
     func tableView(  _ tableView: UITableView, heightForRowAt indexPath: IndexPath)->CGFloat{
     return 75
    }
    
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchLocation == true ){
            if searching {
                return searchedCountry.count
            } else {
                return mapLoc.count
            }
        }
        else {
        if searching {
            return users.count
        } else {
            print("user count")
            return users.count
        }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! searchCell
        //cell.selectionStyle = .none;
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
        
       // cell.imageView?.image = UIImage(named: "whitesquare")
        if(searchLocation == true){
            
            if searching {
               // cell.textLabel?.text = searchedCountry[indexPath.row]
              //  cell.imageView?.image = UIImage(named:
                //    "whitesquare")
                cell.nameLabel.text = searchedCountry[indexPath.row]
                cell.nameLabel2.text = ""
                 cell.profileImageViewTop.image = UIImage(named: "whitesquare")
            } else {
                //cell.textLabel?.text = mapLoc[indexPath.row]
                cell.nameLabel.text = mapLoc[indexPath.row]
                cell.nameLabel2.text = ""
                //cell.imageView?.image = UIImage(named: "whitesquare")
                cell.profileImageViewTop.image = UIImage(named: "whitesquare")
            }
            return cell
        }
            
        else {
           // if searching {
              // cell.textLabel?.text = searchPeople[indexPath.row].name
                
            cell.nameLabel2.text = users[indexPath.row].name
                cell.nameLabel.text = ""
                cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: users[indexPath.row].profileImageUrl!)
                cell.userid  = users[indexPath.row].id!
           // } else {
                
                
                
                
                
            
    }
            return cell
    }
    
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! searchCell
           if(searchLocation == true){
            
        let vc = AnnotationTableViewController()
            if(searchedCountry.count > 0){
                 vc.spot = searchedCountry[indexPath.row]
            }
            else{
                 vc.spot = mapLoc[indexPath.row]
            }
              self.navigationController?.pushViewController(vc, animated: true)
           }else{
            
           // let vc = AccountViewController()
            if(searchPeople.count > 0){
                print("Here baby")
                print(searchPeople[indexPath.row].id!)
                 let vc = AccountViewController()
                vc.name = searchPeople[indexPath.row].name
                 vc.nameID = searchPeople[indexPath.row].id
                 let profimage = UIImageView()
                profimage.loadImageUsingCacheWithUrlString(urlString: searchPeople[indexPath.row].profileImageUrl!)
                vc.profilePicture =
                    profimage.image
                self.navigationController?.pushViewController(vc, animated: true)
//                  delegate?.didTapProfile(name: searchPeople[indexPath.row].name ?? "", profilePicture: UIImage(named: "unknown")!, nameid: searchPeople[indexPath.row].id!)
//
            }
            else{
//                delegate?.didTapProfile(name: users[indexPath.row].name ?? "", profilePicture: UIImage(named: "unknown")!, nameid: users[indexPath.row].id!)
                print(users[indexPath.row].id!)
               print("Here baby")
                 let vc = AccountViewController()
                vc.name = users[indexPath.row].name
                vc.nameID = users[indexPath.row].id
                let profimage = UIImageView()
                profimage.loadImageUsingCacheWithUrlString(urlString: users[indexPath.row].profileImageUrl!)
                vc.profilePicture =
                    profimage.image
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
//            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        
    }
}





extension UIViewController {
    func hideKeyBoardWhenTappedAround(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print(searchText)
        if(searchLocation == true){
            if(searchText == ""){
                print("notext");
                searching = false
               // myTableView.reloadData()
            }
            else{
            print("in her")
            searchedCountry = mapLoc.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
            searching = true
           // users.removeAll()
            }
        }
        else {
            users.removeAll()
          print("IN HERE")
            if(searchText != ""){
         //users.removeAll();
            fetchuser2(SearchText: searchText)
               // contains(searchText.lowercased())) }
            
            searching = true
            }
        }
        myTableView.reloadData()
    }
    
    
    
}

extension SearchViewController: searchCellDelegate {
    func didTapProfile(name: String, profilePicture: UIImage, nameid: String){


        let vc = AccountViewController()
        // print(id)
        vc.profilePicture = profilePicture
        vc.name = name
        vc.nameID = nameid
         print("we here")
        self.navigationController?.pushViewController(vc, animated: true)
       
      
    }
}


class searchCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    var userid = ""
    
    let profileImageViewTop: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 24
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let ptext = UILabel()
        ptext.translatesAutoresizingMaskIntoConstraints = false
        ptext.layer.masksToBounds = true
        ptext.contentMode = .scaleAspectFill
        ptext.font = .systemFont(ofSize: 15)
        ptext.lineBreakMode = .byWordWrapping
        ptext.textColor = UIColor.black
        ptext.numberOfLines = 0
        return ptext
    }()
    
    
    let nameLabel2: UILabel = {
        let ptext = UILabel()
        ptext.translatesAutoresizingMaskIntoConstraints = false
        ptext.layer.masksToBounds = true
        ptext.contentMode = .scaleAspectFill
        ptext.font = .systemFont(ofSize: 15)
        ptext.lineBreakMode = .byWordWrapping
        ptext.textColor = UIColor.black
        ptext.numberOfLines = 0
        return ptext
    }()
    
    
    
    
    
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageViewTop)
        
         addSubview(nameLabel)
        
         addSubview(nameLabel2)
        
        
        profileImageViewTop.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        profileImageViewTop.widthAnchor.constraint(equalToConstant: 48).isActive = true
        //  profileImageViewTop.topAnchor.constraint(equalTo:  self.topAnchor, constant: 0).isActive = true
        profileImageViewTop.centerYAnchor.constraint(equalTo:  self.centerYAnchor, constant: 0).isActive = true
        profileImageViewTop.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
               nameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
               //  profileImageViewTop.topAnchor.constraint(equalTo:  self.topAnchor, constant: 0).isActive = true
               nameLabel.centerYAnchor.constraint(equalTo:  self.centerYAnchor, constant: 0).isActive = true
              nameLabel.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        nameLabel2.leftAnchor.constraint(equalTo: self.profileImageViewTop.rightAnchor, constant: 12).isActive = true
         nameLabel2.widthAnchor.constraint(equalToConstant: 200).isActive = true
         //  profileImageViewTop.topAnchor.constraint(equalTo:  self.topAnchor, constant: 0).isActive = true
         nameLabel2.centerYAnchor.constraint(equalTo:  self.centerYAnchor, constant: 0).isActive = true
        nameLabel2.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

