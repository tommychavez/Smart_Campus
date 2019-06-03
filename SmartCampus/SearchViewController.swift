//
//  SearchViewController.swift
//  SmartCampus
//
//  Created by Tommy Chavez on 1/9/19.
//  Copyright © 2019 Tommy Chavez. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController {

    
    @IBOutlet weak var locationLine: UIButton!
    
    @IBOutlet weak var PeopleLine: UIButton!
    @IBOutlet weak var SEARCHBUTTON: UIButton!
    
    @IBOutlet weak var peoplebutton: UIButton!
    @IBOutlet weak var locationbutton: UIButton!
    
    @IBAction func LocationButtonGo(_ sender: Any) {
        searchLocation = true
        searchBar.placeholder = "Search Location"
        locationLine.backgroundColor = UIColor.black
        PeopleLine.backgroundColor = UIColor.white
        peoplebutton.setTitleColor(UIColor.lightGray, for: .normal)
        locationbutton.setTitleColor(UIColor.black, for: .normal)
         self.myTableView.reloadData()
    }
    @IBAction func PeopleButtonGo(_ sender: Any) {
        searchLocation = false
        searchBar.placeholder = "Search People"
        locationLine.backgroundColor = UIColor.white
        PeopleLine.backgroundColor =    UIColor.black
        
        peoplebutton.setTitleColor(UIColor.black, for: .normal)
        locationbutton.setTitleColor(UIColor.lightGray, for: .normal)
        
        self.myTableView.reloadData()
    }
   
    
    
    
    var searching = false
    var searchLocation = true
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var myTableView: UITableView!
    var searchedCountry:[String] = Array()
    var searchPeople :[String] = Array()
    let mapLoc = ["ATM Machines", "Charles W. Davidson Building","CVB","Martin Luther King Jr Library","San Jose State University (default)","SPARQ"]
    var location = ""
    var users :[String] = Array()
    var usersimageURL:[String] = Array()
     var usersimageURL2:[String] = Array()
  
    override func viewDidLoad() {
        super.viewDidLoad()
         PeopleLine.backgroundColor = UIColor.white
        
     searchBar.delegate = self
      
        fetchUser()
     

       
        self.hideKeyBoardWhenTappedAround()
        myTableView.register(searchCell.self, forCellReuseIdentifier: "cell")
       
    myTableView.delegate = self
    myTableView.dataSource = self
   myTableView.rowHeight = 50
        
        
    }
    
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                //id = snapshot.key
                let dictionary = snapshot.value as? [String: Any]
                let username = dictionary?[ "username"] as? String
                guard let profileimageURL = dictionary?[ "ProfileImage"] as? String else {return}
            
                self.users.append(username!)
                self.usersimageURL.append(profileimageURL)
                
                //this will crash because of background thread, so lets use dispatch_async to fix
                DispatchQueue.main.async(execute: {
                    self.myTableView.reloadData()
                })
                
                //                user.name = dictionary["name"]
            }
            
        }, withCancel: nil)
    }
    
    
    @objc func SearchRecords() {
        
        print("HERE")
        
     print(location)
    
    }
    
  
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchLocation == true ){
        if searching {
            return searchedCountry.count
        } else {
            return mapLoc.count
        }
    }
        if searching {
            return searchPeople.count
        } else {
            return users.count
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! searchCell
        cell.imageView?.image = UIImage(named: "whitesquare")
        if(searchLocation == true){
            
        if searching {
            cell.textLabel?.text = searchedCountry[indexPath.row]
             cell.imageView?.image = UIImage(named: "whitesquare")
        } else {
            cell.textLabel?.text = mapLoc[indexPath.row]
             cell.imageView?.image = UIImage(named: "whitesquare")
        }
            return cell
        }
    
   else {
            if searching {
                cell.textLabel?.text = searchPeople[indexPath.row]
            } else {
               
                
        let user = users[indexPath.row]
                let profileImageUrl =  usersimageURL[indexPath.row]
          //cell?.textLabel?.text = "tommy"
                cell.textLabel?.text = user
                cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
       
        
//        if let profileImageUrl = user.profileImageUrl {
//           // cell?.imageView?.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
//        }
        
        
        }
            return cell
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
        if(searchLocation == true){
        searchedCountry = mapLoc.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        }
        else {
            searchPeople = users.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
            searching = true
            
        }
        myTableView.reloadData()
    }
    

    
}


class searchCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
    let profileImageViewTop: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 24
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
   
    
    
    
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageViewTop)
        
        
        profileImageViewTop.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        profileImageViewTop.widthAnchor.constraint(equalToConstant: 48).isActive = true
      //  profileImageViewTop.topAnchor.constraint(equalTo:  self.topAnchor, constant: 0).isActive = true
       profileImageViewTop.centerYAnchor.constraint(equalTo:  self.centerYAnchor, constant: 0).isActive = true
        profileImageViewTop.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
       
    }
  
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

