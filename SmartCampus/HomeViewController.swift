
//  HomeViewController.swift
//  SmartCampus
//
//  Created by Tommy Chavez on 1/9/19.
//  Copyright © 2019 Tommy Chavez. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import MapKit
import FirebaseDatabase //just added
import CoreLocation //just added

protocol newsCellDelegate {
    func didTapLocationButton(local: String)
    func didTapProfile(name: String, profilePicture: UIImage)
}

var id = ""
var posts = [Post]()

class HomeViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate , CLLocationManagerDelegate{
    
    
    var switchison = true
    
    @IBAction func `switch`(_ sender: Any) {
        if((sender as AnyObject).isOn == true){
            
        }
        else {
            
        }
    }
    
    @IBAction func pressSpart(_ sender: Any) {
        let centerspot: CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.334970, -121.882946)
        //  camera.centerCoordinate = map.centerCoordinate
        self.camera.centerCoordinate = centerspot
    }
    let cellId = "PostCell"
    
   let camera = MKMapCamera()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        print("HERE")
       posts.removeAll() // log back in works & not added elemtns to posts
        self.tabBarController?.tabBar.barTintColor = UIColor.black //worked
        map.delegate = self //remember
        
        makeMap()
       // let camera = MKMapCamera()
        let centerspot: CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.334970, -121.882946)
        //  camera.centerCoordinate = map.centerCoordinate
        camera.centerCoordinate = centerspot
        camera.pitch = 80//80
        camera.altitude = 200.0
        camera.heading = 45.0
        map.setCamera(camera, animated: true)
        tableView.register(newsCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        loadPosts()
        print(posts.count)
        tableView.delegate = self
       // tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
//        checkLocationServices()
//        let location = locationManager.location?.coordinate
//        print(location!)
    
    }
   
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    
    var spot: String?
    let locationManager = CLLocationManager()
    
    
    
    
        let uid = Auth.auth().currentUser?.uid
    
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            //map.showsUserLocation = true
           // centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }



    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "go2annotation"
        {
            let cvc = (segue.destination as! UINavigationController).topViewController as! AnnotationTableViewController
            cvc.spot = spot
            
        }
        
    }
    
    
    
    func makeMap(){
        //   self.map.showsBuildings = true
        
        checkLocationServices()
        let myLoca = locationManager.location?.coordinate
        print("My Location: ")
        print(myLoca!)

        let span : MKCoordinateSpan = MKCoordinateSpan (latitudeDelta: 0.008, longitudeDelta: 0.008)
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.3352, -121.8811)
        let Library: CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.3355, -121.8850)
        let EngineeringBuilding: CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.337022, -121.881767)
        let Dorms: CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.334793, -121.8774495)
        let ATMS: CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.337362, -121.879596)
        let gym:CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.334371, -121.880383)
        let DT: CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.335277, -121.887450)
           let parking: CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.333122, -121.880776)
          let food: CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.336426, -121.880840)
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        map.setRegion(region, animated: false)
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        annotation.title = "San Jose State University"
        //annotation.subtitle = "You're Here"
        map.addAnnotation(annotation )
        
        let annotation2 = MKPointAnnotation()
        annotation2.coordinate = Library
        annotation2.title = "Martin Luther King Jr Library"
        map.addAnnotation(annotation2)
        
        let annotation3 = MKPointAnnotation()
        annotation3.coordinate = EngineeringBuilding
        annotation3.title = "Charles W. Davidson Building"
        map.addAnnotation(annotation3)
        
        let annotation4 = MKPointAnnotation()
        annotation4.coordinate = Dorms
        annotation4.title = "CVB"
        map.addAnnotation(annotation4)
        
        let annotation5 = MKPointAnnotation()
        annotation5.coordinate = ATMS
        annotation5.title = "ATM Machines"
        map.addAnnotation(annotation5)
        
        let annotation6 = MKPointAnnotation()
        annotation6.coordinate = gym
        annotation6.title = "SPARQ"
        map.addAnnotation(annotation6)
        
        let annotation7 = MKPointAnnotation()
        annotation7.coordinate = DT
        annotation7.title = "Downtown San Jose"
        map.addAnnotation(annotation7)
        
        
        let annotation8 = MKPointAnnotation()
        annotation8.coordinate = parking
        annotation8.title = "Parking"
        map.addAnnotation(annotation8)
        
        
        let annotation9 = MKPointAnnotation()
        annotation9.coordinate = food
        annotation9.title = "Student Union"
        map.addAnnotation(annotation9)
        
        
        let annotation10 = MKPointAnnotation()
        annotation10.coordinate = myLoca!
        annotation10.title = "My Location"
        map.addAnnotation(annotation10)        //  map.showsUserLocation = true
    }
    
    
    func mapView(_ map: MKMapView, didSelect didSelectAnnotationView: MKAnnotationView){
        let ann = self.map.selectedAnnotations[0] as? MKAnnotation
        // print(ann?.title)
        let spot = ann?.title
        
        let annotationtableview = AnnotationTableViewController()
        //newmessagecontroller.hidesBottomBarWhenPushed = true
        annotationtableview.spot = spot ?? "San Jose State University"
        
        let navController = UINavigationController(rootViewController: annotationtableview)
        present(navController, animated: true, completion: nil)
        
    }
    
    func mapView( _ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        if let title = annotation.title, title == "ATM Machines"{
            annotationView?.image = UIImage(named: "money3")
         //   annotationView?.animates
        }
        if let title = annotation.title, title == "Martin Luther King Jr Library"{
            // annotationView?.image = UIImage(named: "book2")
            annotationView?.image = UIImage(named: "book3")
            // annotationView?.accessibilityLabel = "Martin Luther King Jr. Library"
        }
        
        if let title = annotation.title, title == "San Jose State University"{
            annotationView?.image = UIImage(named: "spartan2")
        }
        
        if let title = annotation.title, title == "CVB"{
            annotationView?.image = UIImage(named: "city2")
        }
        
        if let title = annotation.title, title == "Charles W. Davidson Building"{
            annotationView?.image = UIImage(named: "calc2")
        }
        
        if let title = annotation.title, title == "SPARQ"{
            annotationView?.image = UIImage(named: "gym")
        }
        
        if let title = annotation.title, title == "Downtown San Jose"{
            annotationView?.image = UIImage(named: "beer1") //beer
        }
        if let title = annotation.title, title == "Parking"{
            annotationView?.image = UIImage(named: "parking") //beer
        }
        
        if let title = annotation.title, title == "Student Union"{
            annotationView?.image = UIImage(named: "food") //beer
        }
        
        if let title = annotation.title, title == "My Location"{
            annotationView?.image = UIImage(named: "walkingguy") //beer
        }
        
        
        annotationView?.canShowCallout = true
        return annotationView
    }
    
    
    func loadPosts(){
        
        
        Database.database().reference().child("posts").observe(.childAdded) {(snapshot: DataSnapshot) in
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
                
                
                let post = Post(captionText: captionText
                    , photoURLString: photoURLString, USERNAME: USERNAME, locationText: locationText, likes: likes, likedbyme: likedbyme, postid: postid, postcount: postcount)
                // posts.append(post)
                posts.insert(post, at: 0 )
             self.tableView.reloadData()
                //print(snapshot.value)
            }
        }
      //   self.tableView.reloadData()
    }
  
//end





    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
//        mapView.setRegion(region, animated: true)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}


extension HomeViewController: UITableViewDataSource {
   
   
     func tableView(  _ tableView: UITableView, heightForRowAt indexPath: IndexPath)->CGFloat{
        
        let imageyesorno = posts[indexPath.row].imageUrl
        let numberoflines = ((posts[indexPath.row].postCount)/42)+1 // %42
        
        let height = numberoflines * 24
        
        if(imageyesorno == "noImage") {
            
            return (CGFloat(80 + height))
        }
          return (CGFloat(380 + height))
    }
    
    func tableView( _ tableView:UITableView, numberOfRowsInSection section: Int)-> Int {
        return posts.count
    }//how many cells
    
  
    
    func tableView(  _ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! newsCell
      
        
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
        Database.database().reference().child("posts").child( posts[indexPath.row].postID).child("likes").child("\(self.uid!)").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                posts[indexPath.row].likedby = true
               
            }
            else {
                posts[indexPath.row].likedby = false
            }
        })
        
        let toId = posts[indexPath.row].usersName
        if( posts[indexPath.row].likedby == true){
          
            let heartFilled = UIImage(named: "heartfilled")
            cell.likeButton.setImage(heartFilled, for: .normal)
        }
        
        
        
        let ref = Database.database().reference().child("users").child(toId)
       
       
        Database.database().reference().child("users").child(toId).observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot.value ?? "")
            
            let dictionary = snapshot.value as? [String: Any]
            let username = dictionary?[ "username"] as? String
            
            guard let profileimageURL = dictionary?[ "ProfileImage"] as? String else {return}
           
            
            cell.nameButton.setTitle(username, for: .normal)
            
            cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: profileimageURL)
            cell.postText.text = posts[indexPath.row].caption
          let numberoflines = ((posts[indexPath.row].postCount)/42)+1 // %42
            
           let height = numberoflines * 24
            cell.postText.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
            
            let local2    = posts[indexPath.row].location
            cell.locationButton.setTitle(local2, for: .normal)
            if(posts[indexPath.row].likedby == true){
                let heartFilled = UIImage(named: "heartfilled")
                cell.likeButton.setImage(heartFilled, for: .normal)
            }
            if(posts[indexPath.row].likedby == false){
                let heartEmpty = UIImage(named: "heartempty")
                cell.likeButton.setImage(heartEmpty, for: .normal)
            }
            
            
            cell.likeLabel.text = String( posts[indexPath.row].numberoflikes)
            let url = posts[indexPath.row].imageUrl
            cell.postImage.loadImageUsingCacheWithUrlString(urlString: url)
            cell.likeLabel.text = String(posts[indexPath.row].numberoflikes)
            cell.delegate = self //ADDED
            
            cell.buttonAct = { sender in
                if( posts[indexPath.row].likedby == false){
                    posts[indexPath.row].likedby = true
                    let heartFilled = UIImage(named: "heartfilled")
                    cell.likeButton.setImage(heartFilled, for: .normal)
                    var liked = posts[indexPath.row].numberoflikes
                    liked =  liked  + 1
//                 print(liked)
//                    ref.child("numberoflikes").setValue(1)
                   Database.database().reference().child("posts").child(posts[indexPath.row].postID).updateChildValues(["numberoflikes": liked])
                    Database.database().reference().child("posts").child(posts[indexPath.row].postID).child("likes").updateChildValues(["\(self.uid!)": "liked"])
                    
                    cell.likeLabel.text = String(liked)
                //self.tableView.reloadData()
                }
//                if( posts[indexPath.row].likedby == true){
//                    posts[indexPath.row].likedby = false
//                    let heartEmpty = UIImage(named: "heartempty")
//                    cell.likeButton.setImage(heartEmpty, for: .normal)
//                    var liked = posts[indexPath.row].numberoflikes
//                    liked =  liked  - 1
//                    Database.database().reference().child("posts").child(posts[indexPath.row].postID).updateChildValues(["numberoflikes": liked])
//                    Database.database().reference().child("posts").child(posts[indexPath.row].postID).child("likes").child("\(self.uid!)").removeValue()
//
//
//                    cell.likeLabel.text = String(liked)
//                }
                
                
                
            }
            
            
        })
        
        // cell.detailTextLabel?.text = posts[indexPath.row].caption
        
        return cell
    }
    
  
}




class newsCell: UITableViewCell {
    var buttonAct: ((Any) -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
    }
    
    
    
    
    let nameButton: UIButton = {
        let nameImage = UIButton()
        nameImage.translatesAutoresizingMaskIntoConstraints = false
        nameImage.layer.masksToBounds = true
        nameImage.contentMode = .scaleAspectFill
        nameImage.setTitleColor( UIColor.black, for: .normal )
        nameImage.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
         nameImage.contentHorizontalAlignment = .left
        //  buttonView.backgroundColor = UIColor.blue
        return nameImage
    }()
    
    
    
    let profileImageView: UIButton = {
        let profileImage = UIButton()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = 24
        profileImage.contentMode = .scaleAspectFill
        //  buttonView.backgroundColor = UIColor.blue
        return profileImage
    }()
    
    
    let profileImageViewTop: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 24
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let postText: UILabel = {
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
    
    
    
    let postImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let backgroundCell: UIView = {
        let backCell = UIView()
        backCell.backgroundColor = UIColor.gray
        backCell.translatesAutoresizingMaskIntoConstraints = false
        backCell.layer.masksToBounds = true
        backCell.layer.borderColor = UIColor.darkGray.cgColor
        backCell.layer.borderWidth = 2
        //backCell.contentMode = .scaleAspectFill

        //backCell.layer.cornerRadius = 8
        return backCell
    }()
    
    
    let locationButton: UIButton = {
        let buttonView = UIButton()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.layer.masksToBounds = true
        //buttonView.contentMode = .scaleAspectFill
        //  buttonView.backgroundColor = UIColor.blue
        //buttonView.setTitle("@SJSU", for: .normal)
         buttonView.contentHorizontalAlignment = .left
        buttonView.setTitleColor( UIColor.blue, for: .normal )
        buttonView.titleLabel?.font = .systemFont(ofSize: 8)
        return buttonView
    }()
    
    let likeButton: UIButton = {
        let buttonView = UIButton()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.layer.masksToBounds = true
        let heartEmpty = UIImage(named: "heartempty")
        buttonView.setImage(heartEmpty, for: .normal)
        buttonView.setTitle("tommy", for: .normal)
        return buttonView
    }()
    
    let likeLabel: UILabel = {
        let ptext = UILabel()
        ptext.translatesAutoresizingMaskIntoConstraints = false
        ptext.layer.masksToBounds = true
        ptext.contentMode = .scaleAspectFill
        ptext.font = .systemFont(ofSize: 8)
        //ptext.text = "0"
     ptext.textAlignment = .center
        return ptext
    }()
    
    
    let threedots: UIButton = {
        let buttonView = UIButton()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        let heartEmpty = UIImage(named: "threedots")
        buttonView.setImage(heartEmpty, for: .normal)
        buttonView.layer.masksToBounds = true
        return buttonView
    }()
    
    
    let timeStamp: UILabel = {
        let ptext = UILabel()
        ptext.translatesAutoresizingMaskIntoConstraints = false
        ptext.layer.masksToBounds = true
        ptext.contentMode = .scaleAspectFill
        ptext.font = .systemFont(ofSize: 15)
        //ptext.lineBreakMode = .byWordWrapping
        ptext.textColor = UIColor.gray
        ptext.text = "MAY 5, 2019"
        ptext.numberOfLines = 0
        return ptext
    }()
    
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
       self.addSubview(backgroundCell)
        addSubview(nameButton)
        addSubview(profileImageView)
        addSubview(postImage)
        addSubview(postText)
        addSubview(locationButton)
        addSubview(profileImageViewTop)
        addSubview(timeStamp)
        addSubview(likeButton)
        addSubview(threedots)
        addSubview(likeLabel)
        
//      backgroundCell.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 1).isActive = true
//       backgroundCell.widthAnchor.constraint(equalToConstant: 375 ).isActive = true
//
//       backgroundCell.heightAnchor.constraint(equalToConstant: 30).isActive = true
//         backgroundCell.bottomAnchor.constraint(equalToSystemSpacingBelow: self.bottomAnchor, multiplier: 1).isActive = true
//
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        
        nameButton.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 3).isActive = true
        nameButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        nameButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        nameButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        
        locationButton.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 3).isActive = true
        locationButton.topAnchor.constraint(equalTo: nameButton.bottomAnchor, constant: 3).isActive = true
        locationButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        locationButton.heightAnchor.constraint(equalToConstant: 8).isActive = true
        
        
        timeStamp.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeStamp.centerYAnchor
            .constraint(equalTo: nameButton.centerYAnchor).isActive = true
        timeStamp.widthAnchor.constraint(equalToConstant: 120).isActive = true
        timeStamp.heightAnchor.constraint(equalToConstant: 15).isActive = true
        

        threedots.leftAnchor.constraint(equalTo: timeStamp.leftAnchor).isActive = true
        threedots.topAnchor
            .constraint(equalTo: timeStamp.bottomAnchor).isActive = true
        threedots.widthAnchor.constraint(equalToConstant: 45).isActive = true
        threedots.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageViewTop.topAnchor.constraint(equalTo:  self.topAnchor, constant: 12).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        profileImageViewTop.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        profileImageViewTop.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageViewTop.topAnchor.constraint(equalTo:  self.topAnchor, constant: 12).isActive = true
        profileImageViewTop.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        postText.leftAnchor.constraint(equalTo: profileImageView.leftAnchor).isActive = true
       postText.widthAnchor.constraint(equalToConstant: 300).isActive = true
        //postText.heightAnchor.constraint(equalToConstant: 24).isActive = true
            postText.topAnchor
            .constraint(equalTo: profileImageViewTop.bottomAnchor, constant: 1).isActive = true
        
        likeButton.leftAnchor.constraint(equalTo: threedots.rightAnchor).isActive = true
       likeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
       likeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
       likeButton.topAnchor
            .constraint(equalTo: threedots.topAnchor, constant: 0).isActive = true
        
        likeLabel.leftAnchor.constraint(equalTo: threedots.rightAnchor).isActive = true
         likeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        likeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        likeLabel.topAnchor
            .constraint(equalTo: threedots.topAnchor, constant: 0).isActive = true
        
        
        postImage.leftAnchor.constraint(equalTo: profileImageView.leftAnchor).isActive = true
        postImage.topAnchor
           .constraint(equalTo: postText.bottomAnchor, constant: 0).isActive = true
        
        postImage.centerXAnchor
            .constraint(equalTo: postText.centerXAnchor).isActive = true
        postImage.widthAnchor.constraint(equalToConstant: 300).isActive = true
        postImage .heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        nameButton.addTarget(self, action: #selector(profileFunc), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        profileImageView.addTarget(self, action: #selector(profileFunc), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(takeCareOfLikes), for: .touchUpInside)
    }
    var delegate: newsCellDelegate?
    
    @objc func buttonAction(){
       
        delegate?.didTapLocationButton(local: locationButton.titleLabel?.text ?? "")
    }
    
    @objc func profileFunc(){
        
        delegate?.didTapProfile(name: nameButton.titleLabel?.text ?? "", profilePicture: profileImageViewTop.image!)
    }
    
    @objc func takeCareOfLikes(sender: Any){
        
        self.buttonAct?(sender)
        
//        let heartEmpty = UIImage(named: "heartempty")
//        if(likeButton.currentImage == heartEmpty){
//        let heartFilled = UIImage(named: "heartfilled")
//        likeButton.setImage(heartFilled, for: .normal)
//    }
//        else{
//            likeButton.setImage(heartEmpty, for: .normal)
//        }
}
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension HomeViewController: newsCellDelegate {
    func didTapLocationButton(local: String) {
    
        let vc = AnnotationTableViewController()
        vc.spot = local
        let navController = UINavigationController(rootViewController: vc)
        
        present(navController, animated: true, completion: nil)
    }
    
    func didTapProfile(name: String, profilePicture: UIImage){
       
        
        let vc = AccountViewController()
        print(id)
        vc.profilePicture = profilePicture
        vc.name = name
      let navController = UINavigationController(rootViewController: vc)
//
        present(navController, animated: true, completion: nil)
//        navigationController?.pushViewController(vc, animated: true)
    }
}
extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}


