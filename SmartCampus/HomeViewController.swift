
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
import AVFoundation



protocol newsCellDelegate {
    func didTapLocationButton(local: String)
    func didTapProfile(name: String, profilePicture: UIImage, nameid: String)
}

var selectedIndex: Int?
var myUsername: String?
var myProfilePicture: String?
var id = ""
var posts = [Post]()
var friendsposts = [Post]()
var popposts = [Post]()


var backgroundimage101: UIImage?
var usersShowName: String?
var friendsList = [String]()
var usersPhotosList = [String]()
var screenshot: UIImage?

class HomeViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate , CLLocationManagerDelegate, UITabBarControllerDelegate{
    
    @IBOutlet weak var recenterbutton: UIButton!
    
    @IBAction func touchCal(_ sender: Any) {
        
    }
    var passedDataString = Date()
    var passId: String?
    
  
    override open var shouldAutorotate: Bool {
       return false
    }

    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       return .portrait
    }
   
    
    @IBAction func unwindToHere( sender: UIStoryboardSegue){
        degmentcontrolnum.selectedSegmentIndex = 3
        tableView.isHidden = true
        let date = Date()
        let  dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL dd, YYYY"
        
        currentDay =  dateFormatter.string(from: date)
       // loadEvents()
        eventTable.isHidden = false
        events.removeAll()
        eventTable.reloadData()
       // print("EVENTS BABY")
      //print((passedDataString))
        
    }
    var difflocationsUser = [String]()
    var difflocationsImage = [String]()
    var difflocationsuserid = [UIImage]()
    var diffLocationTime = [String]()
   
    let cellId = "PostCell"
    
    let camera = MKMapCamera()
    
    var switchison: Bool? 
    
   let uid = Auth.auth().currentUser?.uid
   
    var spot: String?
    
    let locationManager = CLLocationManager()
    
    
    var mylong = 0.00
    
    var mylat = 0.00
   
 
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var map: MKMapView!
    
    @IBAction func `switch`(_ sender: Any) {
        if((sender as AnyObject).isOn == true){
           switchison = true
            var userPostRef = Database.database().reference().child("users").child(uid!).child("locationOn")
                userPostRef.setValue(true)
                 userPostRef = Database.database().reference().child("users").child(uid!).child("locationLat")
                    userPostRef.setValue(mylat)
                   userPostRef = Database.database().reference().child("users").child(uid!).child("locationLong")
                   userPostRef.setValue(mylong)
            //let date = Date()
            userPostRef = Database.database().reference().child("users").child(uid!).child("locationDate")
            userPostRef.setValue(Int (Date().timeIntervalSince1970))
            let myLoca = locationManager.location?.coordinate
            mylong =  (locationManager.location?.coordinate.longitude) ?? 0
            mylat =  (locationManager.location?.coordinate.latitude) ?? 0
            let annotation1 = PointAnnotation(personLocation: true, userId: uid!, userImage: myProfilePicture!  , userName: myUsername!)
                  annotation1.coordinate = myLoca!
                  annotation1.title = "My Location"
                  map.addAnnotation(annotation1)
            //showUserLoc()
        }
        else {
            switchison = false
           var userPostRef = Database.database().reference().child("users").child(uid!).child("locationOn")
            userPostRef.setValue(false)
            for annotation in map.annotations {
                if let title = annotation.title, title == "My Location" {
                    self.map.removeAnnotation(annotation)
                }
            }

           // showUserLoc()
            
        }
    }
    

    
    @IBAction func pressSpart(_ sender: Any) {
        let centerspot: CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.334970, -121.882946)
        //  camera.centerCoordinate = map.centerCoordinate
        self.camera.centerCoordinate = centerspot
    }
    
    @IBAction func recenter(_ sender: Any) {
    getAngle()
//        let imageToShare = self.view.toImage()
//        backgroundimage101 = imageToShare
//        recenterbutton.setImage(imageToShare, for: .normal)
    }
    
  
    
    func getAngle(){
        let camera = MKMapCamera()
        let centerspot: CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.334970, -121.882946)
        //  camera.centerCoordinate = map.centerCoordinate
        camera.centerCoordinate = centerspot
        camera.pitch = 80//80
        camera.altitude = 200.0
        camera.heading = 45.0
        map.setCamera(camera, animated: true)
    }
    
    let eventTable: UITableView = UITableView(frame: CGRect(x: 0, y: 339, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 339));
    
     let friendView: UITableView = UITableView(frame: CGRect(x: 0, y: 339, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 339));
    
    let popView: UITableView = UITableView(frame: CGRect(x: 0, y: 339, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 339));
    
    
    @IBOutlet weak var navbar: UINavigationItem!
    
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
         super.viewWillTransition(to: size, with: coordinator)
    var saved: NSLayoutConstraint?
    if UIDevice.current.orientation.isLandscape {
             print("Landscape")
           self.tabBarController?.tabBar.isHidden = true
            degmentcontrolnum.isHidden = true
            //setupAnimationForNavigationBar(caseOfFunction: true) ;
       
        if( degmentcontrolnum.selectedSegmentIndex==0){
            tableView.isHidden = true
        }
        if( degmentcontrolnum.selectedSegmentIndex==1){
            popView.isHidden = true
        }
        if( degmentcontrolnum.selectedSegmentIndex==2){
                   friendView.isHidden = true
               }
        if( degmentcontrolnum.selectedSegmentIndex==3){
                          eventTable.isHidden = true
                      }
        
            //imageView.image = UIImage(named: const2)
         } else {
             print("Portrait")
               self.tabBarController?.tabBar.isHidden = false
            degmentcontrolnum.isHidden = false
        
        
      
             //setupAnimationForNavigationBar(caseOfFunction: false) ;
            
            // imageView.image = UIImage(named: const)
        
        if( degmentcontrolnum.selectedSegmentIndex==0){
            tableView.isHidden = false
        }
        if( degmentcontrolnum.selectedSegmentIndex==1){
            popView.isHidden = false
        }
        if( degmentcontrolnum.selectedSegmentIndex==2){
                   friendView.isHidden = false
               }
        if( degmentcontrolnum.selectedSegmentIndex==3){
            eventTable.isHidden = false
                      }
         }

     }
   
    
    
    func setupAnimationForNavigationBar(caseOfFunction: Bool) {
        if caseOfFunction == true {
            UIView.animate(withDuration: 0.5) {
                self.map.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
             
            }
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.map.transform  = CGAffineTransform.identity
            })
        }

    }
 
    

    
    @IBOutlet weak var locationSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        id = uid!
//        if let navigationBar = self.navigationController?.navigationBar {
//            let firstFrame = CGRect(x: 325, y: 0, width: 25, height: navigationBar.frame.height)
//         
//            let blankview = CGRect(x: 335, y: 0, width: 25, height: navigationBar.frame.height)
//            let firstLabel = UILabel(frame: firstFrame)
//            let secondLabel = UIView(frame: blankview)
//            firstLabel.text = "12"
//            secondLabel.backgroundColor = UIColor.red
//          
//            navigationBar.addSubview(secondLabel)
//            navigationBar.addSubview(firstLabel)
//
    
//           
//        }
    
        fetchUser()
      //  loadEvents()
      //  super.viewWillAppear(true)
        selectedIndex = 0
   //locationSwitch.isOn = false
       
      //
        posts.removeAll()
      
        // log back in works & not added elemtns to posts
        map.delegate = self //remember
        map.layer.masksToBounds = true
        //map.layer.cornerRadius = 50
        map.layer.borderWidth = 2.0
      // makeMap()
        tableView.register(newsCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        
        friendView.register(newsCell.self, forCellReuseIdentifier: "friendCell")
        friendView.dataSource = self
       // friendView.tableFooterView = UIView()
        friendView.delegate = self
        view.addSubview(friendView);
        friendView.isHidden = true
        
        popView.register(newsCell.self, forCellReuseIdentifier: "popCell")
         popView.dataSource = self
        // friendView.tableFooterView = UIView()
         popView.delegate = self
         view.addSubview(popView);
         popView.isHidden = true

       // friendView.reloadData()
        
        fetchFriends();
//            self.loadPosts(completion: { message in
//            // self.loadPosterInfo(Message: message)
//              self.loadLikers(Message: message)
//            self.loadLikes(Message: message)
//            self.loadcomments(Message: message)
//
//
//        })
        let font = UIFont.systemFont(ofSize: 11)
    degmentcontrolnum.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
     
        tableView.tableFooterView = UIView()
     
        //print(posts.count)
        tableView.delegate = self
        self.tabBarController?.delegate = self
        eventTable.register(newsCell.self, forCellReuseIdentifier: "eventCell")
        eventTable.dataSource = self
        eventTable.delegate = self
        //eventTable.backgroundColor = UIColor.red
        view.addSubview(eventTable)
         eventTable.isHidden = true
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refreshit), for: .valueChanged)
        // tableView.addSubview(refreshControl)
       tableView.refreshControl = refreshControl
        
    let refreshControl2 = UIRefreshControl()
         refreshControl2.addTarget(self, action:  #selector(refreshit2), for: .valueChanged)
         // tableView.addSubview(refreshControl)
        friendView.refreshControl = refreshControl2
        
        
    let refreshControl3 = UIRefreshControl()
            refreshControl3.addTarget(self, action:  #selector(refreshit3), for: .valueChanged)
            // tableView.addSubview(refreshControl)
           popView.refreshControl = refreshControl3
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    
    @objc func refreshit(refreshControl: UIRefreshControl) {
        //print("here")
       // posts.sort { $0.numberoflikes > $1.numberoflikes }
        self.loadPosts(completion: { message,message2 in
           //  print ("loading posts from top2")
            self.loadPosterInfo(Message: message2, postid: message)
            self.loadLikers(Message: message)
            self.loadLikes(Message: message)
            self.loadcomments(Message: message)
           
            
        })
        refreshControl.endRefreshing()
    }
    
    @objc func refreshit2(refreshControl: UIRefreshControl) {
        //print("here")
    friendView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @objc func refreshit3(refreshControl: UIRefreshControl) {
        //print("here")
        //popposts.sort { $0.usersName > $1.usersName }
        print("sorted array")
        popView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
           selectedIndex = 0
        self.tabBarController?.delegate = self
        //self.tableView.reloadData()
     
    }
    
   //getting own location
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let tabBarIndex = tabBarController.selectedIndex
        
       // print(tabBarIndex)
        
        if tabBarIndex == 0 {
            selectedIndex = 0
        self.tableView.setContentOffset(CGPoint.zero, animated: true) //make table go to top
          //  screenShotMethod()
        }
        
        if tabBarIndex == 1 {
            
          // screenShotMethod()
           selectedIndex = 1
            
        }
        if tabBarIndex == 2 {
            if(selectedIndex == 0){
              //  print("HERE")
                // friendView.reloadData()
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
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "go2annotation"
        {
            let cvc = (segue.destination as! UINavigationController).topViewController as! AnnotationTableViewController
            cvc.spot = spot
            
        }
        
    }
    
    
   func fetchFriends(){
    var Count = 0;
    var counter = 0;
    Database.database().reference().child("users").child(uid!).child("friendsList").observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.exists(){
            
        }else{
            print("no friends");
            //print("no children!") //if no children  go here
            self.loadPosts(completion: { message, message2 in
                 print ("loading posts from top1")
                self.loadPosterInfo(Message: message2, postid: message)
                self.loadLikers(Message: message)
                self.loadLikes(Message: message)
                self.loadcomments(Message: message)
                 
            })
            self.loadfirst5postsfriends(completion: { message3 in self.loadPostsfriends(postidforload: message3, completion: { message,message2 in
                               self.loadPosterInfofriends(Message: message2, postid: message)
                               self.loadLikersfriends(Message: message)
                               self.loadLikesfriends(Message: message)
                               self.loadcommentsfriends(Message: message)

                           })
                          })
            
            self.loadPostspop(completion: { message, message2 in
                self.loadPosterInfopop(Message: message2, postid: message)
                self.loadLikerspop(Message: message)
                self.loadLikespop(Message: message)
                self.loadcommentspop(Message: message)
            })
            self.loadPostsEvents(completion: { message, message2 in
                self.loadPosterInfoEvent(Message: message2, postid: message)
                self.loadLikersEvents(Message: message)
                self.loadLikesEvents(Message: message)
              self.loadcommentsEvents(Message: message)
                
            })

            
        }
    })
    
    var once = true
    Database.database().reference().child("users").child(uid!).child("friendsList").observe(.childAdded) { (snapshot) in
       // print("SNAPSHOT KEY")
        print("snapshot count:");
        Count = Int( snapshot.childrenCount)
        print(Count)
        let snapid = snapshot.key
        
        print("FriendList")
        print("friend:")
        print(snapid)
        //print(snapid)
        friendsList.append(snapid)
        counter = counter + 1;
        print(counter)
        DispatchQueue.main.async(execute: {
            if(once == true){
                 print ("loading posts from top2")
                self.loadPosts(completion: { message,message2 in
                   //  print ("loading posts from top2")
                    self.loadPosterInfo(Message: message2, postid: message)
                    self.loadLikers(Message: message)
                    self.loadLikes(Message: message)
                    self.loadcomments(Message: message)
                   
                    
                })
            
                
                self.loadfirst5postsfriends(completion: { message3 in self.loadPostsfriends(postidforload: message3, completion: { message, message2 in
                    self.loadPosterInfofriends(Message: message2, postid: message)
                    self.loadLikersfriends(Message: message)
                    self.loadLikesfriends(Message: message)
                    self.loadcommentsfriends(Message: message)

                })
               })
                
                self.loadPostspop(completion: { message, message2 in
                              self.loadPosterInfopop(Message: message2, postid: message)
                             self.loadLikerspop(Message: message)
                             self.loadLikespop(Message: message)
                             self.loadcommentspop(Message: message)
                         })
                self.loadPostsEvents(completion: { message, message2 in
                    self.loadPosterInfoEvent(Message: message2, postid: message)
                    self.loadLikersEvents(Message: message)
                    self.loadLikesEvents(Message: message)
                    self.loadcommentsEvents(Message: message)
                    
                })

                
                once = false ;
           }
            
        })
        
    }
    }
    
    func fetchUserPhotos(){
        
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot) in
            
           // print("SNAPSHOT KEY")
            let snapid = snapshot.key
            let dict = snapshot.value as? [String: Any]
            let username = dict?[ "usersName"] as? String
            let imageString = dict?[ "imageUrl"] as? String
            if(username == self.uid!){
                if(imageString != "noImage"){
                    usersPhotosList.append(imageString!)
                }
            }
        }
    }
    
    
    
//    func showUserLoc(){
//        if(switchison==false){
//            self.map.showsUserLocation = false
//        }
//        else {
//            self.map.showsUserLocation = true
//        }
//    }
    func makeMap(){
        
        checkLocationServices()
        
        let myLoca = locationManager.location?.coordinate
        mylong =  (locationManager.location?.coordinate.longitude) ?? 0
        mylat =  (locationManager.location?.coordinate.latitude) ?? 0
        let annotation1 = PointAnnotation(personLocation: true, userId: uid!, userImage: myProfilePicture! , userName: myUsername!)
              annotation1.coordinate = myLoca!
              annotation1.title = "My Location"
              map.addAnnotation(annotation1)

        let span : MKCoordinateSpan = MKCoordinateSpan (latitudeDelta: 0.008, longitudeDelta: 0.008)
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.334184, -121.883772)
        let Library: CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.3355, -121.8850)
        let EngineeringBuilding: CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.337022, -121.881767)
        let Dorms: CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.334793, -121.8774495)
        let ATMS: CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.336611, -121.880023)
        let gym:CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.334371, -121.880383)
        let DT: CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.335277, -121.887450)
           let parking: CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.333122, -121.880776)
          let food: CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.336426, -121.880840)
         let fakeLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.335558, -121.879256)
        let musicLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.335658, -121.879403)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        let greekregion:CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.337923, -121.877863)
        
        let football:CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.319480, -121.868913)
        
        let bus:CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.336854, -121.878779)
        
        let art:CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.335976, -121.879541)
        
        let health:CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.334775, -121.881146)
        
        let science:CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.334958, -121.884888);
        let housing:CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.338941, -121.885744)
        map.setRegion(region, animated: false)
        
     
        // you can customize it anyway you want like any other label
        let annotation = PointAnnotation(personLocation: false, userId: "", userImage: "", userName: "")
        
        annotation.coordinate = location
        annotation.title = "San Jose State University"
       
        //annotation.subtitle = "You're Here"
        
        map.addAnnotation(annotation )
        
       
        
        
        let annotation2 = PointAnnotation(personLocation: false, userId: "", userImage: "" , userName: "" )
        annotation2.coordinate = Library
        annotation2.title = "MLK Jr Library"
        map.addAnnotation(annotation2)
        
        let annotation3 = PointAnnotation(personLocation: false, userId: "", userImage: "" , userName: "")
        annotation3.coordinate = EngineeringBuilding
        annotation3.title = "Engineering Building"
        map.addAnnotation(annotation3)
        
        let annotation4 = PointAnnotation(personLocation: false, userId: "", userImage: "" , userName: "")
        annotation4.coordinate = Dorms
        annotation4.title = "Dorms"
        map.addAnnotation(annotation4)
        
        let annotation5 = PointAnnotation(personLocation: false, userId: "", userImage: "" , userName: "")
        annotation5.coordinate = ATMS
        annotation5.title = "Book Store"
        map.addAnnotation(annotation5)
        
        let annotation6 = PointAnnotation(personLocation: false, userId: "", userImage: "" , userName: "")
        annotation6.coordinate = gym
        annotation6.title = "SRAC"
        map.addAnnotation(annotation6)
        
        let annotation7 = PointAnnotation(personLocation: false, userId: "" ,userImage: "" , userName: "")
        annotation7.coordinate = DT
        annotation7.title = "Downtown San Jose"
        map.addAnnotation(annotation7)
        
        
        let annotation8 = PointAnnotation(personLocation: false, userId: "" ,userImage: "" , userName: "")
        annotation8.coordinate = parking
        annotation8.title = "Parking"
        map.addAnnotation(annotation8)
        
        
        let annotation9 = PointAnnotation(personLocation: false, userId: "" ,userImage: "" , userName: "")
        annotation9.coordinate = food
        annotation9.title = "Student Union"
        map.addAnnotation(annotation9)
        
        let annotation10 = PointAnnotation(personLocation: false, userId: "", userImage: "" , userName: "")
        annotation10.coordinate = musicLocation
        annotation10.title = "Event Center"
        map.addAnnotation(annotation10)
        
        let annotation11 = PointAnnotation(personLocation: false, userId: "", userImage: "" , userName: "")
        annotation11.coordinate = greekregion
        annotation11.title = "Greek Life"
        map.addAnnotation(annotation11)
        
        let annotation12 = PointAnnotation(personLocation: false, userId: "", userImage: "" , userName: "")
        annotation12.coordinate = football
        annotation12.title = "CEFCU Stadium"
        map.addAnnotation(annotation12)
       
        let annotation13 = PointAnnotation(personLocation: false, userId: "", userImage: "" , userName: "")
        annotation13.coordinate = art
        annotation13.title = "Art Building"
        map.addAnnotation(annotation13)
 
        let annotation14 = PointAnnotation(personLocation: false, userId: "", userImage: "" , userName: "")
        annotation14.coordinate = bus
        annotation14.title = "Business Center"
        map.addAnnotation(annotation14)
        
        let annotation15 = PointAnnotation(personLocation: false, userId: "", userImage: "" , userName: "")
        annotation15.coordinate = health
        annotation15.title = "Health Center"
        map.addAnnotation(annotation15)
 
        let annotation16 = PointAnnotation(personLocation: false, userId: "", userImage: "" , userName: "")
        annotation16.coordinate = science
        annotation16.title = "Science Building"
        map.addAnnotation(annotation16)
        
        let annotation17 = PointAnnotation(personLocation: false, userId: "", userImage: "" , userName: "")
               annotation17.coordinate = housing
               annotation17.title = "Housing"
               map.addAnnotation(annotation17)
 
       addfriendsLocation()
        let centerspot: CLLocationCoordinate2D = CLLocationCoordinate2DMake( 37.334970, -121.882946)
          camera.centerCoordinate = map.centerCoordinate
        camera.centerCoordinate = centerspot
    camera.pitch = 80//80
       camera.altitude = 200.0 //200
    camera.heading = 45.0
        map.setCamera(camera, animated: true)
    }
    
     func addfriendsLocation(){
        for i in friendsList {
            Database.database().reference().child("users").child(i).observeSingleEvent(of: .value, with: { (snapshot) in
            //print("SNAPSHOT KEY")
           let snapid = snapshot.key
           // print(snapid)
           // print(snapid)
                        let dict = snapshot.value as? [String: Any]
            
                        let locationOn = dict?[ "locationOn"] as? Bool
                        let USERNAME = dict!["username"] as! String
                        let newimage = dict!["ProfileImage"] as! String
           // print(USERNAME);
                        if(locationOn == true){
                           
                                
                            let mydate = dict!["locationDate"] as! Int
                            let locationLat = dict?[ "locationLat"] as? Double
                            //print(locationLat)
                            let locationLong = dict?[ "locationLong"] as? Double
                            //print(locationLong)
                          //  print(locationLat!)
                          //  print(locationLong!)
                            let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(locationLat!, locationLong!)
                            let annotation30 = PointAnnotation(personLocation: true, userId: snapid, userImage: newimage , userName: USERNAME)
                            let myDateString = self.findStringOfTime(newDate: mydate);
                            annotation30.coordinate = location
                            annotation30.title = "\(USERNAME)"
                          //  print("finding people")
                           // print("\(USERNAME)")
                           self.difflocationsUser.append(USERNAME)
                            self.difflocationsImage.append(newimage)
                            self.diffLocationTime.append(myDateString)
                          //   self.difflocationsuserid.append(snapid)
                            self.map.addAnnotation(annotation30)
                }
            })
        }
    }
    
    
    
    
    func mapView(_ map: MKMapView, didSelect didSelectAnnotationView: MKAnnotationView){
        let ann = self.map.selectedAnnotations[0] as? PointAnnotation
        // print(ann?.title)
        let spot = ann?.title
       if(ann?.personlocation == false){
          //  print("this is a location")
       // print("HERE")
        let vc = AnnotationTableViewController()
        vc.spot = spot
    
        self.navigationController?.pushViewController(vc, animated: true)
        }//
       else{
       // print("ACCOUNT HERE")
        let vc = AccountViewController()
       // print(id)
        let profileTemp = UIImageView()
        profileTemp.loadImageUsingCacheWithUrlString(urlString: ann!.userimage)
        vc.profilePicture = profileTemp.image
        vc.name = ann?.username
        print( "ann?.username")
        print( ann?.username)
       // print(ann?.username)
        
        vc.nameID = ann?.userid
        //print(ann?.userid)
       // vc.profilePicture = ann?.userimage
        let navController = UINavigationController(rootViewController: vc)
        
        present(navController, animated: true, completion: nil)
        }
    
    }
    

    
    func mapView( _ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
       // let annotationLabel = UILabel(frame: CGRect(x: -40, y: -35, width: 105, height: 30))
         let annotationLabel = UILabel(frame: CGRect(x: -20, y: 50, width: 105, height: 30))
        annotationLabel.numberOfLines = 3
        annotationLabel.textAlignment = .center
        annotationLabel.font = UIFont(name: "Rockwell", size: 10)
        
        let timeLabel = UILabel(frame: CGRect(x: -20, y: 60, width: 105, height: 30))
        timeLabel.numberOfLines = 3
        timeLabel.textAlignment = .center
        timeLabel.textColor = UIColor.red
        timeLabel.font = UIFont(name: "Rockwell", size: 8)
        
        
        let mapProfile = UIImageView(frame: CGRect(x: -40, y: -35, width: 5, height: 5))
            mapProfile.translatesAutoresizingMaskIntoConstraints = false
            mapProfile.layer.masksToBounds = true
            mapProfile.contentMode = .scaleAspectFill
         mapProfile.layer.cornerRadius = 24
        
        let mapProfileTap = UIButton(frame: CGRect(x: -40, y: -35, width: 5, height: 5))
        mapProfileTap.translatesAutoresizingMaskIntoConstraints = false
        mapProfileTap.layer.masksToBounds = true
       
       // mapProfileTap.layer.cornerRadius = 24
        mapProfileTap.addTarget(self, action: #selector(takeCareOfTaps), for: .touchUpInside)
        
     
        var profiletop = UIImageView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        
        profiletop.translatesAutoresizingMaskIntoConstraints = false
        profiletop.layer.masksToBounds = true
        profiletop.contentMode = .scaleAspectFill
       // profiletop.backgroundColor = UIColor.white
        profiletop.widthAnchor.constraint(equalToConstant: 15).isActive = true
        profiletop.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
       // profiletop.centerXAnchor.constraint(equalTo: background.centerXAnchor).isActive = true
       // profiletop.centerYAnchor.constraint(equalTo: background.centerYAnchor).isActive = true
        
        
        if let title = annotation.title, title == "Book Store"{
            
            profiletop.image =  UIImage(named: "bookssss")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1))
            annotationView?.addSubview(profiletop)
            annotationView?.image =  UIImage(named: "whitecircle")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: UIColor.white);
            profiletop.centerXAnchor.constraint(equalTo: annotationView!.centerXAnchor).isActive = true
            profiletop.centerYAnchor.constraint(equalTo: annotationView!.centerYAnchor).isActive = true
            
        }
        if let title = annotation.title, title == "MLK Jr Library"{
            
            
            profiletop.image = UIImage(named: "book2")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: UIColor.green)
            annotationView?.addSubview(profiletop)
            annotationView?.image =  UIImage(named: "whitecircle")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: UIColor.white);
            profiletop.centerXAnchor.constraint(equalTo: annotationView!.centerXAnchor).isActive = true
            profiletop.centerYAnchor.constraint(equalTo: annotationView!.centerYAnchor).isActive = true
            
        }
        
        if let title = annotation.title, title == "San Jose State University"{
           // annotationView?.image = UIImage(named: "square")
            //annotationView?.image.
            
            
            //annotationView?.addSubview(background)
            profiletop.image = UIImage(named: "spartan2")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: UIColor.blue)
            annotationView?.addSubview(profiletop)
            
//
            annotationView?.image =  UIImage(named: "whitecircle")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: UIColor.white);
            profiletop.centerXAnchor.constraint(equalTo: annotationView!.centerXAnchor).isActive = true
            profiletop.centerYAnchor.constraint(equalTo: annotationView!.centerYAnchor).isActive = true


        }
        
        if let title = annotation.title, title == "Dorms"{
           
           
            
            
            
            profiletop.image = UIImage(named: "city")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: UIColor.purple);
            annotationView?.addSubview(profiletop)
            
            annotationView?.image =  UIImage(named: "whitecircle")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: UIColor.white);
            profiletop.centerXAnchor.constraint(equalTo: annotationView!.centerXAnchor).isActive = true
            profiletop.centerYAnchor.constraint(equalTo: annotationView!.centerYAnchor).isActive = true
        }
        
        if let title = annotation.title, title == "Engineering Building"{
           
            
            profiletop.image =  UIImage(named: "calc")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: UIColor.black)
            annotationView?.addSubview(profiletop)
            annotationView?.image =  UIImage(named: "whitecircle")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: UIColor.white);
            profiletop.centerXAnchor.constraint(equalTo: annotationView!.centerXAnchor).isActive = true
            profiletop.centerYAnchor.constraint(equalTo: annotationView!.centerYAnchor).isActive = true
            
        }
        
        if let title = annotation.title, title == "SRAC"{
            profiletop.image =  UIImage(named: "weights")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: UIColor.yellow)
            annotationView?.addSubview(profiletop)
            annotationView?.image =  UIImage(named: "whitecircle")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: UIColor.white);
            profiletop.centerXAnchor.constraint(equalTo: annotationView!.centerXAnchor).isActive = true
            profiletop.centerYAnchor.constraint(equalTo: annotationView!.centerYAnchor).isActive = true
            
        }
        
        if let title = annotation.title, title == "Downtown San Jose"{
           // annotationView?.image = UIImage(named: "beer-1") //beer1
        
            
            
            
            
            profiletop.image =  UIImage(named: "beer")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: UIColor.orange)
            annotationView?.addSubview(profiletop)
            annotationView?.image =  UIImage(named: "whitecircle")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: UIColor.white);
            profiletop.centerXAnchor.constraint(equalTo: annotationView!.centerXAnchor).isActive = true
            profiletop.centerYAnchor.constraint(equalTo: annotationView!.centerYAnchor).isActive = true
            
            
        }
        if let title = annotation.title, title == "Parking"{
          //  annotationView?.image = UIImage(named: "parking2") //beer
            
            
            profiletop.image = UIImage(named: "parking4")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))
            annotationView?.addSubview(profiletop)
            annotationView?.image =  UIImage(named: "whitecircle")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: UIColor.white);
            profiletop.centerXAnchor.constraint(equalTo: annotationView!.centerXAnchor).isActive = true
            profiletop.centerYAnchor.constraint(equalTo: annotationView!.centerYAnchor).isActive = true
            
            
        }
        
        if let title = annotation.title, title == "Student Union"{
        
           
            profiletop.image = UIImage(named: "food4")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))
            annotationView?.addSubview(profiletop)
            annotationView?.image =  UIImage(named: "whitecircle")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: UIColor.white);
            profiletop.centerXAnchor.constraint(equalTo: annotationView!.centerXAnchor).isActive = true
            profiletop.centerYAnchor.constraint(equalTo: annotationView!.centerYAnchor).isActive = true
            

            
        }
        
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot.value ?? "")
          //  let postid = snapshot.key
         let dictionary = snapshot.value as? [String: Any]
            
            let username = dictionary?[ "username"] as? String
            myUsername = username
            myProfilePicture = dictionary?[ "ProfileImage"] as? String
            self.switchison = (dictionary?[ "locationOn"] as? Bool)!
           // print(self.switchison!)
          //  print("is switch on?");
            

           
            usersShowName = username
            
                DispatchQueue.main.async {
                    //self.ProPic.image = image
                    
                    if(self.switchison! == true){
                       if let title = annotation.title, title == "My Location"{
                                 annotationView?.image = UIImage(named: "locations-1")
                       


                         }
                    }
            }
        })
        
        if let title = annotation.title, title == "Event Center"{
            //annotationView?.image = UIImage(named: "music-1") //music 4 //beer
      
            
            profiletop.image = UIImage(named: "mic")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1))
            annotationView?.addSubview(profiletop)
            annotationView?.image =  UIImage(named: "whitecircle")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: UIColor.white);
            profiletop.centerXAnchor.constraint(equalTo: annotationView!.centerXAnchor).isActive = true
            profiletop.centerYAnchor.constraint(equalTo: annotationView!.centerYAnchor).isActive = true
            
        }
        
        if let title = annotation.title, title == "Greek Life"{
            //annotationView?.image = UIImage(named: "Greece2") //beer
           
            
        
            profiletop.image = UIImage(named: "Greece2")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
            annotationView?.addSubview(profiletop)
            annotationView?.image =  UIImage(named: "whitecircle")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: UIColor.white);
            profiletop.centerXAnchor.constraint(equalTo: annotationView!.centerXAnchor).isActive = true
            profiletop.centerYAnchor.constraint(equalTo: annotationView!.centerYAnchor).isActive = true
        }
        
        if let title = annotation.title, title ==  "CEFCU Stadium"{
            //annotationView?.image = UIImage(named: "Greece2") //beer
           
            
            
            profiletop.image = UIImage(named: "football2")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1))
            annotationView?.addSubview(profiletop)
            annotationView?.image =  UIImage(named: "whitecircle")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: UIColor.white);
            profiletop.centerXAnchor.constraint(equalTo: annotationView!.centerXAnchor).isActive = true
            profiletop.centerYAnchor.constraint(equalTo: annotationView!.centerYAnchor).isActive = true
        }
        
        if let title = annotation.title, title ==  "Art Building"{
            //annotationView?.image = UIImage(named: "Greece2") //beer
          
            profiletop.image = UIImage(named: "art2")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1))
            annotationView?.addSubview(profiletop)
            annotationView?.image =  UIImage(named: "whitecircle")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: UIColor.white);
            profiletop.centerXAnchor.constraint(equalTo: annotationView!.centerXAnchor).isActive = true
            profiletop.centerYAnchor.constraint(equalTo: annotationView!.centerYAnchor).isActive = true
            
        }
        
        if let title = annotation.title, title ==  "Business Center"{
            //annotationView?.image = UIImage(named: "Greece2") //beer
      
            
            profiletop.image =  UIImage(named: "money2")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1))
            annotationView?.addSubview(profiletop)
            annotationView?.image =  UIImage(named: "whitecircle")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: UIColor.white);
            profiletop.centerXAnchor.constraint(equalTo: annotationView!.centerXAnchor).isActive = true
            profiletop.centerYAnchor.constraint(equalTo: annotationView!.centerYAnchor).isActive = true
        }
        
        if let title = annotation.title, title ==  "Health Center"{
            //annotationView?.image = UIImage(named: "Greece2") //beer
        
            profiletop.image = UIImage(named: "health")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1))
            
            annotationView?.addSubview(profiletop)
            annotationView?.image =  UIImage(named: "whitecircle")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: UIColor.white);
            profiletop.centerXAnchor.constraint(equalTo: annotationView!.centerXAnchor).isActive = true
            profiletop.centerYAnchor.constraint(equalTo: annotationView!.centerYAnchor).isActive = true
        }
        
        if let title = annotation.title, title ==  "Science Building"{
        
     
          
            profiletop.image = UIImage(named: "science")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: UIColor.red)
            annotationView?.addSubview(profiletop)
            annotationView?.image =  UIImage(named: "whitecircle")!
                .withRenderingMode(.alwaysTemplate)
                .colorized(color: UIColor.white);
            profiletop.centerXAnchor.constraint(equalTo: annotationView!.centerXAnchor).isActive = true
            profiletop.centerYAnchor.constraint(equalTo: annotationView!.centerYAnchor).isActive = true
        }
        
        
        if let title = annotation.title, title ==  "Housing"{
               
            
                 
                   profiletop.image = UIImage(named: "housing")!
                       .withRenderingMode(.alwaysTemplate)
                       .colorized(color: UIColor.red)
                   annotationView?.addSubview(profiletop)
                   annotationView?.image =  UIImage(named: "whitecircle")!
                       .withRenderingMode(.alwaysTemplate)
                       .colorized(color: UIColor.white);
                   profiletop.centerXAnchor.constraint(equalTo: annotationView!.centerXAnchor).isActive = true
                   profiletop.centerYAnchor.constraint(equalTo: annotationView!.centerYAnchor).isActive = true
               }
        
        
        //var nameLabel;
      
       

        var i = 0
        while i < difflocationsUser.count{//print("TRUE")
            //print(difflocationsUser[i])
            
            
          //      print(difflocationsImage[i])
        
            if let title = annotation.title, title == difflocationsUser[i] {
            if(  difflocationsUser[i] != usersShowName){
//               mapProfile.loadImageUsingCacheWithUrlString(urlString: difflocationsImage[i])
//
//                mapProfile.widthAnchor.constraint(equalToConstant: 50).isActive = true
//                    mapProfile.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//                    mapProfileTap.widthAnchor.constraint(equalToConstant: 50).isActive = true
//                    mapProfileTap.heightAnchor.constraint(equalToConstant: 50).isActive = true
                let profileTemp = UIImageView()
                 profileTemp.loadImageUsingCacheWithUrlString(urlString: difflocationsImage[i])
                  profiletop.image = profileTemp.image
                 profiletop.loadImageUsingCacheWithUrlString(urlString: difflocationsImage[i])
                //profiletop.image =  UIImage(named: "whitecircle")!
                annotationView?.addSubview(profiletop)
                //annotationView?.image =  UIImage(named: "whitecircle")!
                    //.withRenderingMode(.alwaysTemplate)
                    //.colorized(color: UIColor.white);
                profiletop.centerXAnchor.constraint(equalTo: annotationView!.centerXAnchor).isActive = true
                profiletop.centerYAnchor.constraint(equalTo: annotationView!.centerYAnchor).isActive = true
                profiletop.heightAnchor.constraint(equalToConstant: 200 ).isActive = true
                annotationLabel.text = difflocationsUser[i]
                timeLabel.text = diffLocationTime[i]
//                annotationView?.addSubview(annotationLabel)
//                annotationView?.addSubview(timeLabel)
//                annotationView?.addSubview(mapProfile)
               //  annotationView?.image = UIImage(named: "music4")
               // annotationView?.username = difflocationsUser[i];
                    
               }
            
            }
            
            i = i + 1
        }
               
        
        annotationView?.canShowCallout = true
        return annotationView
    }
    
    @objc func backgroundTaps(){
    
   // print("TAPPED")
    }
    
    
    @objc func takeCareOfTaps(){
       // print("TAPPED!")
    }
    fileprivate func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot.value ?? "")
          //  let postid = snapshot.key
         let dictionary = snapshot.value as? [String: Any]
            
            let username = dictionary?[ "username"] as? String
            myUsername = username
            myProfilePicture = dictionary?[ "ProfileImage"] as? String
            self.switchison = (dictionary?[ "locationOn"] as? Bool)!
           // print(self.switchison!)
          //  print("is switch on?");
            if(self.switchison! == true){
                self.locationSwitch.isOn = true
                self.switchison=true;
                //self.map.showsUserLocation = true;
                
                
                
            }

            else if( self.switchison! == false){
                self.locationSwitch.isOn = false
                self.switchison=false;
               // self.map.showsUserLocation = false;
            }
            usersShowName = username
            
                DispatchQueue.main.async {
                    self.makeMap()
            }
        })
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
           // print("Number of comments!")
            //print(commentnum)
            if let foo = posts.first(where: { $0.postID == Message}){
                foo.numberofcomments = commentnum
                }
          
            //  print(commentnum)
            
            DispatchQueue.main.async(execute: {
                if(self.loadpostscounter < 5){
                    print("less than 5 posts")
                    print(String(self.loadpostscounter))
                }
                //if(self.firstimer==true ){
                   // popposts = posts;
               
                    posts.sort { $0.postID > $1.postID }
                    
                self.tableView.reloadData()
                
                  print("we here")
                    
                  //  self.firstimer=false;
                    
                    
                            //if(self.loadpostscounter < 5){
                            //                        self.firstimer = true;
                            //                       self.loadPosts2(completion: { message,message2 in
                            //                           self.loadPosterInfo(Message: message2, postid: message)
                            //                           self.loadLikers(Message: message)
                            //                           self.loadLikes(Message: message)
                            //                           self.loadcomments(Message: message)
                                                       
                            //                       })
                                                 print("it is true")
                                   //             }
                    // self.tableView.reloadData()

              //  }
                //  completion("loadlikes")
            })
            
        })
        
    }
    
    var firstimer2 = true
    func loadcommentsfriends(Message: String){
        // print("we here ");
        let postid = Message
        Database.database().reference().child("comments").child( postid).observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot.value ?? "")
            let dict = snapshot.value as? [String: Any]
            //print(snapshot)
            // print(snapshot.value)
            //print("snapshot")
            //print(snapshot.key)
            let commentnum = dict?[ "commentnum"] as! Int
            // print("Number of comments!")
            //print(commentnum)
            if let foo = friendsposts.first(where: { $0.postID == Message}){
                foo.numberofcomments = commentnum
            }
            
            //  print(commentnum)
            
            DispatchQueue.main.async(execute: {
                if(self.firstimer2==true ){
                  //  print("should load friendview.reloa");
                    
                    self.friendView.reloadData()
                    self.firstimer2=false;
                }
                //  completion("loadlikes")
            })
            
        })
        
    }
    
    
     var firstimer3 = true
    func loadcommentspop(Message: String){
       // print("we here ");
        let postid = Message
        Database.database().reference().child("comments").child( postid).observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot.value ?? "")
            let dict = snapshot.value as? [String: Any]
            //print(snapshot)
            // print(snapshot.value)
            //print("snapshot")
            //print(snapshot.key)
            let commentnum = dict?[ "commentnum"] as! Int
            // print("Number of comments!")
            //print(commentnum)
            if let foo = popposts.first(where: { $0.postID == Message}){
                foo.numberofcomments = commentnum
            }
            
            //  print(commentnum)
            
            DispatchQueue.main.async(execute: {
                  //popposts.sort { $0.usersName > $1.usersName }
                //if(self.firstimer3==true ){
                   // print("should load friendview.reloa");
                    popposts.sort { $0.numberoflikes > $1.numberoflikes }
                   
                    self.popView.reloadData()
                  //  self.firstimer3=false;
                //}
               // popposts.sort { $0.usersName > $1.usersName }
                //  completion("loadlikes")
            })
            
        })
        
    }
    
    var firstimer4 = true
    
    func loadcommentsEvents(Message: String){
       // print("we here ");
        let postid = Message
        Database.database().reference().child("comments").child( postid).observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot.value ?? "")
            let dict = snapshot.value as? [String: Any]
            //print(snapshot)
            // print(snapshot.value)
            //print("snapshot")
            //print(snapshot.key)
            let commentnum = dict?[ "commentnum"] as! Int
            // print("Number of comments!")
            //print(commentnum)
            if let foo = self.events.first(where: { $0.postID == Message}){
                foo.numberofcomments = commentnum
            }
            
            //  print(commentnum)
            
            DispatchQueue.main.async(execute: {
                  //popposts.sort { $0.usersName > $1.usersName }
                //if(self.firstimer4==true ){
                   // print("should load friendview.reloa");
                   // self.events.sort { $0.numberoflikes > $1.numberoflikes }
                   
                    self.eventTable.reloadData()
                  //  self.firstimer4=false;
                //}
               // popposts.sort { $0.usersName > $1.usersName }
                //  completion("loadlikes")
            })
            
        })
        
    }
  
    func loadPosterInfo(Message: String, postid: String ){
       // print(postid)
        Database.database().reference().child("users").child(Message).observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot.value ?? "")
           
            
            let dictionary = snapshot.value as? [String: Any]
            let username = dictionary?[ "username"] as? String
            
            guard let profileimageURL = dictionary?[ "ProfileImage"] as? String else {return}
            //print(username)
            //print(profileimageURL);
            if let foo = posts.first(where: { $0.postID == postid}){
                //print("HERE")
                foo.displayName = username!;
               
                foo.profImg = profileimageURL;
                
                
//                DispatchQueue.main.async(execute: {
//                    
//                        self.tableView.reloadData()
//                    
//                  
//                })
            }
        })
        
    }
    
    
    func loadPosterInfopop(Message: String, postid: String ){
           // print(postid)
            Database.database().reference().child("users").child(Message).observeSingleEvent(of: .value, with: { (snapshot) in
                //print(snapshot.value ?? "")
               
                
                let dictionary = snapshot.value as? [String: Any]
                let username = dictionary?[ "username"] as? String
                
                guard let profileimageURL = dictionary?[ "ProfileImage"] as? String else {return}
                //print(username)
                //print(profileimageURL);
                if let foo = popposts.first(where: { $0.postID == postid}){
                   // print("HERE")
                    foo.displayName = username!;
                   
                    foo.profImg = profileimageURL;
                    
                    
    //                DispatchQueue.main.async(execute: {
    //
    //                        self.tableView.reloadData()
    //
    //
    //                })
                }
            })
            
        }
    
    func loadPosterInfoEvent(Message: String, postid: String ){
              // print(postid)
               Database.database().reference().child("users").child(Message).observeSingleEvent(of: .value, with: { (snapshot) in
                   //print(snapshot.value ?? "")
                  
                   
                   let dictionary = snapshot.value as? [String: Any]
                   let username = dictionary?[ "username"] as? String
                   
                   guard let profileimageURL = dictionary?[ "ProfileImage"] as? String else {return}
                   //print(username)
                   //print(profileimageURL);
                if let foo = self.events.first(where: { $0.postID == postid}){
                      // print("HERE")
                       foo.displayName = username!;
                      
                       foo.profImg = profileimageURL;
                       
                       
       //                DispatchQueue.main.async(execute: {
       //
       //                        self.tableView.reloadData()
       //
       //
       //                })
                   }
               })
               
           }
       
    
    
    
    func loadPosterInfofriends(Message: String, postid: String ){
       // print(postid)
        Database.database().reference().child("users").child(Message).observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot.value ?? "")
            
            
            let dictionary = snapshot.value as? [String: Any]
            let username = dictionary?[ "username"] as? String
            
            guard let profileimageURL = dictionary?[ "ProfileImage"] as? String else {return}
            //print(username)
            //print(profileimageURL);
            if let foo = friendsposts.first(where: { $0.postID == postid}){
               // print("HERE")
                foo.displayName = username!;
                
                foo.profImg = profileimageURL;
                
                
                //                DispatchQueue.main.async(execute: {
                //
                //                        self.tableView.reloadData()
                //
                //
                //                })
            }
        })
        
    }
    
    
    
    
    var firstimer = true;
    
    func loadLikers(Message: String ){
       // print("LOADLIKERS")
        //print(posts.count)
          var likerarray = [User2]()
        var likersstring = "";
       
    //print("adding string likers")
            var postid =  Message
    
       // print(postid);
        Database.database().reference().child("posts").child(postid).child("likers").observe(.childAdded) {( snapshot: DataSnapshot) in
       // print("HERE")
               // var likerarray = [User2]()
            if let dict = snapshot.value as? [String: Any]{
               // print(snapshot)
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
                    //print("size is 0")
                    foo.likersstring = ""
                }
               else  if(total_count == 1){
                    //print("size =1")
                    likersstring =  "\(likerarray[total_count-1].usersname) liked the post"
                   // print(likersstring)
                    foo.likersstring = likersstring
                   // print("size = 1")
                    
                }
                else if(total_count == 2){
                    likersstring =  "\(likerarray[total_count-2].usersname) and \(likerarray[total_count-1].usersname) liked the post"
                   // print("size =2")
                   // print(likersstring)
                    
                    foo.likersstring = likersstring
                }
                    
                else if(total_count > 2){
                    likersstring =  "\(likerarray[total_count-2].usersname) and \(likerarray[total_count-1].usersname) and \(total_count - 2) others liked the post"
                   // print("size =3")
                    //print(likersstring)
                    foo.likersstring = likersstring
                }
            }
            else {
               // print("error")
                
                
        }
    
        }

          //  print("liker size")
//print(likerarray.count)
     
          
    
    }
    
    
    
    func loadLikersfriends(Message: String ){
        // print("LOADLIKERS")
        //print(posts.count)
        var likerarray = [User2]()
        var likersstring = "";
        
        //print("adding string likers")
        var postid =  Message
        
        // print(postid);
        Database.database().reference().child("posts").child(postid).child("likers").observe(.childAdded) {( snapshot: DataSnapshot) in
            // print("HERE")
            // var likerarray = [User2]()
            if let dict = snapshot.value as? [String: Any]{
                // print(snapshot)
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
            if let foo = friendsposts.first(where: { $0.postID == Message}){
                
                
                
                let total_count = likerarray.count
                var likersstring = ""
                if(total_count  == 0){
                    //print("size is 0")
                    foo.likersstring = ""
                }
                else  if(total_count == 1){
                    //print("size =1")
                    likersstring =  "\(likerarray[total_count-1].usersname) liked the post"
                    // print(likersstring)
                    foo.likersstring = likersstring
                    // print("size = 1")
                    
                }
                else if(total_count == 2){
                    likersstring =  "\(likerarray[total_count-2].usersname) and \(likerarray[total_count-1].usersname) liked the post"
                    // print("size =2")
                    // print(likersstring)
                    
                    foo.likersstring = likersstring
                }
                    
                else if(total_count > 2){
                    likersstring =  "\(likerarray[total_count-2].usersname) and \(likerarray[total_count-1].usersname) and \(total_count - 2) others liked the post"
                    // print("size =3")
                    //print(likersstring)
                    foo.likersstring = likersstring
                }
            }
            else {
                // print("error")
                
                
            }
            
        }
        
        //  print("liker size")
        //print(likerarray.count)
        
        
        
    }
    
    
    
    func loadLikerspop(Message: String ){
          // print("LOADLIKERS")
          //print(posts.count)
          var likerarray = [User2]()
          var likersstring = "";
          
          //print("adding string likers")
          var postid =  Message
          
          // print(postid);
          Database.database().reference().child("posts").child(postid).child("likers").observe(.childAdded) {( snapshot: DataSnapshot) in
              // print("HERE")
              // var likerarray = [User2]()
              if let dict = snapshot.value as? [String: Any]{
                  // print(snapshot)
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
              if let foo = popposts.first(where: { $0.postID == Message}){
                  
                  
                  
                  let total_count = likerarray.count
                  var likersstring = ""
                  if(total_count  == 0){
                      //print("size is 0")
                      foo.likersstring = ""
                  }
                  else  if(total_count == 1){
                      //print("size =1")
                      likersstring =  "\(likerarray[total_count-1].usersname) liked the post"
                      // print(likersstring)
                      foo.likersstring = likersstring
                      // print("size = 1")
                      
                  }
                  else if(total_count == 2){
                      likersstring =  "\(likerarray[total_count-2].usersname) and \(likerarray[total_count-1].usersname) liked the post"
                      // print("size =2")
                      // print(likersstring)
                      
                      foo.likersstring = likersstring
                  }
                      
                  else if(total_count > 2){
                      likersstring =  "\(likerarray[total_count-2].usersname) and \(likerarray[total_count-1].usersname) and \(total_count - 2) others liked the post"
                      // print("size =3")
                      //print(likersstring)
                      foo.likersstring = likersstring
                  }
              }
              else {
                  // print("error")
                  
                  
              }
              
          }
          
          //  print("liker size")
          //print(likerarray.count)
          
          
          
      }
    
    func loadLikersEvents(Message: String ){
            // print("LOADLIKERS")
            //print(posts.count)
            var likerarray = [User2]()
            var likersstring = "";
            
            //print("adding string likers")
            var postid =  Message
            
            // print(postid);
            Database.database().reference().child("posts").child(postid).child("likers").observe(.childAdded) {( snapshot: DataSnapshot) in
                // print("HERE")
                // var likerarray = [User2]()
                if let dict = snapshot.value as? [String: Any]{
                    // print(snapshot)
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
                if let foo = self.events.first(where: { $0.postID == Message}){
                    
                    
                    
                    let total_count = likerarray.count
                    var likersstring = ""
                    if(total_count  == 0){
                        //print("size is 0")
                        foo.likersstring = ""
                    }
                    else  if(total_count == 1){
                        //print("size =1")
                        likersstring =  "\(likerarray[total_count-1].usersname) liked the post"
                        // print(likersstring)
                        foo.likersstring = likersstring
                        // print("size = 1")
                        
                    }
                    else if(total_count == 2){
                        likersstring =  "\(likerarray[total_count-2].usersname) and \(likerarray[total_count-1].usersname) liked the post"
                        // print("size =2")
                        // print(likersstring)
                        
                        foo.likersstring = likersstring
                    }
                        
                    else if(total_count > 2){
                        likersstring =  "\(likerarray[total_count-2].usersname) and \(likerarray[total_count-1].usersname) and \(total_count - 2) others liked the post"
                        // print("size =3")
                        //print(likersstring)
                        foo.likersstring = likersstring
                    }
                }
                else {
                    // print("error")
                    
                    
                }
                
            }
            
            //  print("liker size")
            //print(likerarray.count)
            
            
            
        }
    
    
    
    

    



    
    @IBOutlet weak var degmentcontrolnum: UISegmentedControl!
    
    @IBAction func popular_events_actions(_ sender: Any) {
        if(degmentcontrolnum.selectedSegmentIndex == 3){
            let date = Date()
            let  dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, YYYY"
            
            currentDay =  dateFormatter.string(from: date)
            //loadEvents()
            eventTable.isHidden = false
            friendView.isHidden = true
        eventTable.reloadData()
       // print("EVENTS BABY")
        }
        if(degmentcontrolnum.selectedSegmentIndex == 0){
         eventTable.isHidden = true
            popView.isHidden = true
            tableView.isHidden = false
            friendView.isHidden = true
        }
        
        if(degmentcontrolnum.selectedSegmentIndex == 1){
                self.popView.reloadData()
         eventTable.isHidden = true
            tableView.isHidden = true
            friendView.isHidden = true
            popView.isHidden = false
        }
        
        if(degmentcontrolnum.selectedSegmentIndex == 2){
        friendView.reloadData()
            eventTable.isHidden = true
            tableView.isHidden = true
            friendView.isHidden = false
            popView.isHidden = true
            
        }
    }
    
    
    
    
    var events = [Post]()
    var currentDay: String?
    
//    func loadEvents() {
//        events.removeAll()
//        var current = "noday"
//        Database.database().reference().child("events").observe(.childAdded) {(snapshot: DataSnapshot) in
//            //print("HERE")
//            let postid = snapshot.key
//          //  print(postid)
//
//            //  print(postid)
//            Database.database().reference().child("events").child(postid).observe(.childAdded) {(snapshot: DataSnapshot) in
//
//                if let dict = snapshot.value as? [String: Any]{
//                    let enddate = dict["EndDate"] as! String
//                    //let captionText = "Caption"
//                    let eventdescription = dict["EventDescription"] as! String
//                    //backgroundTableCellSize = 400
//                    let eventtitle = dict["EventTitle"] as! String
//                    let startdate = dict["StartDate"] as! String
//                  //  print(startdate)
//                    let posterid = dict["posterid"] as! String
//                    let profileurl = dict["ProfileUrl"] as! String
//                    let posterusername = dict["PosterUsername"] as! String
//                    let timeendstring =  dict["EndDateString"] as! String
//                    let timestartstring = dict["StartTimeString"] as! String
//                    let locations = dict["Locations"] as! String
//                    let descriptioncount =  dict["DescriptionCount"] as! Int
//                    let eventcount = dict["EventCount"] as! Int
//                    let datestring = dict["DateString"] as! String
//                    //current = datestring
//
//
//                    if(current != datestring && datestring != self.currentDay ){
//                       // print(datestring)
//                        current = datestring
//                        let event = Event(
//                            enddate: "", eventdescription:"justadate",
//                            eventtitle:"justadate",
//                            startdate:"",
//                            posterid:"",  profileurl: "", timestartstring: "", timeendstring: "",
//                            posterusername: "", locations: "", descriptioncount: 0, eventcount: 0, datestring: datestring )
//                        //self.events.insert(event, at: 0)
//                        self.events.append(event)
//
//                    }
//
//                    let event = Event(
//                        enddate: enddate, eventdescription:eventdescription,
//                        eventtitle:eventtitle,
//                        startdate:startdate,
//                        posterid:posterid,  profileurl: profileurl, timestartstring: timestartstring, timeendstring: timeendstring,
//                        posterusername: posterusername, locations: locations, descriptioncount:descriptioncount, eventcount: eventcount, datestring: datestring )
//                    //self.events.insert(event, at: 0)
//                    self.events.append(event)
//                   // print("WE ARE HERE")
//                  //  print(current)
//                   // print(datestring)
//
//
//                    DispatchQueue.main.async(execute: {
//                        self.eventTable.reloadData()
//                    })
//                }
//
//                DispatchQueue.main.async(execute: {
//                    self.eventTable.reloadData()
//                })
//            }
//        }
//    }
    
    
    

    
    
    
    
    func loadLikers2(Message: String, completion: @escaping (_ message: String) -> Void){
        print("HERE")
        // print("LOADLIKERS")
        //print(posts.count)
        var likerarray = [User2]()
        var likersstring = "";
        
        //print("adding string likers")
        var postid =  Message
        var likedbyme2 = false
         print(postid);
        
             
        //print(postid);
       
       Database.database().reference().child("posts").child(postid).observeSingleEvent(of: .value, with: { (snapshot) in

            if snapshot.hasChild("likers"){

                
            }else{
print("we in here")
                if let foo = posts.first(where: { $0.postID == Message}){
                 
                print("default")
                                     
                                            let total_count = likerarray.count
                     print(likerarray.count)
                                          //print(total_count)
                                             foo.numberoflikes = total_count
                                            var likersstring = ""
                                             // print("ZERO!")
                     foo.likedby = false
                                                likersstring =  ""
                                             foo.numberoflikes = total_count
                                                //print(likersstring)
                                                foo.likersstring = likersstring
                                               // print("size = 0")
                                               
                 
                                            
                  completion("done");
                                        }
               
            }


        })
        
        Database.database().reference().child("posts").child(postid).child("likers").observe(.childAdded) {( snapshot: DataSnapshot) in
            // print("HERE")
            // var likerarray = [User2]()
           
            
                        if let dict = snapshot.value as? [String: Any]{
                            
                print(dict)
                            print("not zero!")
                //print(snapshot)
                let usersname = dict["likerName"] as! String
                print(usersname)
                let userid = dict["likersid"] as! String
                let likerurl = ""
                
                let liker = User2(profileImageUrl: likerurl, usersName: usersname, usersId: userid)
                //print(liker)
                likerarray.append(liker)
                if(liker.usersid == self.uid! ){
                    likedbyme2 = true;
                }
                //print("liker size in closure")
                // print(likerarray.count)
                
                DispatchQueue.main.async(execute: {
            
                   if let foo = posts.first(where: { $0.postID == Message}){
                         print(likerarray.count)
                         print("in here")
                    foo.likedby = likedbyme2
                                  let total_count = likerarray.count
                    print(total_count)
                                   foo.numberoflikes = total_count
                                  var likersstring = ""
                                  if(total_count  == 0){
                                      likersstring =  ""
                                     print ("im zero")
                                      foo.likersstring = likersstring
                                    //  print("size = 0")
                                      completion("done")
                                      
                                  }
                                  else  if(total_count == 1){
                                      //print("size =1")
                                      likersstring =  "\(likerarray[total_count-1].usersname) liked the post"
                                      //print(likersstring)
                                      foo.likersstring = likersstring
                                      //print("size = 1")
                                      completion("done")
                                      
                                  }
                                  else if(total_count == 2){
                                      likersstring =  "\(likerarray[total_count-2].usersname) and \(likerarray[total_count-1].usersname) liked the post"
                                     // print("size =2")
                                      //print(likersstring)
                                      
                                      foo.likersstring = likersstring
                                      completion("done")
                                  }
                                      
                                  else if(total_count > 2){
                                      likersstring =  "\(likerarray[total_count-2].usersname) and \(likerarray[total_count-1].usersname) and \(total_count - 2) others liked the post"
                                      //print("size =3")
                                      //print(likersstring)
                                      foo.likersstring = likersstring
                                      completion("done")
                                  }
                              }
                              else {
                                  print("error")
                                  
                                  
                              }
                              
                          
                })
                
            }
        }
        
       // print("liker size")
      //  print(likerarray.count)
        
   
        
    }
    
    
    
    func loadLikers2event(Message: String, completion: @escaping (_ message: String) -> Void){
            print("HERE")
            // print("LOADLIKERS")
            //print(posts.count)
            var likerarray = [User2]()
            var likersstring = "";
            
            //print("adding string likers")
            var postid =  Message
            var likedbyme2 = false
             print(postid);
            
                 
            //print(postid);
           
           Database.database().reference().child("posts").child(postid).observeSingleEvent(of: .value, with: { (snapshot) in

                if snapshot.hasChild("likers"){

                    
                }else{
    print("we in here")
                    if let foo = self.events.first(where: { $0.postID == Message}){
                     
                    print("default")
                                         
                                                let total_count = likerarray.count
                         print(likerarray.count)
                                              //print(total_count)
                                                 foo.numberoflikes = total_count
                                                var likersstring = ""
                                                 // print("ZERO!")
                         foo.likedby = false
                                                    likersstring =  ""
                                                 foo.numberoflikes = total_count
                                                    //print(likersstring)
                                                    foo.likersstring = likersstring
                                                   // print("size = 0")
                                                   
                     
                                                
                      completion("done");
                                            }
                   
                }


            })
            
            Database.database().reference().child("posts").child(postid).child("likers").observe(.childAdded) {( snapshot: DataSnapshot) in
                // print("HERE")
                // var likerarray = [User2]()
               
                
                            if let dict = snapshot.value as? [String: Any]{
                                
                    print(dict)
                                print("not zero!")
                    //print(snapshot)
                    let usersname = dict["likerName"] as! String
                    print(usersname)
                    let userid = dict["likersid"] as! String
                    let likerurl = ""
                    
                    let liker = User2(profileImageUrl: likerurl, usersName: usersname, usersId: userid)
                    //print(liker)
                    likerarray.append(liker)
                    if(liker.usersid == self.uid! ){
                        likedbyme2 = true;
                    }
                    //print("liker size in closure")
                    // print(likerarray.count)
                    
                    DispatchQueue.main.async(execute: {
                
                        if let foo = self.events.first(where: { $0.postID == Message}){
                             print(likerarray.count)
                             print("in here")
                        foo.likedby = likedbyme2
                                      let total_count = likerarray.count
                        print(total_count)
                                       foo.numberoflikes = total_count
                                      var likersstring = ""
                                      if(total_count  == 0){
                                          likersstring =  ""
                                         print ("im zero")
                                          foo.likersstring = likersstring
                                        //  print("size = 0")
                                          completion("done")
                                          
                                      }
                                      else  if(total_count == 1){
                                          //print("size =1")
                                          likersstring =  "\(likerarray[total_count-1].usersname) liked the post"
                                          //print(likersstring)
                                          foo.likersstring = likersstring
                                          //print("size = 1")
                                          completion("done")
                                          
                                      }
                                      else if(total_count == 2){
                                          likersstring =  "\(likerarray[total_count-2].usersname) and \(likerarray[total_count-1].usersname) liked the post"
                                         // print("size =2")
                                          //print(likersstring)
                                          
                                          foo.likersstring = likersstring
                                          completion("done")
                                      }
                                          
                                      else if(total_count > 2){
                                          likersstring =  "\(likerarray[total_count-2].usersname) and \(likerarray[total_count-1].usersname) and \(total_count - 2) others liked the post"
                                          //print("size =3")
                                          //print(likersstring)
                                          foo.likersstring = likersstring
                                          completion("done")
                                      }
                                  }
                                  else {
                                      print("error")
                                      
                                      
                                  }
                                  
                              
                    })
                    
                }
            }
            
           // print("liker size")
          //  print(likerarray.count)
            
       
            
        }
    
    
    func loadLikers2pop(Message: String, completion: @escaping (_ message: String) -> Void){
       print("HERE")
                   // print("LOADLIKERS")
                   //print(posts.count)
                   var likerarray = [User2]()
                   var likersstring = "";
                   
                   //print("adding string likers")
                   var postid =  Message
                   var likedbyme2 = false
                    print(postid);
                   
                        
                   //print(postid);
                  
                  Database.database().reference().child("posts").child(postid).observeSingleEvent(of: .value, with: { (snapshot) in

                       if snapshot.hasChild("likers"){

                           
                       }else{
           print("we in here")
                           if let foo = popposts.first(where: { $0.postID == Message}){
                            
                           print("default")
                                                
                                                       let total_count = likerarray.count
                                print(likerarray.count)
                                                     //print(total_count)
                                                        foo.numberoflikes = total_count
                                                       var likersstring = ""
                                                        // print("ZERO!")
                                foo.likedby = false
                                                           likersstring =  ""
                                                        foo.numberoflikes = total_count
                                                           //print(likersstring)
                                                           foo.likersstring = likersstring
                                                          // print("size = 0")
                                                          
                            
                                                       
                             completion("done");
                                                   }
                          
                       }


                   })
                   
                   Database.database().reference().child("posts").child(postid).child("likers").observe(.childAdded) {( snapshot: DataSnapshot) in
                       // print("HERE")
                       // var likerarray = [User2]()
                      
                       
                                   if let dict = snapshot.value as? [String: Any]{
                                       
                           print(dict)
                                       print("not zero!")
                           //print(snapshot)
                           let usersname = dict["likerName"] as! String
                           print(usersname)
                           let userid = dict["likersid"] as! String
                           let likerurl = ""
                           
                           let liker = User2(profileImageUrl: likerurl, usersName: usersname, usersId: userid)
                           //print(liker)
                           likerarray.append(liker)
                           if(liker.usersid == self.uid! ){
                               likedbyme2 = true;
                           }
                           //print("liker size in closure")
                           // print(likerarray.count)
                           
                           DispatchQueue.main.async(execute: {
                       
                              if let foo = popposts.first(where: { $0.postID == Message}){
                                    print(likerarray.count)
                                    print("in here")
                               foo.likedby = likedbyme2
                                             let total_count = likerarray.count
                               print(total_count)
                                              foo.numberoflikes = total_count
                                             var likersstring = ""
                                             if(total_count  == 0){
                                                 likersstring =  ""
                                                print ("im zero")
                                                 foo.likersstring = likersstring
                                               //  print("size = 0")
                                                 completion("done")
                                                 
                                             }
                                             else  if(total_count == 1){
                                                 //print("size =1")
                                                 likersstring =  "\(likerarray[total_count-1].usersname) liked the post"
                                                 //print(likersstring)
                                                 foo.likersstring = likersstring
                                                 //print("size = 1")
                                                 completion("done")
                                                 
                                             }
                                             else if(total_count == 2){
                                                 likersstring =  "\(likerarray[total_count-2].usersname) and \(likerarray[total_count-1].usersname) liked the post"
                                                // print("size =2")
                                                 //print(likersstring)
                                                 
                                                 foo.likersstring = likersstring
                                                 completion("done")
                                             }
                                                 
                                             else if(total_count > 2){
                                                 likersstring =  "\(likerarray[total_count-2].usersname) and \(likerarray[total_count-1].usersname) and \(total_count - 2) others liked the post"
                                                 //print("size =3")
                                                 //print(likersstring)
                                                 foo.likersstring = likersstring
                                                 completion("done")
                                             }
                                         }
                                         else {
                                             print("error")
                                             
                                             
                                         }
                                         
                                     
                           })
                           
                       }
                   }
           
       }
    
    
    func loadLikers2friends(Message: String, completion: @escaping (_ message: String) -> Void){
           // print("LOADLIKERS")
           //print(posts.count)
          print("HERE")
                   // print("LOADLIKERS")
                   //print(posts.count)
                   var likerarray = [User2]()
                   var likersstring = "";
                   
                   //print("adding string likers")
                   var postid =  Message
                   var likedbyme2 = false
                    print(postid);
                   
                        
                   //print(postid);
                  
                  Database.database().reference().child("posts").child(postid).observeSingleEvent(of: .value, with: { (snapshot) in

                       if snapshot.hasChild("likers"){

                           
                       }else{
           print("we in here")
                           if let foo = friendsposts.first(where: { $0.postID == Message}){
                            
                           print("default")
                                                
                                                       let total_count = likerarray.count
                                print(likerarray.count)
                                                     //print(total_count)
                                                        foo.numberoflikes = total_count
                                                       var likersstring = ""
                                                        // print("ZERO!")
                                foo.likedby = false
                                                           likersstring =  ""
                                                        foo.numberoflikes = total_count
                                                           //print(likersstring)
                                                           foo.likersstring = likersstring
                                                          // print("size = 0")
                                                          
                            
                                                       
                             completion("done");
                                                   }
                          
                       }


                   })
                   
                   Database.database().reference().child("posts").child(postid).child("likers").observe(.childAdded) {( snapshot: DataSnapshot) in
                       // print("HERE")
                       // var likerarray = [User2]()
                      
                       
                                   if let dict = snapshot.value as? [String: Any]{
                                       
                           print(dict)
                                       print("not zero!")
                           //print(snapshot)
                           let usersname = dict["likerName"] as! String
                           print(usersname)
                           let userid = dict["likersid"] as! String
                           let likerurl = ""
                           
                           let liker = User2(profileImageUrl: likerurl, usersName: usersname, usersId: userid)
                           //print(liker)
                           likerarray.append(liker)
                           if(liker.usersid == self.uid! ){
                               likedbyme2 = true;
                           }
                           //print("liker size in closure")
                           // print(likerarray.count)
                           
                           DispatchQueue.main.async(execute: {
                       
                              if let foo = friendsposts.first(where: { $0.postID == Message}){
                                    print(likerarray.count)
                                    print("in here")
                               foo.likedby = likedbyme2
                                             let total_count = likerarray.count
                               print(total_count)
                                              foo.numberoflikes = total_count
                                             var likersstring = ""
                                             if(total_count  == 0){
                                                 likersstring =  ""
                                                print ("im zero")
                                                 foo.likersstring = likersstring
                                               //  print("size = 0")
                                                 completion("done")
                                                 
                                             }
                                             else  if(total_count == 1){
                                                 //print("size =1")
                                                 likersstring =  "\(likerarray[total_count-1].usersname) liked the post"
                                                 //print(likersstring)
                                                 foo.likersstring = likersstring
                                                 //print("size = 1")
                                                 completion("done")
                                                 
                                             }
                                             else if(total_count == 2){
                                                 likersstring =  "\(likerarray[total_count-2].usersname) and \(likerarray[total_count-1].usersname) liked the post"
                                                // print("size =2")
                                                 //print(likersstring)
                                                 
                                                 foo.likersstring = likersstring
                                                 completion("done")
                                             }
                                                 
                                             else if(total_count > 2){
                                                 likersstring =  "\(likerarray[total_count-2].usersname) and \(likerarray[total_count-1].usersname) and \(total_count - 2) others liked the post"
                                                 //print("size =3")
                                                 //print(likersstring)
                                                 foo.likersstring = likersstring
                                                 completion("done")
                                             }
                                         }
                                         else {
                                             print("error")
                                             
                                             
                                         }
                                         
                                     
                               
           //                    if let foo = posts.first(where: { $0.postID == Message}){
           //
           //
           //                           foo.likedby = likedbyme2
           //                           let total_count = likerarray.count
           //                         //print(total_count)
           //                            foo.numberoflikes = total_count
           //                           var likersstring = ""
           //                           if(total_count  == 0){
           //                               likersstring =  ""
           //                               //print(likersstring)
           //                               foo.likersstring = likersstring
           //                              // print("size = 0")
           //                               completion("done")
           //
           //                           }
           //
           //                       }
                           })
                           
                       }
                   }
           
       }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        print("bottom");
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
      
        // Change 10.0 to adjust the distance from bottom
        firstimer = true;
         firstimer3 = true
        firstimer2 = true ;
        
        if maximumOffset - currentOffset <= 10.0 {
            if(degmentcontrolnum.selectedSegmentIndex == 0){
                if(posts.count != 0 ){
            print("adding more posts")
            print(doneloadposts)
               // if(doneloadposts == false){
                iteration = 0;
                boolarray.removeAll()
                loadpostscounter = 0
                    boolarray.append(false)
                self.loadPosts2(iteration: iteration, completion: { message,message2 in
                        self.loadPosterInfo(Message: message2, postid: message)
                        self.loadLikers(Message: message)
                        self.loadLikes(Message: message)
                        self.loadcomments(Message: message)

                    })
                
            //}
            }//if segmented ==0
            }
            
            if(degmentcontrolnum.selectedSegmentIndex == 1){
//                 if(doneloadposts2 == false){
//            print("adding more posts")
//           // if(doneloadposts == false){
//               iterationpop = 0;
//               boolarray2.removeAll()
//               loadpostscounter = 0
//                   boolarray2.append(false)
//                    self.loadPostspop2(iteration:iterationpop, completion: { message,message2 in
//                        self.loadPosterInfopop(Message: message2, postid: message)
//                        self.loadLikerspop(Message: message)
//                        self.loadLikespop(Message: message)
//                        self.loadcommentspop(Message: message)
//
//                    })
//
//
//            //}
//            }//if segmented ==0
            
            }
            
            
            
            if(degmentcontrolnum.selectedSegmentIndex == 2){
                if(doneloadposts3 == false && friendsposts.count != 0){
            self.loadfirst5postsfriends2(completion: { message3 in self.loadPostsfriends2(postidforload: message3, completion: { message, message2 in
                 self.loadPosterInfofriends(Message: message2, postid: message)
                 self.loadLikersfriends(Message: message)
                 self.loadLikesfriends(Message: message)
                 self.loadcommentsfriends(Message: message)

             })
            })
            }
            }
            
            
            if(degmentcontrolnum.selectedSegmentIndex == 3){
                
                print("loading events on drag")
                print(bottomevent)
                iterationevent = 0;
                boolarrayevent.removeAll()
                loadpostscounterevent = 0
                firstimer4 = true
                    boolarrayevent.append(false)
                self.loadPostsEvents2(iteration: self.iterationevent,completion: { message,message2 in
                                          self.loadPosterInfoEvent(Message: message2, postid: message)
                                           self.loadLikersEvents(Message: message)
                                           self.loadLikesEvents(Message: message)
                                        self.loadcommentsEvents(Message: message)
                })

                
                
            }
        }
       
    }
    var bottom: String?
    var querryingmore = false;
  
    
  var loadpostscounter = 0;
    @IBOutlet weak var shouldbeimage: UIImageView!
   
    
    func loadPosts(completion: @escaping (_ message: String,_ message2: String) -> Void){
        posts.removeAll()
        print("in load post")
        loadpostscounter = 0;
        var simplecounter = 0;
          var loadpostsdone = true
        var tommy = true ;
        Database.database().reference().child("posts").queryOrderedByKey().queryLimited(toLast: 5).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
         
        
          // print(postid)
          
          for rest in snapshot.children.allObjects as! [DataSnapshot] {
              print("KEY")
              print(rest.key)
              
    
            
            simplecounter = simplecounter + 1;
                        let postid = rest.key
               if(simplecounter == 1){
                   self.bottom = postid
               }
            
          if let dict = rest.value as? [String: Any] {
            
            
    print("postid and simple counter ")
    print(postid)
    print(simplecounter)
   // if(simplecounter == 4){
           // self.bottom = postid
   // }
          //  print(postid
                let captionText = dict["caption"] as! String
                //let captionText = "Caption"
                let photoURLString = dict["imageUrl"] as! String
                 //backgroundTableCellSize = 400
                let USERNAME = dict["usersName"] as! String
                let locationText = dict["location"] as! String
                let likes = dict["numberoflikes"] as! Int
                let postcount = dict["charactercount"] as! Int
                let global = dict["Global"] as! Bool
               // print(global)
                 let postorevent = dict["postorevent"] as! String
                let spaces =  dict["numberofspaces"] as! Int
               // print(postorevent)
                var likedbyme = false ;
                 var likerarray = [User2] ()
               
                 let sizer = Int(posts.count)
                
                
                var likersstring = "";
            
             
                let postnumber = postid
                let numberofcomments = dict["numberofcomments"] as! Int
               let postTime = dict["creationDate"] as! TimeInterval
               // let Audio64 = dict["Audio64"] as! String
                 let Audio64 = dict["Audio64"] as! String
              //  print(Audio64)
                //405
                let timeendstring =  dict["EndDateString"] as! String
                let timestartstring = dict["StartTimeString"] as! String
               
                
                let post = Post(captionText: captionText
                    , photoURLString: photoURLString, USERNAME: USERNAME, locationText: locationText, likes: likes, likedbyme: likedbyme, postid: postid, postcount: postcount, Audio64: Audio64, postTime: postTime,likerArray: likerarray, likersString: likersstring,numberOfComments: numberofcomments, Global: global, postOrEvent: postorevent , timestartstring: timestartstring, timeendstring: timeendstring, displayname: "", profimg: "" , score: 0, spaces: spaces)
                // posts.append(post)
                if let foo = posts.first(where: { $0.postID == postid}){
                          //do nothing if already added
                               }
                 
                else{
                if(global==false){
                    if friendsList.contains(USERNAME) {
                         posts.insert(post, at: 0 )
                        self.loadpostscounter+=1;
                       // print("loadpost1")
                        completion(postid, USERNAME)
                       //  self.loadPosterInfo(Message: USERNAME, postid: postid)
                    }
                    else if(USERNAME == id){
                        posts.insert(post, at: 0 )
                        self.loadpostscounter+=1;
                        // print("loadpost1")
                         completion(postid, USERNAME)
                        // self.loadPosterInfo(Message: USERNAME, postid: postid)
                        
                    }
                    
                }
                
            
                else if(global==true){
                posts.insert(post, at: 0 )
                 completion(postid, USERNAME)
                    // print("loadpost1")
                    self.loadpostscounter+=1;
                   // self.loadPosterInfo(Message: USERNAME, postid: postid)
                }
            }
                DispatchQueue.main.async(execute: {
                    //simplecounter = simplecounter + 1;
                    if(simplecounter == 5 && loadpostsdone == true ){
                        loadpostsdone = false
                       // print("now we are loading more")
                        
                        self.querryingmore = true;
                        self.boolarray.append(false);
                        self.loadPosts2(iteration: 0,completion: { message,message2 in
                                                  self.loadPosterInfo(Message: message2, postid: message)
                                                   self.loadLikers(Message: message)
                                                   self.loadLikes(Message: message)
                                                   self.loadcomments(Message: message)
                        })



                    }
                   
                })
        
            //}
         
            }}
            
            
        })
       


    }//end of load posts
    
    var doneloadposts = false
      var doneloadposts2 = false
    var iteration = 0;
    var boolarray = [Bool]()
    
    func loadPosts2(iteration : Int, completion: @escaping (_ message: String,_ message2: String) -> Void){
         //  posts.removeAll()
        print("load posts 2")
        print("count:")
        var lengthcount =  posts.count;
        print(lengthcount)
        print("bottom:")
        var last_post = bottom!
        print(last_post)
        var counter = 0
       // print(
        Database.database().reference().child("posts").queryOrderedByKey().queryEnding(atValue: bottom).queryLimited(toLast: 5).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
             
            
              // print(postid)
              
              for rest in snapshot.children.allObjects as! [DataSnapshot] {
                  print("KEY")
                  print(rest.key)
                  
        
                
             let postid = rest.key
                    counter = counter + 1;
                    if(counter == 1){
                            self.bottom = postid
                       
                    }
                
              if let dict = rest.value as? [String: Any] {
            
            
          //  print("in here baby")
          
             //  print(postid)
                   let captionText = dict["caption"] as! String
                   //let captionText = "Caption"
                print("user post capt")
                          print(captionText)
                   let photoURLString = dict["imageUrl"] as! String
                    //backgroundTableCellSize = 400
                   let USERNAME = dict["usersName"] as! String
                   let locationText = dict["location"] as! String
                   let likes = dict["numberoflikes"] as! Int
                   let postcount = dict["charactercount"] as! Int
                   let global = dict["Global"] as! Bool
                  // print(global)
                    let postorevent = dict["postorevent"] as! String
                   let spaces =  dict["numberofspaces"] as! Int
                  // print(postorevent)
                   var likedbyme = false ;
                    var likerarray = [User2] ()
                  
                    let sizer = Int(posts.count)
                   
                   
                   var likersstring = "";
               
                
                   let postnumber = postid
                   let numberofcomments = dict["numberofcomments"] as! Int
                  let postTime = dict["creationDate"] as! TimeInterval
                  // let Audio64 = dict["Audio64"] as! String
                    let Audio64 = dict["Audio64"] as! String
                 //  print(Audio64)
                   //405
                   let timeendstring =  dict["EndDateString"] as! String
                   let timestartstring = dict["StartTimeString"] as! String
                  
                   
                   let post = Post(captionText: captionText
                       , photoURLString: photoURLString, USERNAME: USERNAME, locationText: locationText, likes: likes, likedbyme: likedbyme, postid: postid, postcount: postcount, Audio64: Audio64, postTime: postTime,likerArray: likerarray, likersString: likersstring,numberOfComments: numberofcomments, Global: global, postOrEvent: postorevent , timestartstring: timestartstring, timeendstring: timeendstring, displayname: "", profimg: "" , score: 0, spaces: spaces)
                   // posts.append(post)
                
                if(last_post != postid){
                    
                    if let foo = posts.first(where: { $0.postID == postid}){
                                                   //do nothing if already added
                                                        }
                                          
                                         else{
                   if(global==false){
                       if friendsList.contains(USERNAME) {
                            posts.insert(post, at: lengthcount)
                         self.loadpostscounter+=1;
                           completion(postid, USERNAME)
                            //self.loadPosterInfo(Message: USERNAME, postid: postid)
                       }
                       else if(USERNAME == id){
                        posts.insert(post, at: lengthcount)
                         self.loadpostscounter+=1;
                       completion(postid, USERNAME)
                          //  self.loadPosterInfo(Message: USERNAME, postid: postid)
                           
                       }
                       
                   }
                   else if(global==true){
                      posts.insert(post, at: lengthcount)
                     self.loadpostscounter+=1;
                   completion(postid, USERNAME)
                       //self.loadPosterInfo(Message: USERNAME, postid: postid)
                   }
                }
                   DispatchQueue.main.async(execute: {
                    //print("this the size baby!!!!")
                    
                    if( counter == 5 && self.loadpostscounter < 5 && self.boolarray[iteration] == false){
                        //self.bottom = posts[posts.count-1].postID
                        self.boolarray[iteration] = true
                        self.boolarray.append(false);
                        print("This better not get called twice")
                        self.iteration = iteration + 1
                        self.loadPosts2(iteration: iteration , completion: { message,message2 in
                                                  self.loadPosterInfo(Message: message2, postid: message)
                                                   self.loadLikers(Message: message)
                                                   self.loadLikes(Message: message)
                                                   self.loadcomments(Message: message)
                        })

                        
                        
                    }
                   
                    print(counter)
               // self.tableView.reloadData()
                   })
                }
               }
               
           }
          
        })

       }//end of load posts
       
    
    
    
    func loadfirst5postsfriends(completion: @escaping (_ message2: String) -> Void){
       print("load5posts"); Database.database().reference().child("users").child(uid!).child("friendposts").queryLimited(toLast: 5).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
        
        for rest in snapshot.children.allObjects as! [DataSnapshot] {
                     print("KEY")
                     print(rest.key)
                     
           
                   
            let postid = rest.key
                   
                 if let dict = rest.value as? [String: Any] {
                  //print("HERE")
                 // let postid = snapshot.key
           print("posterid")
                    print(postid)
           completion(postid)
              
            }
       }
       
        })
    }
    
     var counterfriends = 0
     var doneloadposts3 = false
    
    func loadfirst5postsfriends2(completion: @escaping (_ message2: String) -> Void){
       print("load5posts");
        counterfriends = 0;
        Database.database().reference().child("users").child(uid!).child("friendposts").queryOrderedByKey().queryEnding(atValue: friendsposts[friendsposts.count-1].postID).queryLimited(toLast: 5).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
         
        
          // print(postid)
          
          for rest in snapshot.children.allObjects as! [DataSnapshot] {
             
                let postid = rest.key
            self.counterfriends = self.counterfriends + 1;
            
                  //print("HERE")
           print("posterid")
                    print(postid)
           completion(postid)
              DispatchQueue.main.async(execute: {
                  if(self.counterfriends == 1){
                      self.doneloadposts3  = true;
                  }
              })
        
       }
        })
       
       
    }
    
    func loadPostsfriends(postidforload: String, completion: @escaping (_ message: String,_ message2: String) -> Void){
        friendsposts.removeAll()
        var counter = 0;
        let postref4 = Database.database().reference().child("posts").child(postidforload).observeSingleEvent(of: .value) {(snapshot: DataSnapshot) in
           // print("Finding loadposts for friends");
            //print("HERE")
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
                 let spaces =  dict["numberofspaces"] as! Int
                
                let postcount = dict["charactercount"] as! Int
                let global = dict["Global"] as! Bool
                // print(global)
                let postorevent = dict["postorevent"] as! String
                // print(postorevent)
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
                
                 let numberofcomments = dict["numberofcomments"] as! Int
                let post = Post(captionText: captionText
                    , photoURLString: photoURLString, USERNAME: USERNAME, locationText: locationText, likes: likes, likedbyme: likedbyme, postid: postid, postcount: postcount, Audio64: Audio64, postTime: postTime,likerArray: likerarray, likersString: likersstring,numberOfComments: numberofcomments, Global: global, postOrEvent: postorevent , timestartstring: timestartstring, timeendstring: timeendstring, displayname: "", profimg: "" , score: 0, spaces: spaces)
                // posts.append(post)
            
                   // if friendsList.contains(USERNAME) {
                        friendsposts.insert(post, at: 0 )
                        completion(postid, USERNAME)
                        //self.loadPosterInfofriends(Message: USERNAME, postid: postid)
                        counter = counter + 1;
                        if(counter == 3){
                             //postref4.removeAllObservers()
                            
                        }
                        
                   // }
//                     if(USERNAME == id){
//                        if let foo = friendsposts.first(where: { $0.postID == postid}){
//                        }
//                        else{
//                    friendsposts.insert(post, at: 0 )
//                        completion(postid)
//                        self.loadPosterInfofriends(Message: USERNAME, postid: postid)
//                        }
//
//                    }
                
                
                DispatchQueue.main.async(execute: {
                    // self.tableView.reloadData()
                })
                
            }
            
        }
        
        
        
    }//end of load posts
    
    func loadPostsfriends2(postidforload: String, completion: @escaping (_ message: String,_ message2: String) -> Void){
            //friendsposts.removeAll()
        
        var last_post = friendsposts[friendsposts.count-1].postID;
               var lengthcount =  friendsposts.count;
            var counter = 0;
            let postref4 = Database.database().reference().child("posts").child(postidforload).observeSingleEvent(of: .value) {(snapshot: DataSnapshot) in
               // print("Finding loadposts for friends");
                //print("HERE")
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
                     let spaces =  dict["numberofspaces"] as! Int
                    
                    let postcount = dict["charactercount"] as! Int
                    let global = dict["Global"] as! Bool
                    // print(global)
                    let postorevent = dict["postorevent"] as! String
                    // print(postorevent)
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
                    
                     let numberofcomments = dict["numberofcomments"] as! Int
                    let post = Post(captionText: captionText
                        , photoURLString: photoURLString, USERNAME: USERNAME, locationText: locationText, likes: likes, likedbyme: likedbyme, postid: postid, postcount: postcount, Audio64: Audio64, postTime: postTime,likerArray: likerarray, likersString: likersstring,numberOfComments: numberofcomments, Global: global, postOrEvent: postorevent , timestartstring: timestartstring, timeendstring: timeendstring, displayname: "", profimg: "" , score: 0, spaces: spaces)
                    // posts.append(post)
                
                       // if friendsList.contains(USERNAME) {
                    if(last_post != postid){
                            friendsposts.insert(post, at: lengthcount )
                            completion(postid, USERNAME)
                            
                    }
                            counter = counter + 1;
                            if(counter == 3){
                                 //postref4.removeAllObservers()
                                
                            }
                            
                       // }
    //                     if(USERNAME == id){
    //                        if let foo = friendsposts.first(where: { $0.postID == postid}){
    //                        }
    //                        else{
    //                    friendsposts.insert(post, at: 0 )
    //                        completion(postid)
    //                        self.loadPosterInfofriends(Message: USERNAME, postid: postid)
    //                        }
    //
    //                    }
                    
                    
                    DispatchQueue.main.async(execute: {
                        // self.tableView.reloadData()
                    })
                    
                }
                
            }
            
            
            
        }//end of load pos
    
     var loadpostscounterpop = 0;
    var bottompop: String?
     var boolarray2 = [Bool]()
     var iterationpop = 0;
    
    
    func loadPostspop(completion: @escaping (_ message: String,_ message2: String) -> Void){
        
           popposts.removeAll()
        loadpostscounterpop = 0;
        var simplecounterpop = 0;
        var loadpostsdonepop = true
        let postRef2 = Database.database().reference().child("posts").queryOrdered(byChild: "numberoflikes").queryLimited(toLast: 10)
        postRef2.observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
         
        
          // print(postid)
          
          for rest in snapshot.children.allObjects as! [DataSnapshot] {
             
                let postid = rest.key
            simplecounterpop = simplecounterpop + 1;
            //if(simplecounterpop == 1){
                   self.bottompop = postid
          if let dict = rest.value as? [String: Any] {
                        //print("HERE")
                         //let postid = snapshot.key
                            
                            //simplecounterpop = simplecounterpop + 1;
                            //if(simplecounterpop == 1){
                              //     self.bottompop = postid
                                print("bottomPop")
                                print(postid )
                              // }
                      //  print(postid)
                       // if let dict = snapshot.value as? [String: Any]{
                            let captionText = dict["caption"] as! String
                            //let captionText = "Caption"
                            let photoURLString = dict["imageUrl"] as! String
                             //backgroundTableCellSize = 400
                            let USERNAME = dict["usersName"] as! String
                            let locationText = dict["location"] as! String
                            let likes = dict["numberoflikes"] as! Int
                            let postcount = dict["charactercount"] as! Int
                            let global = dict["Global"] as! Bool
                           // print(global)
                             let postorevent = dict["postorevent"] as! String
                            let spaces =  dict["numberofspaces"] as! Int
                           // print(postorevent)
                            var likedbyme = false ;
                             var likerarray = [User2] ()
                           
                             let sizer = Int(popposts.count)
                            
                            
                            var likersstring = "";
                        
                         
                            let postnumber = postid
                           let postTime = dict["creationDate"] as! TimeInterval
                           // let Audio64 = dict["Audio64"] as! String
                             let Audio64 = dict["Audio64"] as! String
                          //  print(Audio64)
                            //405
                            let timeendstring =  dict["EndDateString"] as! String
                            let timestartstring = dict["StartTimeString"] as! String
                           
                             let numberofcomments = dict["numberofcomments"] as! Int
                            let post = Post(captionText: captionText
                                , photoURLString: photoURLString, USERNAME: USERNAME, locationText: locationText, likes: likes, likedbyme: likedbyme, postid: postid, postcount: postcount, Audio64: Audio64, postTime: postTime,likerArray: likerarray, likersString: likersstring,numberOfComments: numberofcomments, Global: global, postOrEvent: postorevent , timestartstring: timestartstring, timeendstring: timeendstring, displayname: "", profimg: "", score: 0 ,spaces: spaces)
                            // posts.append(post)
                            if(global==false){
                                if friendsList.contains(USERNAME) {
                                     popposts.insert(post, at: 0 )
                                    self.loadpostscounterpop+=1;
                                    completion(postid, USERNAME)
                                    //self.loadPosterInfopop(Message: USERNAME, postid: postid)
                                }
                                else if(USERNAME == id){
                                    popposts.insert(post, at: 0 )
                                     self.loadpostscounterpop+=1;
                                    completion(postid, USERNAME)
                                    //self.loadPosterInfopop(Message: USERNAME, postid: postid)
                                    
                                }
                                
                            }
                            else if(global==true){
                            popposts.insert(post, at: 0 )
                                 self.loadpostscounterpop+=1;
                            completion(postid, USERNAME)
                                //self.loadPosterInfopop(Message: USERNAME, postid: postid)
                            }
                            DispatchQueue.main.async(execute: {
                        // self.tableView.reloadData()
                                postRef2.removeAllObservers()
                                

                                if(simplecounterpop == 10 && loadpostsdonepop == true ){
                                    loadpostsdonepop = false
                                    self.boolarray2.append(false)

//                                    self.loadPostspop2(iteration: 0, completion: { message,message2 in
//                                                                               self.loadPosterInfopop(Message: message2, postid: message)
//                                                                                self.loadLikerspop(Message: message)
//                                                                                self.loadLikespop(Message: message)
//                                                                                self.loadcommentspop(Message: message)
//                                                     })



                               }
                            })
                    
                        }
                        
                    }
           // }
        })
        
                }//end of load posts
    
    
    func loadPostspop2(iteration : Int, completion: @escaping (_ message: String,_ message2: String) -> Void){
   // popposts.removeAll()
        print("poppost")
       var lengthcount =  popposts.count
       ;
        var counter = 0;
     
       var bottompoptemp = ""
       var last_post = bottompop!
        print("this is bottompop1")
        print(bottompop)
        print(iterationpop)
        let postRef = Database.database().reference().child("posts").queryOrdered(byChild: "numberoflikes").queryEnding(atValue: bottompop).queryLimited(toFirst: 10)
        
            postRef.observe( .childAdded) {( snapshot: DataSnapshot) in
                 //print("HERE")
         print("adding popular posts2!")
                  let postid = snapshot.key
               //  print(postid)
             counter = counter + 1;
                if(counter == 1){
                     var bottompoptemp = postid
                self.bottompop = postid
                    print(self.bottompop)
                             print("this is bottompop")
                    
                           }
               // print("postidfromsecond")
               
                 if let dict = snapshot.value as? [String: Any]{
                     let captionText = dict["caption"] as! String
                    print("postidfromsecond")
                    print(captionText)
                     //let captionText = "Caption"
                     let photoURLString = dict["imageUrl"] as! String
                      //backgroundTableCellSize = 400
                     let USERNAME = dict["usersName"] as! String
                     let locationText = dict["location"] as! String
                     let likes = dict["numberoflikes"] as! Int
                     let postcount = dict["charactercount"] as! Int
                     let global = dict["Global"] as! Bool
                    // print(global)
                      let postorevent = dict["postorevent"] as! String
                     let spaces =  dict["numberofspaces"] as! Int
                    // print(postorevent)
                     var likedbyme = false ;
                      var likerarray = [User2] ()
                    
                      let sizer = Int(popposts.count)
                     
                     
                     var likersstring = "";
                 
                  
                     let postnumber = postid
                    let postTime = dict["creationDate"] as! TimeInterval
                    // let Audio64 = dict["Audio64"] as! String
                      let Audio64 = dict["Audio64"] as! String
                   //  print(Audio64)
                     //405
                     let timeendstring =  dict["EndDateString"] as! String
                     let timestartstring = dict["StartTimeString"] as! String
                    
                      let numberofcomments = dict["numberofcomments"] as! Int
                     let post = Post(captionText: captionText
                         , photoURLString: photoURLString, USERNAME: USERNAME, locationText: locationText, likes: likes, likedbyme: likedbyme, postid: postid, postcount: postcount, Audio64: Audio64, postTime: postTime,likerArray: likerarray, likersString: likersstring,numberOfComments: numberofcomments, Global: global, postOrEvent: postorevent , timestartstring: timestartstring, timeendstring: timeendstring, displayname: "", profimg: "", score: 0 ,spaces: spaces)
                     // posts.append(post)
//                   if(counter == 1 && last_post == postid){
//                    self.doneloadposts2 = true
//
//                    }
//                    if(last_post == postid){
//
//                        counter = 5
//                    }
                    
                    if(last_post != postid && counter <= 10 && self.loadpostscounterpop < 10){
                       if let foo = popposts.first(where: { $0.postID == postid}){
                                 //do nothing if already added
                                      }
                        
                       else{
                     if(global==false){
                         if friendsList.contains(USERNAME) {
                              popposts.insert(post, at: lengthcount )
                             self.loadpostscounterpop+=1;
                             completion(postid, USERNAME)
                             //self.loadPosterInfopop(Message: USERNAME, postid: postid)
                         }
                         else if(USERNAME == id){
                             popposts.insert(post, at: lengthcount )
                               self.loadpostscounterpop+=1;
                             completion(postid, USERNAME)
                             //self.loadPosterInfopop(Message: USERNAME, postid: postid)
                             
                         }
                         
                     }
                     else if(global==true){
                     popposts.insert(post, at: lengthcount )
                           self.loadpostscounterpop+=1;
                     completion(postid, USERNAME)
                         //self.loadPosterInfopop(Message: USERNAME, postid: postid)
                     }
                }
                    }
                     DispatchQueue.main.async(execute: {
                 // self.tableView.reloadData()
                       
                        
                        
                        if( counter >= 10 && self.loadpostscounterpop < 10 && self.boolarray2[self.iterationpop] == false){
                            print("calling next one")
                            //self.bottom = posts[posts.count-1].postID
                            self.boolarray2[self.iterationpop] = true
                            //postRef.removeAllObservers()
                            self.boolarray2.append(false);
                            //self.bottompop = bottompoptemp
                            print("This better not get called twice")
                            self.iterationpop =  self.iterationpop + 1
                            self.loadPostspop2( iteration: self.iterationpop ,
                                                
                                                completion: { message,message2 in
                                              self.loadPosterInfopop(Message: message2, postid: message)
                                                       self.loadLikerspop(Message: message)
                                                       self.loadLikespop(Message: message)
                                                       self.loadcommentspop(Message: message)
                            })

                            
                            
                        }
                        
                        
                        
                     })
            //  postRef.removeAllObservers()
                 }
                 
             }
            
     

         }//end of load posts
                 
    var loadpostscounterevent = 0;
    var bottomevent = ""
    var loadpostsdoneevent = true
    var boolarrayevent = [Bool]()
    var iterationevent = 0
                
    func loadPostsEvents(completion: @escaping (_ message: String,_ message2: String) -> Void){
                    self.events.removeAll()
        loadpostscounterevent = 0;
         iterationevent = 0
               var simplecounter = 0;
                    var firstpost = true
                    if(firstpost == true){
                         var likerarray2 = [User2] ()
                        let date = Date()
                        let  dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMM d, YYYY"
                        currentDay =  dateFormatter.string(from: date)
                        let post = Post(captionText: ""
                            , photoURLString: "", USERNAME: "", locationText: "", likes: 0, likedbyme: true, postid: "", postcount: 0, Audio64: "", postTime: 0,likerArray: likerarray2, likersString: "", numberOfComments: 0, Global: true, postOrEvent: "date" , timestartstring: currentDay!, timeendstring: "", displayname: "", profimg: "", score: 0 ,spaces: 0)
                         self.events.append(post)
                    }
                    Database.database().reference().child("events").queryLimited(toFirst: 5).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
                     
                    
                      // print(postid)
                      
                      for rest in snapshot.children.allObjects as! [DataSnapshot] {
                         
                            let postid = rest.key
                        simplecounter = simplecounter + 1;
                        
                            self.bottomevent = postid
                        
                      
                      if let dict = rest.value as? [String: Any] {

                      
                            //Database.database().reference().child("events").child(postid).observe(.childAdded) {(snapshot: DataSnapshot) in
                         //
                        
                             //print("HERE")
                             // let postid = snapshot.key
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
                                // print(global)
                                  let postorevent = dict["postorevent"] as! String
                                 let spaces =  dict["numberofspaces"] as! Int
                                let datenotime = dict["datestringnotime"] as! String
                                // print(postorevent)
                                 var likedbyme = false ;
                                  var likerarray = [User2] ()
                                
                                  let sizer = Int(popposts.count)
                                 
                                 
                                 var likersstring = "";
                             
                              //let postid2 = dict["postid"] as! String

                                 let postnumber = postid
                                let postTime = dict["creationDate"] as! TimeInterval
                                // let Audio64 = dict["Audio64"] as! String
                                  let Audio64 = dict["Audio64"] as! String
                                let postid = dict["postid"] as! String
                               //  print(Audio64)
                                 //405
                                 let timeendstring =  dict["EndDateString"] as! String
                                 let timestartstring = dict["StartTimeString"] as! String
                                 let numberofcomments = dict["numberofcomments"] as! Int
                                if(datenotime != self.currentDay){
                                    self.currentDay = datenotime
                                    let post2 = Post(captionText: ""
                                        , photoURLString: "", USERNAME: "", locationText: "", likes: 0, likedbyme: true, postid: "", postcount: 0, Audio64: "", postTime: 0,likerArray: likerarray, likersString: "", numberOfComments: 0, Global: true, postOrEvent: "date" , timestartstring: self.currentDay!, timeendstring: "", displayname: "", profimg: "", score: 0 ,spaces: 0)
                                     self.events.append(post2)
                                    
                                }
                                 
                                 let post = Post(captionText: captionText
                                     , photoURLString: photoURLString, USERNAME: USERNAME, locationText: locationText, likes: likes, likedbyme: likedbyme, postid: postid, postcount: postcount, Audio64: Audio64, postTime: postTime,likerArray: likerarray, likersString: likersstring,numberOfComments: numberofcomments, Global: global, postOrEvent: postorevent , timestartstring: timestartstring, timeendstring: timeendstring, displayname: "", profimg: "", score: 0 ,spaces: spaces)
                                 // posts.append(post)
                                if let foo = self.events.first(where: { $0.postID == postid}){
                                          //do nothing if already added
                                               }
                                 
                                else{
                                
                                 if(global==false){
                                     if friendsList.contains(USERNAME) {
                                        self.events.append(post)
                                        self.loadpostscounterevent+=1;
                                          completion(postid, USERNAME)
                                        
                                     }
                                     else if(USERNAME == id){
                                        self.events.append(post)
                                        self.loadpostscounterevent+=1;
                                         completion(postid, USERNAME)
                                         
                                     }
                                     
                                 }
                                 else if(global==true){
                                    self.events.append(post)
                                        self.loadpostscounterevent+=1;
                                        completion(postid, USERNAME)                                 }
                                }
                                 DispatchQueue.main.async(execute: {
                                    
                                    
                                    
                                    
                                    
                                    if(simplecounter == 5 && self.loadpostsdoneevent == true ){
                                        print("getting mroe events")
                                        self.loadpostsdoneevent = false
                                        
                                        self.boolarrayevent.append(false);
                                                               self.loadPostsEvents2(iteration: 0,completion: { message,message2 in
                                                                                         self.loadPosterInfoEvent(Message: message2, postid: message)
                                                                                          self.loadLikersEvents(Message: message)
                                                                                          self.loadLikesEvents(Message: message)
                                                                                          self.loadcommentsEvents(Message: postid)
                                                               })


                                        
                                        
                                        
                                    
                                        }
                                        
                             // self.tableView.reloadData()
                                 })
                         
                             }
                             
                         }
                        }
                    })

                     }//end of load posts
    
    
    
    
    
    func loadPostsEvents2(iteration: Int, completion: @escaping (_ message: String,_ message2: String) -> Void){
        print("adding more events")
                      var lengthcount = events.count;
                             print(lengthcount)
                             print("bottom:")
        var last_post = bottomevent
                             print(last_post)
                             var simplecounter = 0
               
                     print(bottomevent)
        Database.database().reference().child("events").queryOrderedByKey().queryStarting(atValue: bottomevent).queryLimited(toFirst: 5).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
         
        
          // print(postid)
          
          for rest in snapshot.children.allObjects as! [DataSnapshot] {
             
                let postid = rest.key
          simplecounter = simplecounter + 1;
            //if(simplecounterpop == 1){
                   self.bottomevent = postid
          if let dict = rest.value as? [String: Any] {
            
            
                         
                              //Database.database().reference().child("events").child(postid).observe(.childAdded) {(snapshot: DataSnapshot) in
                           //
                        
                         // if(simplecounter == 1){
                             
                          
                               //print("HERE")
                               // let postid = snapshot.key
                             //  print(postid)
                              
                                   let captionText = dict["caption"] as! String
                                   //let captionText = "Caption"
                                print("caption")
                                print(captionText)
                                   let photoURLString = dict["imageUrl"] as! String
                                    //backgroundTableCellSize = 400
                                   let USERNAME = dict["usersName"] as! String
                                   let locationText = dict["location"] as! String
                                   let likes = dict["numberoflikes"] as! Int
                                   let postcount = dict["charactercount"] as! Int
                                   let global = dict["Global"] as! Bool
                                  // print(global)
                                    let postorevent = dict["postorevent"] as! String
                                   let spaces =  dict["numberofspaces"] as! Int
                                  let datenotime = dict["datestringnotime"] as! String
                                  // print(postorevent)
                                   var likedbyme = false ;
                                    var likerarray = [User2] ()
                                  
                                    let sizer = Int(popposts.count)
                                   
                                   
                                   var likersstring = "";
                               
                                
                                   let postnumber = postid
                                  let postTime = dict["creationDate"] as! TimeInterval
                                  // let Audio64 = dict["Audio64"] as! String
                                    let Audio64 = dict["Audio64"] as! String
                                  let postid = dict["postid"] as! String
                                 //  print(Audio64)
                                   //405
                                   let timeendstring =  dict["EndDateString"] as! String
                                   let timestartstring = dict["StartTimeString"] as! String
                                   let numberofcomments = dict["numberofcomments"] as! Int
                                if let foo = self.events.first(where: { $0.postID == postid}){
                                                                           //do nothing if already added
                                                                                }

                                                                 else{
                                  if(datenotime != self.currentDay){
                                      self.currentDay = datenotime
                                    print( )
                                      let post2 = Post(captionText: ""
                                          , photoURLString: "", USERNAME: "", locationText: "", likes: 0, likedbyme: true, postid: "", postcount: 0, Audio64: "", postTime: 0,likerArray: likerarray, likersString: "", numberOfComments: 0, Global: true, postOrEvent: "date" , timestartstring: self.currentDay!, timeendstring: "", displayname: "", profimg: "", score: 0 ,spaces: 0)
                                       self.events.append(post2)
                                      
                                  }
                                }
                                   
                                   let post = Post(captionText: captionText
                                       , photoURLString: photoURLString, USERNAME: USERNAME, locationText: locationText, likes: likes, likedbyme: likedbyme, postid: postid, postcount: postcount, Audio64: Audio64, postTime: postTime,likerArray: likerarray, likersString: likersstring,numberOfComments: numberofcomments, Global: global, postOrEvent: postorevent , timestartstring: timestartstring, timeendstring: timeendstring, displayname: "", profimg: "", score: 0 ,spaces: spaces)
                                   // posts.append(post)
                                if(last_post != postid){
                                  if let foo = self.events.first(where: { $0.postID == postid}){
                                            //do nothing if already added
                                                 }

                                  else{
                                  
                                   if(global==false){
                                       if friendsList.contains(USERNAME) {
                                          self.events.append(post)
                                          self.loadpostscounterevent+=1;
                                            completion(postid, USERNAME)
                                          
                                       }
                                       else if(USERNAME == id){
                                          self.events.append(post)
                                          self.loadpostscounterevent+=1;
                                           completion(postid, USERNAME)
                                           
                                       }
                                       
                                   }
                                   else if(global==true){
                                      self.events.append(post)
                                          self.loadpostscounterevent+=1;
                                          completion(postid, USERNAME)                                 }
                                  //}
                                }
                                   DispatchQueue.main.async(execute: {
                                    self.eventTable.reloadData()
                                      
                                      
                                      
                                      
                                    if(simplecounter == 5 && self.loadpostscounterevent < 5 && self.boolarrayevent[self.iterationevent] == false) {
                                          print("getting mroe events")
                                        self.boolarrayevent[self.iterationevent] = true
                                        self.loadpostsdoneevent = false
                                          
                                          self.boolarrayevent.append(false);
                                             
                                        self.iterationevent = self.iterationevent + 1;
                                        self.loadPostsEvents2(iteration: self.iterationevent,completion: { message,message2 in
                                                                                           self.loadPosterInfoEvent(Message: message2, postid: message)
                                                                                            self.loadLikersEvents(Message: message)
                                                                                            self.loadLikesEvents(Message: message)
                                                                                           // self.loadcommentsEvents(Message: message)
                                                                 })


                                          
                                          
                                          
                                      
                                          }
                                          
                               // self.tableView.reloadData()
                                   })
                           
                               }
                               
                           }
                          
                      }
            
        })

                       }//end of load posts
                       
                     
    
    
    func loadLikes(Message: String){
          //  print("loadlikes")
      //  print(Message)
       // print("loadlikes")
        
      var likedbyme = false
//        for i in 0...posts.count-1 {
//         var postid =  posts[i].postID
        var postid =  Message; Database.database().reference().child("posts").child(postid).child("likers").child(self.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any]{
                //print("in closure")
                likedbyme = true
                if let foo = posts.first(where: { $0.postID == Message}){
               foo.likedby =  true
                }
                else {
                    
                }
                //                    print(likedbyme)
                DispatchQueue.main.async(execute: {
                    //self.tableView.reloadData()
                  //  completion("loadlikes")
                })

            }
        })


    
}
    func loadLikesfriends(Message: String){
        //  print("loadlikes")
        //  print(Message)
        // print("loadlikes")
        
        var likedbyme = false
        //        for i in 0...posts.count-1 {
        //         var postid =  posts[i].postID
        var postid =  Message; Database.database().reference().child("posts").child(postid).child("likers").child(self.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any]{
                //print("in closure")
                likedbyme = true
                if let foo = friendsposts.first(where: { $0.postID == Message}){
                    foo.likedby =  true
                }
                else {
                    
                }
                //                    print(likedbyme)
                DispatchQueue.main.async(execute: {
                    //self.tableView.reloadData()
                    //  completion("loadlikes")
                })
                
            }
        })
        
        
        
    }
    
    
    
    func loadLikespop(Message: String){
        //  print("loadlikes")
        //  print(Message)
        // print("loadlikes")
        
        var likedbyme = false
        //        for i in 0...posts.count-1 {
        //         var postid =  posts[i].postID
        var postid =  Message; Database.database().reference().child("posts").child(postid).child("likers").child(self.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any]{
                //print("in closure")
                likedbyme = true
                if let foo = popposts.first(where: { $0.postID == Message}){
                    foo.likedby =  true
                }
                else {
                    
                }
                //                    print(likedbyme)
                DispatchQueue.main.async(execute: {
                    //self.tableView.reloadData()
                    //  completion("loadlikes")
                })
                
            }
        })
        
        
        
    }
    
    func loadLikesEvents(Message: String){
        //  print("loadlikes")
        //  print(Message)
        // print("loadlikes")
        
        var likedbyme = false
        //        for i in 0...posts.count-1 {
        //         var postid =  posts[i].postID
        var postid =  Message; Database.database().reference().child("posts").child(postid).child("likers").child(self.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any]{
                //print("in closure")
                likedbyme = true
                if let foo = self.events.first(where: { $0.postID == Message}){
                    foo.likedby =  true
                }
                else {
                    
                }
                //                    print(likedbyme)
                DispatchQueue.main.async(execute: {
                    self.eventTable.reloadData()
                    //  completion("loadlikes")
                })
                
            }
        })
        
        
        
    }
    
    
}

extension HomeViewController: UITableViewDataSource, UITextViewDelegate {
   
    
    
     func tableView(  _ tableView: UITableView, heightForRowAt indexPath: IndexPath)->CGFloat{
       
        
        if(tableView == popView){
         if(popposts[indexPath.row].postorevent == "post"){
                  
                      let imageyesorno = popposts[indexPath.row].imageUrl
          //            var realcount = popposts[indexPath.row].postCount
          //            // %42
          //            var spaces = popposts[indexPath.row].Spaces/2
          //             let spaces2 = popposts[indexPath.row].Spaces%2
          //            if(spaces2 == 1){
          //                spaces = spaces + 1;
          //            }
          //            realcount = realcount - spaces
                      var numberoflines = popposts[indexPath.row].Spaces
                      print("Posttext height")
                     
                  //let audioyesorno =f popposts[indexPath.row].audio64
                  let audioyesorno = "noaudio"
                  var height = numberoflines * 22
                  
                  if(audioyesorno != "noaudio"){
                      height = height + 80
                  }

                  if(imageyesorno == "noImage") {
                      
                     
                      return (CGFloat(120 + height))//80
                  }
                      
                      if(imageyesorno != "noImage") {
                                 
                                
                                 return (CGFloat(430 + height))//80
                             }
                    //return (CGFloat(380 + height))
                  return (CGFloat(420 + height))
                      
                  }
                  
                   else if (popposts[indexPath.row].postorevent == "event"){
                      let imageyesorno = popposts[indexPath.row].imageUrl
                     
                      let numberoflines =  popposts[indexPath.row].Spaces// %42
                      //let audioyesorno =f popposts[indexPath.row].audio64
                      let audioyesorno = "noaudio"
                      var height = numberoflines * 22
                      
                      if(audioyesorno != "noaudio"){
                          height = height + 80
                      }

                      if(imageyesorno == "noImage") {
                          
                         
                          return (CGFloat(160 + height))//80
                      }
                      if(imageyesorno != "noImage") {
                                     
                                    
                                     return (CGFloat(460 + height))//80
                                 }
                                
                     
                      }
        }
        
        
        if(tableView == friendView){
            
            
            
            
            if(friendsposts[indexPath.row].postorevent == "post"){
                let imageyesorno = friendsposts[indexPath.row].imageUrl
                let numberoflines = ((friendsposts[indexPath.row].postCount)/42)+1 // %42
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
                
            else if (friendsposts[indexPath.row].postorevent == "event"){
               let imageyesorno = friendsposts[indexPath.row].imageUrl
                   
                    let numberoflines =  friendsposts[indexPath.row].Spaces// %42
                    //let audioyesorno =f posts[indexPath.row].audio64
                    let audioyesorno = "noaudio"
                    var height = numberoflines * 22
                    
                    if(audioyesorno != "noaudio"){
                        height = height + 80
                    }

                    if(imageyesorno == "noImage") {
                        
                       
                        return (CGFloat(160 + height))//80
                    }
                    if(imageyesorno != "noImage") {
                                   
                                  
                                   return (CGFloat(460 + height))//80
                               }
            }
            
        }
        
        if(tableView == eventTable){
            if( self.events[indexPath.row].postorevent == "date"){
                return 75
            }
            let imageyesorno = self.events[indexPath.row].imageUrl
    
            let numberoflines =  self.events[indexPath.row].Spaces// %42
     //let audioyesorno =f posts[indexPath.row].audio64
     let audioyesorno = "noaudio"
     var height = numberoflines * 22
     
     if(audioyesorno != "noaudio"){
         height = height + 80
     }

     if(imageyesorno == "noImage") {
         
        
         return (CGFloat(160 + height))//80
     }
     if(imageyesorno != "noImage") {
                    
                   
                    return (CGFloat(460 + height))//80
                }
               
            return 180;
     }

      
       
        else {
         if(posts[indexPath.row].postorevent == "post"){
        
            let imageyesorno = posts[indexPath.row].imageUrl
//            var realcount = posts[indexPath.row].postCount
//            // %42
//            var spaces = posts[indexPath.row].Spaces/2
//             let spaces2 = posts[indexPath.row].Spaces%2
//            if(spaces2 == 1){
//                spaces = spaces + 1;
//            }
//            realcount = realcount - spaces
            var numberoflines = posts[indexPath.row].Spaces
            print("Posttext height")
           
        //let audioyesorno =f posts[indexPath.row].audio64
        let audioyesorno = "noaudio"
        var height = numberoflines * 22
        
        if(audioyesorno != "noaudio"){
            height = height + 80
        }

        if(imageyesorno == "noImage") {
            
           
            return (CGFloat(120 + height))//80
        }
            
            if(imageyesorno != "noImage") {
                       
                      
                       return (CGFloat(430 + height))//80
                   }
          //return (CGFloat(380 + height))
        return (CGFloat(420 + height))
            
        }
        
         else if (posts[indexPath.row].postorevent == "event"){
            let imageyesorno = posts[indexPath.row].imageUrl
           
            let numberoflines =  posts[indexPath.row].Spaces// %42
            //let audioyesorno =f posts[indexPath.row].audio64
            let audioyesorno = "noaudio"
            var height = numberoflines * 22
            
            if(audioyesorno != "noaudio"){
                height = height + 80
            }

            if(imageyesorno == "noImage") {
                
               
                return (CGFloat(160 + height))//80
            }
            if(imageyesorno != "noImage") {
                           
                          
                           return (CGFloat(460 + height))//80
                       }
                      
           
            }
        }
        return 180
    }
    
    func tableView( _ tableView:UITableView, numberOfRowsInSection section: Int)-> Int {
        if(tableView == eventTable){
            return events.count
        }
        
    if(tableView == popView){
     //   print("FRIENDS POST SIZE");
       // print(friendsposts.count);
        return popposts.count
    }
        
        if(tableView == friendView){
            print("FRIENDS POST SIZE");
            print(friendsposts.count);
            return friendsposts.count
        }
            
            
        else {
            print(posts.count)
            print(posts.count)
           return posts.count
        }
        print("count")
        print(posts.count)
        return posts.count
        
        
    }//how many cells
//    func tableView(_ tableView: UITableView,
//                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
//    {
//        if(posts[indexPath.row].usersName == uid ){
//        let modifyAction = UIContextualAction(style: .normal, title:  "Update", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
//            print("Update action ...")
//            success(true)
//        })
//        modifyAction.image = UIImage(named: "unknown")
//        modifyAction.backgroundColor = .blue
//        
//        return UISwipeActionsConfiguration(actions: [modifyAction])
//        }
//        let modifyAction = UIContextualAction(style: .normal, title:  "Update", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
//            print("Update action ...")
//            success(true)
//        })
//        modifyAction.image = UIImage(named: "unknown")
//        modifyAction.backgroundColor = .blue
//        
//        return UISwipeActionsConfiguration(actions: [modifyAction])
//    }

    
    
    
    func tableView(  _ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell{
        
        
        if(tableView==popView){
        let cell = tableView.dequeueReusableCell(withIdentifier: "popCell", for: indexPath) as! newsCell;
             cell.postImage2.isHidden = true
                                cell.selectionStyle = .none;
                            cell.cellID = popposts[indexPath.row].postID
                            cell.userid = popposts[indexPath.row].usersName;
                           
                               
                                cell.replypostText.isHidden = true
                            cell.globalButton2.isHidden = true
                                cell.threedots2.isHidden = true
                            
                             let toId = popposts[indexPath.row].usersName
                                cell.globalButton.isHidden = false
                             let isGlobal = popposts[indexPath.row].global
                                if(isGlobal==true){
                                    cell.globalButton.setImage(UIImage(named:"earth"), for: .normal)
                                }
                                else if(isGlobal==false){
                                    cell.globalButton.setImage(UIImage(named:"lock"), for: .normal)
                                    
                                }
                             cell.CommentStamp.text = String(popposts[indexPath.row].numberofcomments)
                              
                             self.loadLikers2pop( Message: popposts[indexPath.row].postID, completion: { message in
                              
                             // print("in here")
                             cell.likeLabel.text = String(popposts[indexPath.row].numberoflikes);
                              cell.likerstring.text = popposts[indexPath.row].likersstring
                                })
                        
                            if(popposts[indexPath.row].likedby == true){
                                let heartFilled = UIImage(named: "heartfilled")
                                cell.likeButton.setImage(heartFilled, for: .normal)
                            }//close if
                            if(popposts[indexPath.row].likedby == false){
                                let heartEmpty = UIImage(named: "heartempty")
                                cell.likeButton.setImage(heartEmpty, for: .normal)
                            }//close if
                            
                          if(popposts[indexPath.row].postorevent == "post"){
                        //    print(popposts[indexPath.row].postorevent )
                            cell.postText.font = .systemFont(ofSize: 15)
                            cell.postText.text = popposts[indexPath.row].caption
                          cell.descriptionButt.isHidden = true
                            
                    cell.likeLabel.text = String(popposts[indexPath.row].numberoflikes)
                            //print(indexPath.row)
                            let backgroundView = UIView()
                            backgroundView.backgroundColor = UIColor.white
                            cell.selectedBackgroundView = backgroundView
                           
                          
                           
                            
                             cell.timeStamp.isHidden =  false
                            cell.DateStamp.isHidden =  true
                            cell.DateStamp2.isHidden = true
                          cell.threedots.isHidden =  false
                            cell.postImage.isHidden = false
                           // cell.threedots2.isHidden = true
                            var timeStampString: String = findStringOfTime(newDate: Int(popposts[indexPath.row].posttime))
                           
                            
                                    cell.timeStamp.text = timeStampString
                            
                                
                            
                            
                           // print(popposts[indexPath.row].postID)
                      //cell.CommentStamp.text = popposts[indexPath.row].
                            
                            
                            
                           
                            if( popposts[indexPath.row].likedby == true){
                              
                                let heartFilled = UIImage(named: "heartfilled")
                                cell.likeButton.setImage(heartFilled, for: .normal)
                            }//close if
                        
                            
                      
                                
                                //cell.nameButton.setTitle(username, for: .normal)
                              // cell.cellID = toId 8/12/2019
                                //cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: profileimageURL)
                                cell.nameButton.setTitle(popposts[indexPath.row].displayName, for: .normal)
                                // cell.cellID = toId
                                cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: popposts[indexPath.row].profImg)
                                if(addedPicture == true ){
                                cell.profileImageViewTop.image = profilePhotoEdit!
                                }
                              let numberoflines = popposts[indexPath.row].Spaces // %42
                                
                               let height = numberoflines * 22
                            

                                
                                //cell.postText.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
                                
                                cell.postText.frame.size.height = CGFloat(height) //https://stackoverflow.com/questions/38391528/how-to-set-dynamic-label-size-in-uitableviewcell
                                cell.postText.text = popposts[indexPath.row].caption
                                var local2    = (popposts[indexPath.row].location)
                                 local2 = "@\(local2)"
                                cell.locationButton.setTitle(local2, for: .normal)
                               
                                
                               //cell.songid =  popposts[indexPath.row].audio64;
                               
                                
                                
                                //cell.likeLabel.text = String( popposts[indexPath.row].numberoflikes)
                                let url = popposts[indexPath.row].imageUrl
                                cell.postImage.loadImageUsingCacheWithUrlString(urlString: url)
                                //cell.likeLabel.text = String(popposts[indexPath.row].numberoflikes)
                                cell.delegate = self //ADDED
                                
                    //            DispatchQueue.main.async(execute: {
                    //                                                                    self.tableView.reloadData()
                    //                                                                })
                                
                                
                              
                                
                                
                                
                                
                                
                                cell.commentAct = { sender in
                                    
                                    let vc = commeListController()
                                    vc.postId = popposts[indexPath.row].postID
                                    vc.posterid = popposts[indexPath.row].usersName
                                
                                    self.navigationController?.pushViewController(vc, animated: true)

                                }//close comment act

                                
                           
                            
                            }
                             if(popposts[indexPath.row].postorevent == "event"){
                                 cell.postImage2.isHidden = false //cell.nameButton.setTitle(popposts[indexPath.row].posterUsername, for: .normal)
                                cell.timeStamp.isHidden =  true
                                cell.DateStamp.isHidden =  false
                                cell.DateStamp2.isHidden = false
                                cell.threedots.isHidden = true
                               cell.commentAct = { sender in
                                                                 
                                                                 let vc = commeListController()
                                                      vc.postId = popposts[indexPath.row].postID
                                                      vc.posterid = popposts[indexPath.row].usersName
                                                             
                                                                 self.navigationController?.pushViewController(vc, animated: true)

                                                             }//close comment act
                                cell.globalButton.isHidden = true
                                cell.globalButton2.isHidden =  false
                                let isGlobal = popposts[indexPath.row].global
                                if(isGlobal==true){
                                    cell.globalButton2.setImage(UIImage(named:"earth"), for: .normal)
                                }
                                else if(isGlobal==false){
                                    cell.globalButton2.setImage(UIImage(named:"lock"), for: .normal)
                                    
                                }
                                
                                
                                cell.DateStamp.text = (popposts[indexPath.row].timeStartString)
                                cell.DateStamp2.text = (popposts[indexPath.row].timeEndString)
                                cell.threedots2.isHidden =  false
                                //cell.threedots2.setImage(UIImage(named:"earth"), for: .normal)
                                cell.locationButton.setTitle("@\(popposts[indexPath.row].location)", for: .normal)
                                cell.postText.font = .boldSystemFont(ofSize: 20)
                                cell.postText.text = popposts[indexPath.row].caption
                                cell.postText.frame.size.height = CGFloat(22)
                             
                                cell.descriptionButt.isHidden = false;
                                let numberoflines = popposts[indexPath.row].Spaces
                                
                                let height = numberoflines * 22
                                
                                
                                
                                

                                cell.descriptionButt.frame.size.height = CGFloat(height);
                                cell.descriptionButt.text=popposts[indexPath.row].audio64;
                               
                                cell.likeLabel.text = String(popposts[indexPath.row].numberoflikes)
                                cell.postImage2.loadImageUsingCacheWithUrlString(urlString: (popposts[indexPath.row].imageUrl))
                    //            let ref = Database.database().reference().child("users").child(toId)
                    //            Database.database().reference().child("users").child(toId).observeSingleEvent(of: .value, with: { (snapshot) in
                    //                //print(snapshot.value ?? "")
                    //
                    //                let dictionary = snapshot.value as? [String: Any]
                    //                let username = dictionary?[ "username"] as? String
                    //
                    //                guard let profileimageURL = dictionary?[ "ProfileImage"] as? String else {return}
                                
                                    
                                    cell.nameButton.setTitle(popposts[indexPath.row].displayName, for: .normal)
                                    // cell.cellID = toId
                                    cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: popposts[indexPath.row].profImg)
                                    
                                  
                                      cell.timeStamp.isHidden =  true
                                    cell.postImage.isHidden = true

                                    
                               // })
                                
                           }
                                
                                
                                cell.replyAct = { sender in
                                       print("in here now")
                                if(cell.nameButton.titleLabel?.text == myUsername){
                                       self.presentAlertWithTitle(title: "Would you like to delete your post?", message: "This action cannot be undone", options: "Yes", "No") { (option) in
                                                          print("option: \(option)")
                                                          switch(option) {
                                                          case 0:
                                                              print("option one")
                                                              
                                                              Database.database().reference().child("posts").child(cell.cellID).removeValue { (error, ref) in
                                                              if error != nil {
                                                                  print("error \(error)")
                                                              }
                                                              }
                                                              
                                                              Database.database().reference().child("comments").child(cell.cellID).removeValue { (error, ref) in
                                                                    if error != nil {
                                                                        print("error \(error)")
                                                                    }
                                                              
                                                              }
                                                              break
                                                          //  return
                                                          case 1:
                                                              print("option two")
                                                              break
                                                          //return
                                                          default:
                                                              print("option two")
                                                              break
                                                          }
                                                      }
                                }
                                
                                else{
                                                      self.presentAlertWithTitle(title: "Would you like to report this post?", message: "If you would like WRUD to know the reason behind this report email us directly.", options: "Yes", "No") { (option) in
                                                                         print("option: \(option)")
                                                                         switch(option) {
                                                                         case 0:
                                                                             print("option one")
                                                                             break
                                                                         //  return
                                                                         case 1:
                                                                             print("option two")
                                                                             break
                                                                         //return
                                                                         default:
                                                                             print("option two")
                                                                             break
                                                                         }
                                                                     }
                                               }
                                       
                                
                                
                                   }
                            
                            
                            cell.buttonAct = { sender in
                                var useridpluspostid = ""
                                var name = cell.userid
                                useridpluspostid = "\(self.uid!)\(cell.cellID)";
                                
                                Database.database().reference().child("posts").child(popposts[indexPath.row].postID).observeSingleEvent(of: .value, with: { (snapshot) in
                                 if let dict = snapshot.value as? [String: Any]{
                                 
                                   let likes = dict["numberoflikes"] as! Int
                                
                                DispatchQueue.main.async(execute: {
                                                                
                                                                
                            Database.database().reference().child("posts").child(popposts[indexPath.row].postID).child("likers").child(self.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                                    
                                if snapshot.exists(){
                                    if( popposts[indexPath.row].likedby == false){
                                            
                                         
                                             let noti = ["Notification Type": "Like","ID Number": cell.cellID,"Userid":self.uid! ] as [String : Any]
                                            
                                             let new_date = Int(Date().timeIntervalSince1970 * 100000.0)
                                             Database.database().reference().child("users").child(cell.userid!).child("notifications").child(String(new_date)).child(useridpluspostid).updateChildValues(noti);
                                             popposts[indexPath.row].likedby = true
                                             let heartFilled = UIImage(named: "heartfilled")
                                             cell.likeButton.setImage(heartFilled, for: .normal)
                                             var liked = popposts[indexPath.row].numberoflikes
                                            liked =  likes
                                             //popposts[indexPath.row].numberoflikes = likes
                                             //                 print(liked)
                                             //                    ref.child("numberoflikes").setValue(1)
                                             let newValues = ["likerName":usersShowName!, "likersid": self.uid!] as [String : Any]
                                             Database.database().reference().child("posts").child(popposts[indexPath.row].postID).updateChildValues(["numberoflikes": liked])
                                            // cell.likeLabel.text = String(liked);
                                             //Database.database().reference().child("posts").child(posts[indexPath.row].postID).child("likers").child(self.uid!).updateChildValues(newValues)
                                             
                                              cell.likeLabel.text = String(liked)
                                             //
                                            // print("liked")
                                             self.loadLikers2pop( Message: popposts[indexPath.row].postID, completion: { message in
                                                 
                                                // print("in here")
                                                cell.likeLabel.text = String(popposts[indexPath.row].numberoflikes);
                                                 cell.likerstring.text = popposts[indexPath.row].likersstring
                                                if(popposts[indexPath.row].likedby == true){
                                                    let heartFilled = UIImage(named: "heartfilled")
                                                    cell.likeButton.setImage(heartFilled, for: .normal)
                                                }//close if
                                                if(popposts[indexPath.row].likedby == false){
                                                    let heartEmpty = UIImage(named: "heartempty")
                                                    cell.likeButton.setImage(heartEmpty, for: .normal)
                                                }//close if
                                             })
                                             
                                    }
                                         else if( popposts[indexPath.row].likedby == true){
                                             popposts[indexPath.row].likedby = false
                                             let heartFilled = UIImage(named: "heartempty")
                                             Database.database().reference().child("users").child(popposts[indexPath.row].usersName).child("notifications").observe(.childAdded, with: { (snapshot) in
                                               //  print("true")
                                                 
                                                 let postid2 = snapshot.key
                                                 Database.database().reference().child("users").child(popposts[indexPath.row].usersName).child("notifications").child(postid2).observe(.childAdded, with: {
                                                     (snapshot) in
                                                     
                                                     let postid3 = snapshot.key
                                                     if(postid3 == useridpluspostid){
                                                         Database.database().reference().child("users").child(popposts[indexPath.row].usersName).child("notifications").child(postid2).child(postid3).removeValue()
                                                     }
                                                     DispatchQueue.main.async(execute: {
                                                     
                                                     
                                                     })
                                                 })
                                             })
                                         
                                             
                                             
                                             
                                             
                                             cell.likeButton.setImage(heartFilled, for: .normal)
                                             var liked = popposts[indexPath.row].numberoflikes
                                             liked =  likes-1;
                                             popposts[indexPath.row].numberoflikes = liked
                                             Database.database().reference().child("posts").child(popposts[indexPath.row].postID).updateChildValues(["numberoflikes": liked])
                                             Database.database().reference().child("posts").child(popposts[indexPath.row].postID).child("likers").child(self.uid!).removeValue()
                                             
                                             cell.likeLabel.text = String(liked);
                                            
                                             
                                             self.loadLikers2pop( Message: popposts[indexPath.row].postID, completion: { message in
                                                 print("in here")
                                                 cell.likerstring.text = popposts[indexPath.row].likersstring
                                                 cell.likeLabel.text = String(popposts[indexPath.row].numberoflikes);
                                                if(popposts[indexPath.row].likedby == true){
                                                    let heartFilled = UIImage(named: "heartfilled")
                                                    cell.likeButton.setImage(heartFilled, for: .normal)
                                                }//close if
                                                if(popposts[indexPath.row].likedby == false){
                                                    let heartEmpty = UIImage(named: "heartempty")
                                                    cell.likeButton.setImage(heartEmpty, for: .normal)
                                                }//close if
                                             })
                                             
                                             
                                             
                                             
                                         }
                                    
                                         
                                         
                                  
                                    
                                }else{
                                    if( popposts[indexPath.row].likedby == false){
                                            
                                         
                                             let noti = ["Notification Type": "Like","ID Number": cell.cellID,"Userid":self.uid! ] as [String : Any]
                                            
                                             let new_date = Int(Date().timeIntervalSince1970 * 100000.0)
                                             Database.database().reference().child("users").child(cell.userid!).child("notifications").child(String(new_date)).child(useridpluspostid).updateChildValues(noti);
                                             popposts[indexPath.row].likedby = true
                                             let heartFilled = UIImage(named: "heartfilled")
                                             cell.likeButton.setImage(heartFilled, for: .normal)
                                             var liked = popposts[indexPath.row].numberoflikes
                                             liked =  likes  + 1
                                             popposts[indexPath.row].numberoflikes = liked
                                             //                 print(liked)
                                             //                    ref.child("numberoflikes").setValue(1)
                                             let newValues = ["likerName":usersShowName!, "likersid": self.uid!] as [String : Any]
                                             Database.database().reference().child("posts").child(popposts[indexPath.row].postID).updateChildValues(["numberoflikes": liked])
                                             cell.likeLabel.text = String(liked);
                                             Database.database().reference().child("posts").child(popposts[indexPath.row].postID).child("likers").child(self.uid!).updateChildValues(newValues)
                                             
                                             cell.likeLabel.text = String(liked)
                                             //
                                            // print("liked")
                                             self.loadLikers2pop( Message: popposts[indexPath.row].postID, completion: { message in
                                                 
                                                // print("in here")
                                                cell.likeLabel.text = String(popposts[indexPath.row].numberoflikes);
                                                 cell.likerstring.text = popposts[indexPath.row].likersstring;
                                                if(popposts[indexPath.row].likedby == true){
                                                    let heartFilled = UIImage(named: "heartfilled")
                                                    cell.likeButton.setImage(heartFilled, for: .normal)
                                                }//close if
                                                if(popposts[indexPath.row].likedby == false){
                                                    let heartEmpty = UIImage(named: "heartempty")
                                                    cell.likeButton.setImage(heartEmpty, for: .normal)
                                                }//close if
                                             })
                                             
                                         }
                                         else if( popposts[indexPath.row].likedby == true){
                                             popposts[indexPath.row].likedby = false
                                             let heartFilled = UIImage(named: "heartempty")
                                             Database.database().reference().child("users").child(popposts[indexPath.row].usersName).child("notifications").observe(.childAdded, with: { (snapshot) in
                                               //  print("true")
                                                 
                                                 let postid2 = snapshot.key
                                                 Database.database().reference().child("users").child(popposts[indexPath.row].usersName).child("notifications").child(postid2).observe(.childAdded, with: {
                                                     (snapshot) in
                                                     
                                                     let postid3 = snapshot.key
                                                     if(postid3 == useridpluspostid){
                                                         Database.database().reference().child("users").child(popposts[indexPath.row].usersName).child("notifications").child(postid2).child(postid3).removeValue()
                                                     }
                                                     DispatchQueue.main.async(execute: {
                                                     
                                                     
                                                     })
                                                 })
                                             })
                                         
                                    
                                             
                                             
                                             
                                             cell.likeButton.setImage(heartFilled, for: .normal)
                                             var liked = popposts[indexPath.row].numberoflikes
                                             liked =  likes
                                             popposts[indexPath.row].numberoflikes = liked
                                             Database.database().reference().child("posts").child(popposts[indexPath.row].postID).updateChildValues(["numberoflikes": liked])
                                             Database.database().reference().child("posts").child(popposts[indexPath.row].postID).child("likers").child(self.uid!).removeValue()
                                             
                                             cell.likeLabel.text = String(liked);
                                            
                                             
                                             self.loadLikers2pop( Message: popposts[indexPath.row].postID, completion: { message in
                                                 print("in here")
                                                 cell.likerstring.text = popposts[indexPath.row].likersstring
                                                 cell.likeLabel.text = String(popposts[indexPath.row].numberoflikes);
                                                
                                                
                                             })
                                             
                                             
                                             
                                             
                                         }
                                    
                                
                                         
                                     }//close buttonAct
                                    
                                })
                                               
                                    })
                                        }})
                           
                                
                            }//close buttonAct
                           
                       
                       return cell;
            
        }
        
        if(tableView==friendView){
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! newsCell;
           
      
           cell.postImage2.isHidden = true
                        cell.selectionStyle = .none;
                    cell.cellID = friendsposts[indexPath.row].postID
                    cell.userid = friendsposts[indexPath.row].usersName;
                   
                       
                        cell.replypostText.isHidden = true
                    cell.globalButton2.isHidden = true
                        cell.threedots2.isHidden = true
                    
                     let toId = friendsposts[indexPath.row].usersName
                        cell.globalButton.isHidden = false
                     let isGlobal = friendsposts[indexPath.row].global
                        if(isGlobal==true){
                            cell.globalButton.setImage(UIImage(named:"earth"), for: .normal)
                        }
                        else if(isGlobal==false){
                            cell.globalButton.setImage(UIImage(named:"lock"), for: .normal)
                            
                        }
                     cell.CommentStamp.text = String(friendsposts[indexPath.row].numberofcomments)
                      
                     self.loadLikers2friends( Message: friendsposts[indexPath.row].postID, completion: { message in
                      
                     // print("in here")
                     cell.likeLabel.text = String(friendsposts[indexPath.row].numberoflikes);
                      cell.likerstring.text = friendsposts[indexPath.row].likersstring
                        })
                
                    if(friendsposts[indexPath.row].likedby == true){
                        let heartFilled = UIImage(named: "heartfilled")
                        cell.likeButton.setImage(heartFilled, for: .normal)
                    }//close if
                    if(friendsposts[indexPath.row].likedby == false){
                        let heartEmpty = UIImage(named: "heartempty")
                        cell.likeButton.setImage(heartEmpty, for: .normal)
                    }//close if
                    
                  if(friendsposts[indexPath.row].postorevent == "post"){
                //    print(friendsposts[indexPath.row].postorevent )
                    cell.postText.font = .systemFont(ofSize: 15)
                    cell.postText.text = friendsposts[indexPath.row].caption
                  cell.descriptionButt.isHidden = true
                    
            cell.likeLabel.text = String(friendsposts[indexPath.row].numberoflikes)
                    //print(indexPath.row)
                    let backgroundView = UIView()
                    backgroundView.backgroundColor = UIColor.white
                    cell.selectedBackgroundView = backgroundView
                   
                  
                   
                    
                     cell.timeStamp.isHidden =  false
                    cell.DateStamp.isHidden =  true
                    cell.DateStamp2.isHidden = true
                  cell.threedots.isHidden =  false
                    cell.postImage.isHidden = false
                   // cell.threedots2.isHidden = true
                    var timeStampString: String = findStringOfTime(newDate: Int(friendsposts[indexPath.row].posttime))
                   
                    
                            cell.timeStamp.text = timeStampString
                    
                        
                    
                    
                   // print(friendsposts[indexPath.row].postID)
              //cell.CommentStamp.text = friendsposts[indexPath.row].
                    
                    
                    
                   
                    if( friendsposts[indexPath.row].likedby == true){
                      
                        let heartFilled = UIImage(named: "heartfilled")
                        cell.likeButton.setImage(heartFilled, for: .normal)
                    }//close if
                
                    
              
                        
                        //cell.nameButton.setTitle(username, for: .normal)
                      // cell.cellID = toId 8/12/2019
                        //cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: profileimageURL)
                        cell.nameButton.setTitle(friendsposts[indexPath.row].displayName, for: .normal)
                        // cell.cellID = toId
                        cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: friendsposts[indexPath.row].profImg)
                        if(addedPicture == true ){
                        cell.profileImageViewTop.image = profilePhotoEdit!
                        }
                      let numberoflines = friendsposts[indexPath.row].Spaces // %42
                        
                       let height = numberoflines * 22
                    

                        cell.commentAct = { sender in
                                                          
                                                          let vc = commeListController()
                                               vc.postId = friendsposts[indexPath.row].postID
                                               vc.posterid = friendsposts[indexPath.row].usersName
                                                      
                                                          self.navigationController?.pushViewController(vc, animated: true)

                                                      }//close comment act
                        //cell.postText.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
                        
                        cell.postText.frame.size.height = CGFloat(height) //https://stackoverflow.com/questions/38391528/how-to-set-dynamic-label-size-in-uitableviewcell
                        cell.postText.text = friendsposts[indexPath.row].caption
                        var local2    = (friendsposts[indexPath.row].location)
                         local2 = "@\(local2)"
                        cell.locationButton.setTitle(local2, for: .normal)
                       
                        
                       //cell.songid =  friendsposts[indexPath.row].audio64;
                       
                        
                        
                        //cell.likeLabel.text = String( friendsposts[indexPath.row].numberoflikes)
                        let url = friendsposts[indexPath.row].imageUrl
                        cell.postImage.loadImageUsingCacheWithUrlString(urlString: url)
                        //cell.likeLabel.text = String(friendsposts[indexPath.row].numberoflikes)
                        cell.delegate = self //ADDED
                        
            //            DispatchQueue.main.async(execute: {
            //                                                                    self.tableView.reloadData()
            //                                                                })
                        
                        
                      
                        
                        
                        
                        
                        
                        cell.commentAct = { sender in
                            
                            let vc = commeListController()
                            vc.postId = friendsposts[indexPath.row].postID
                            vc.posterid = friendsposts[indexPath.row].usersName
                        
                            self.navigationController?.pushViewController(vc, animated: true)

                        }//close comment act

                        
                   
                    
                    }
                     if(friendsposts[indexPath.row].postorevent == "event"){
                         cell.postImage2.isHidden = false //cell.nameButton.setTitle(friendsposts[indexPath.row].posterUsername, for: .normal)
                        cell.timeStamp.isHidden =  true
                        cell.DateStamp.isHidden =  false
                        cell.DateStamp2.isHidden = false
                        cell.threedots.isHidden = true
                       
                        cell.globalButton.isHidden = true
                        cell.globalButton2.isHidden =  false
                        let isGlobal = friendsposts[indexPath.row].global
                        
                        cell.commentAct = { sender in
                                                          
                                                          let vc = commeListController()
                                               vc.postId = friendsposts[indexPath.row].postID
                                               vc.posterid = friendsposts[indexPath.row].usersName
                                                      
                                                          self.navigationController?.pushViewController(vc, animated: true)

                                                      }//close comment act
                        if(isGlobal==true){
                            cell.globalButton2.setImage(UIImage(named:"earth"), for: .normal)
                        }
                        else if(isGlobal==false){
                            cell.globalButton2.setImage(UIImage(named:"lock"), for: .normal)
                            
                        }
                        
                        
                        cell.DateStamp.text = (friendsposts[indexPath.row].timeStartString)
                        cell.DateStamp2.text = (friendsposts[indexPath.row].timeEndString)
                        cell.threedots2.isHidden =  false
                        //cell.threedots2.setImage(UIImage(named:"earth"), for: .normal)
                        cell.locationButton.setTitle("@\(friendsposts[indexPath.row].location)", for: .normal)
                        cell.postText.font = .boldSystemFont(ofSize: 20)
                        cell.postText.text = friendsposts[indexPath.row].caption
                        cell.postText.frame.size.height = CGFloat(22)
                     
                        cell.descriptionButt.isHidden = false;
                        let numberoflines = friendsposts[indexPath.row].Spaces
                        
                        let height = numberoflines * 22
                        
                        
                        
                        

                        cell.descriptionButt.frame.size.height = CGFloat(height);
                        cell.descriptionButt.text=friendsposts[indexPath.row].audio64;
                       
                        cell.likeLabel.text = String(friendsposts[indexPath.row].numberoflikes)
                        cell.postImage2.loadImageUsingCacheWithUrlString(urlString: (friendsposts[indexPath.row].imageUrl))
            //            let ref = Database.database().reference().child("users").child(toId)
            //            Database.database().reference().child("users").child(toId).observeSingleEvent(of: .value, with: { (snapshot) in
            //                //print(snapshot.value ?? "")
            //
            //                let dictionary = snapshot.value as? [String: Any]
            //                let username = dictionary?[ "username"] as? String
            //
            //                guard let profileimageURL = dictionary?[ "ProfileImage"] as? String else {return}
                        
                            
                            cell.nameButton.setTitle(friendsposts[indexPath.row].displayName, for: .normal)
                            // cell.cellID = toId
                            cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: friendsposts[indexPath.row].profImg)
                            
                          
                              cell.timeStamp.isHidden =  true
                            cell.postImage.isHidden = true

                            
                       // })
                        
                   }
                        
                        
                        cell.replyAct = { sender in
                               print("in here now")
                        if(cell.nameButton.titleLabel?.text == myUsername){
                               self.presentAlertWithTitle(title: "Would you like to delete your post?", message: "This action cannot be undone", options: "Yes", "No") { (option) in
                                                  print("option: \(option)")
                                                  switch(option) {
                                                  case 0:
                                                    Database.database().reference().child("posts").child(cell.cellID).removeValue { (error, ref) in
                                                    if error != nil {
                                                        print("error \(error)")
                                                    }
                                                    }
                                                    
                                                    
                                                    Database.database().reference().child("comments").child(cell.cellID).removeValue { (error, ref) in
                                                          if error != nil {
                                                              print("error \(error)")
                                                          }
                                                    
                                                    }
                                                      print("option one")
                                                      break
                                                  //  return
                                                  case 1:
                                                      print("option two")
                                                      break
                                                  //return
                                                  default:
                                                      print("option two")
                                                      break
                                                  }
                                              }
                        }
                        
                        else{
                                              self.presentAlertWithTitle(title: "Would you like to report this post?", message: "If you would like WRUD to know the reason behind this report email us directly.", options: "Yes", "No") { (option) in
                                                                 print("option: \(option)")
                                                                 switch(option) {
                                                                 case 0:
                                                                     print("option one")
                                                                     break
                                                                 //  return
                                                                 case 1:
                                                                     print("option two")
                                                                     break
                                                                 //return
                                                                 default:
                                                                     print("option two")
                                                                     break
                                                                 }
                                                             }
                                       }
                               
                        
                        
                           }
                    
                    
                    cell.buttonAct = { sender in
                        var useridpluspostid = ""
                        var name = cell.userid
                        useridpluspostid = "\(self.uid!)\(cell.cellID)";
                        
                        Database.database().reference().child("posts").child(friendsposts[indexPath.row].postID).observeSingleEvent(of: .value, with: { (snapshot) in
                         if let dict = snapshot.value as? [String: Any]{
                         
                           let likes = dict["numberoflikes"] as! Int
                        
                        DispatchQueue.main.async(execute: {
                                                        
                                                        
                    Database.database().reference().child("posts").child(friendsposts[indexPath.row].postID).child("likers").child(self.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                            
                        if snapshot.exists(){
                            if( friendsposts[indexPath.row].likedby == false){
                                    
                                 
                                     let noti = ["Notification Type": "Like","ID Number": cell.cellID,"Userid":self.uid! ] as [String : Any]
                                    
                                     let new_date = Int(Date().timeIntervalSince1970 * 100000.0)
                                     Database.database().reference().child("users").child(cell.userid!).child("notifications").child(String(new_date)).child(useridpluspostid).updateChildValues(noti);
                                     friendsposts[indexPath.row].likedby = true
                                     let heartFilled = UIImage(named: "heartfilled")
                                     cell.likeButton.setImage(heartFilled, for: .normal)
                                     var liked = friendsposts[indexPath.row].numberoflikes
                                    liked =  likes
                                     //friendsposts[indexPath.row].numberoflikes = likes
                                     //                 print(liked)
                                     //                    ref.child("numberoflikes").setValue(1)
                                     let newValues = ["likerName":usersShowName!, "likersid": self.uid!] as [String : Any]
                                     Database.database().reference().child("posts").child(friendsposts[indexPath.row].postID).updateChildValues(["numberoflikes": liked])
                                    // cell.likeLabel.text = String(liked);
                                     //Database.database().reference().child("posts").child(posts[indexPath.row].postID).child("likers").child(self.uid!).updateChildValues(newValues)
                                     
                                      cell.likeLabel.text = String(liked)
                                     //
                                    // print("liked")
                                     self.loadLikers2friends( Message: friendsposts[indexPath.row].postID, completion: { message in
                                         
                                        // print("in here")
                                        cell.likeLabel.text = String(friendsposts[indexPath.row].numberoflikes);
                                         cell.likerstring.text = friendsposts[indexPath.row].likersstring
                                        if(friendsposts[indexPath.row].likedby == true){
                                            let heartFilled = UIImage(named: "heartfilled")
                                            cell.likeButton.setImage(heartFilled, for: .normal)
                                        }//close if
                                        if(friendsposts[indexPath.row].likedby == false){
                                            let heartEmpty = UIImage(named: "heartempty")
                                            cell.likeButton.setImage(heartEmpty, for: .normal)
                                        }//close if
                                     })
                                     
                            }
                                 else if( friendsposts[indexPath.row].likedby == true){
                                     friendsposts[indexPath.row].likedby = false
                                     let heartFilled = UIImage(named: "heartempty")
                                     Database.database().reference().child("users").child(friendsposts[indexPath.row].usersName).child("notifications").observe(.childAdded, with: { (snapshot) in
                                       //  print("true")
                                         
                                         let postid2 = snapshot.key
                                         Database.database().reference().child("users").child(friendsposts[indexPath.row].usersName).child("notifications").child(postid2).observe(.childAdded, with: {
                                             (snapshot) in
                                             
                                             let postid3 = snapshot.key
                                             if(postid3 == useridpluspostid){
                                                 Database.database().reference().child("users").child(friendsposts[indexPath.row].usersName).child("notifications").child(postid2).child(postid3).removeValue()
                                             }
                                             DispatchQueue.main.async(execute: {
                                             
                                             
                                             })
                                         })
                                     })
                                 
                                     
                                     
                                     
                                     
                                     cell.likeButton.setImage(heartFilled, for: .normal)
                                     var liked = friendsposts[indexPath.row].numberoflikes
                                     liked =  likes-1;
                                     friendsposts[indexPath.row].numberoflikes = liked
                                     Database.database().reference().child("posts").child(friendsposts[indexPath.row].postID).updateChildValues(["numberoflikes": liked])
                                     Database.database().reference().child("posts").child(friendsposts[indexPath.row].postID).child("likers").child(self.uid!).removeValue()
                                     
                                     cell.likeLabel.text = String(liked);
                                    
                                     
                                     self.loadLikers2friends( Message: friendsposts[indexPath.row].postID, completion: { message in
                                         print("in here")
                                         cell.likerstring.text = friendsposts[indexPath.row].likersstring
                                         cell.likeLabel.text = String(friendsposts[indexPath.row].numberoflikes);
                                        if(friendsposts[indexPath.row].likedby == true){
                                            let heartFilled = UIImage(named: "heartfilled")
                                            cell.likeButton.setImage(heartFilled, for: .normal)
                                        }//close if
                                        if(friendsposts[indexPath.row].likedby == false){
                                            let heartEmpty = UIImage(named: "heartempty")
                                            cell.likeButton.setImage(heartEmpty, for: .normal)
                                        }//close if
                                     })
                                     
                                     
                                     
                                     
                                 }
                            
                                 
                                 
                          
                            
                        }else{
                            if( friendsposts[indexPath.row].likedby == false){
                                    
                                 
                                     let noti = ["Notification Type": "Like","ID Number": cell.cellID,"Userid":self.uid! ] as [String : Any]
                                    
                                     let new_date = Int(Date().timeIntervalSince1970 * 100000.0)
                                     Database.database().reference().child("users").child(cell.userid!).child("notifications").child(String(new_date)).child(useridpluspostid).updateChildValues(noti);
                                     friendsposts[indexPath.row].likedby = true
                                     let heartFilled = UIImage(named: "heartfilled")
                                     cell.likeButton.setImage(heartFilled, for: .normal)
                                     var liked = friendsposts[indexPath.row].numberoflikes
                                     liked =  likes  + 1
                                     friendsposts[indexPath.row].numberoflikes = liked
                                     //                 print(liked)
                                     //                    ref.child("numberoflikes").setValue(1)
                                     let newValues = ["likerName":usersShowName!, "likersid": self.uid!] as [String : Any]
                                     Database.database().reference().child("posts").child(friendsposts[indexPath.row].postID).updateChildValues(["numberoflikes": liked])
                                     cell.likeLabel.text = String(liked);
                                     Database.database().reference().child("posts").child(friendsposts[indexPath.row].postID).child("likers").child(self.uid!).updateChildValues(newValues)
                                     
                                     cell.likeLabel.text = String(liked)
                                     //
                                    // print("liked")
                                     self.loadLikers2friends( Message: friendsposts[indexPath.row].postID, completion: { message in
                                         
                                        // print("in here")
                                        cell.likeLabel.text = String(friendsposts[indexPath.row].numberoflikes);
                                         cell.likerstring.text = friendsposts[indexPath.row].likersstring;
                                        if(friendsposts[indexPath.row].likedby == true){
                                            let heartFilled = UIImage(named: "heartfilled")
                                            cell.likeButton.setImage(heartFilled, for: .normal)
                                        }//close if
                                        if(friendsposts[indexPath.row].likedby == false){
                                            let heartEmpty = UIImage(named: "heartempty")
                                            cell.likeButton.setImage(heartEmpty, for: .normal)
                                        }//close if
                                     })
                                     
                                 }
                                 else if( friendsposts[indexPath.row].likedby == true){
                                     friendsposts[indexPath.row].likedby = false
                                     let heartFilled = UIImage(named: "heartempty")
                                     Database.database().reference().child("users").child(friendsposts[indexPath.row].usersName).child("notifications").observe(.childAdded, with: { (snapshot) in
                                       //  print("true")
                                         
                                         let postid2 = snapshot.key
                                         Database.database().reference().child("users").child(friendsposts[indexPath.row].usersName).child("notifications").child(postid2).observe(.childAdded, with: {
                                             (snapshot) in
                                             
                                             let postid3 = snapshot.key
                                             if(postid3 == useridpluspostid){
                                                 Database.database().reference().child("users").child(friendsposts[indexPath.row].usersName).child("notifications").child(postid2).child(postid3).removeValue()
                                             }
                                             DispatchQueue.main.async(execute: {
                                             
                                             
                                             })
                                         })
                                     })
                                 
                            
                                     
                                     
                                     
                                     cell.likeButton.setImage(heartFilled, for: .normal)
                                     var liked = friendsposts[indexPath.row].numberoflikes
                                     liked =  likes
                                     friendsposts[indexPath.row].numberoflikes = liked
                                     Database.database().reference().child("posts").child(friendsposts[indexPath.row].postID).updateChildValues(["numberoflikes": liked])
                                     Database.database().reference().child("posts").child(friendsposts[indexPath.row].postID).child("likers").child(self.uid!).removeValue()
                                     
                                     cell.likeLabel.text = String(liked);
                                    
                                     
                                     self.loadLikers2friends( Message: friendsposts[indexPath.row].postID, completion: { message in
                                         print("in here")
                                         cell.likerstring.text = friendsposts[indexPath.row].likersstring
                                         cell.likeLabel.text = String(friendsposts[indexPath.row].numberoflikes);
                                        
                                        
                                     })
                                     
                                     
                                     
                                     
                                 }
                            
                        
                                 
                             }//close buttonAct
                            
                        })
                                       
                            })
                                }})
                   
                        
                    }//close buttonAct
                
            
            return cell;
        }//ends friends post
        
        
        if(tableView==eventTable){
            
             let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! newsCell;
           // cell.textLabel?.text = "EVENT"
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.white
            cell.selectedBackgroundView = backgroundView
            cell.selectionStyle = .none;
            //      print(posts.count)
            cell.userid = events[indexPath.row].postID
            cell.threedots.isHidden = true
                    //.usersName;
//            if(indexPath.row == 0){

//
//            }
                
                
          //  elsedo {
            if(self.events[indexPath.row].postorevent == "date"){
                cell.nameButton.isHidden = true
                                cell.profileImageView.isHidden = true
                                      cell.postImage.isHidden = true
                                      cell.postImage2.isHidden = true
                                      cell.postText.isHidden = true
                                     cell.locationButton.isHidden = true
                                     cell.profileImageViewTop.isHidden = true
                                cell.timeStamp.isHidden = true
                                      cell.likeButton.isHidden = true
                                   cell.threedots.isHidden = true
                                    cell.DateStamp.isHidden = true
                                      cell.DateStamp2.isHidden = true
                                   //  addSubview(threedots2)
                                     cell.likeLabel.isHidden = true
                                      cell.likerstring.isHidden = true
                                      cell.commentButton.isHidden = true
                                     cell.coverartphoto.isHidden = true

                                     cell.descriptionButt.isHidden = true
                                     cell.CommentStamp.isHidden = true
                                    cell.globalButton.isHidden = true
                cell.globalButton2.isHidden = true
                cell.postImage.isHidden = true
                cell.postImage2.isHidden = true
                cell.threedots2.isHidden = true
                cell.replylocationButton.isHidden = true
                                      cell.replynameButton.isHidden = true
                                   cell.replypostText.isHidden = true
                cell.textLabel?.isHidden  = false
                                
                cell.textLabel!.text
                    = events[indexPath.row].timeStartString
            }
       
                
                if(self.events[indexPath.row].postorevent == "event"){
                    cell.textLabel?.isHidden  = true
                    
                    cell.nameButton.isHidden = false
                                                  cell.profileImageView.isHidden = false
                                                       
                                                        cell.postImage2.isHidden = false
                                                        cell.postText.isHidden = false
                                                       cell.locationButton.isHidden = false
                                                       cell.profileImageViewTop.isHidden = false
                                                
                                                        cell.likeButton.isHidden = false
                                                    
                                                 
                                                     //  addSubview(threedots2)
                                                       cell.likeLabel.isHidden = false
                                                        cell.likerstring.isHidden = false
                                                        cell.commentButton.isHidden = false
                                                       

                                                       cell.descriptionButt.isHidden = false
                                                       cell.CommentStamp.isHidden = false
                                                      
                                  
                                 
                                  cell.postImage2.isHidden = false
                                  
                    
                    
                    cell.commentAct = { sender in
                                   
                                   let vc = commeListController()
                        vc.postId = self.events[indexPath.row].postID
                        vc.posterid = self.events[indexPath.row].usersName
                               
                                   self.navigationController?.pushViewController(vc, animated: true)

                               }//close comment act
                    cell.CommentStamp.isHidden = false
                    
                    cell.CommentStamp.text = String(self.events[indexPath.row].numberofcomments)
                    print("num of comments")
                    print( String(self.events[indexPath.row].numberofcomments))
                    self.loadLikers2event( Message: self.events[indexPath.row].postID, completion: { message in
                             
                            // print("in here")
                        cell.likeLabel.text = String(self.events[indexPath.row].numberoflikes);
                        cell.likerstring.text = self.events[indexPath.row].likersstring
                               })
                       
                           if(events[indexPath.row].likedby == true){
                               let heartFilled = UIImage(named: "heartfilled")
                               cell.likeButton.setImage(heartFilled, for: .normal)
                           }//close if
                           if(events[indexPath.row].likedby == false){
                               let heartEmpty = UIImage(named: "heartempty")
                               cell.likeButton.setImage(heartEmpty, for: .normal)
                           }//close if
                 //cell.nameButton.setTitle(popposts[indexPath.row].posterUsername, for: .normal)
                    cell.replylocationButton.isHidden = true
                       cell.replynameButton.isHidden = true
                    cell.replypostText.isHidden = true
                                           // cell.timeStamp.isHidden =  true
                                            cell.DateStamp.isHidden =  false
                                            cell.DateStamp2.isHidden = false
                                            cell.threedots.isHidden = true
                                           
                                            cell.globalButton.isHidden = true
                                            cell.globalButton2.isHidden =  false
                                            let isGlobal = events[indexPath.row].global
                                            if(isGlobal==true){
                                                cell.globalButton2.setImage(UIImage(named:"earth"), for: .normal)
                                            }
                                            else if(isGlobal==false){
                                                cell.globalButton2.setImage(UIImage(named:"lock"), for: .normal)
                                                
                                            }
                                            
                                            
                    cell.DateStamp.text = (self.events[indexPath.row].timeStartString)
                    cell.DateStamp2.text = (self.events[indexPath.row].timeEndString)
                                            cell.threedots2.isHidden =  false
                                            //cell.threedots2.setImage(UIImage(named:"earth"), for: .normal)
                    cell.locationButton.setTitle("@\(self.events[indexPath.row].location)", for: .normal)
                                            cell.postText.font = .boldSystemFont(ofSize: 20)
                    cell.postText.text = self.events[indexPath.row].caption
                                            cell.postText.frame.size.height = CGFloat(22)
                                         
                                            cell.descriptionButt.isHidden = false;
                    let numberoflines = self.events[indexPath.row].Spaces
                                            
                                            let height = numberoflines * 22
                                            
                                            
                                            
                                            

                                            cell.descriptionButt.frame.size.height = CGFloat(height);
                    cell.descriptionButt.text=self.events[indexPath.row].audio64;
                                           
                    cell.likeLabel.text = String(self.events[indexPath.row].numberoflikes)
                    cell.postImage2.loadImageUsingCacheWithUrlString(urlString: (self.events[indexPath.row].imageUrl))
                                //            let ref = Database.database().reference().child("users").child(toId)
                                //            Database.database().reference().child("users").child(toId).observeSingleEvent(of: .value, with: { (snapshot) in
                                //                //print(snapshot.value ?? "")
                                //
                                //                let dictionary = snapshot.value as? [String: Any]
                                //                let username = dictionary?[ "username"] as? String
                                //
                                //                guard let profileimageURL = dictionary?[ "ProfileImage"] as? String else {return}
                                            
                                                
                    cell.nameButton.setTitle(self.events[indexPath.row].displayName, for: .normal)
                                                // cell.cellID = toId
                    cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: self.events[indexPath.row].profImg)
                                                
                                              
                                                  cell.timeStamp.isHidden =  true
                                                cell.postImage.isHidden = true
                    cell.buttonAct = { sender in
                         var useridpluspostid = ""
                         var name = cell.userid
                         useridpluspostid = "\(self.uid!)\(cell.cellID)";
                         
                         Database.database().reference().child("posts").child(popposts[indexPath.row].postID).observeSingleEvent(of: .value, with: { (snapshot) in
                          if let dict = snapshot.value as? [String: Any]{
                          
                            let likes = dict["numberoflikes"] as! Int
                         
                         DispatchQueue.main.async(execute: {
                                                         
                                                         
                     Database.database().reference().child("posts").child(self.events[indexPath.row].postID).child("likers").child(self.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                             
                         if snapshot.exists(){
                             if( self.events[indexPath.row].likedby == false){
                                     
                                  
                                      let noti = ["Notification Type": "Like","ID Number": cell.cellID,"Userid":self.uid! ] as [String : Any]
                                     
                                      let new_date = Int(Date().timeIntervalSince1970 * 100000.0)
                                      Database.database().reference().child("users").child(cell.userid!).child("notifications").child(String(new_date)).child(useridpluspostid).updateChildValues(noti);
                                      self.events[indexPath.row].likedby = true
                                      let heartFilled = UIImage(named: "heartfilled")
                                      cell.likeButton.setImage(heartFilled, for: .normal)
                                      var liked = self.events[indexPath.row].numberoflikes
                                     liked =  likes
                                      //self.events[indexPath.row].numberoflikes = likes
                                      //                 print(liked)
                                      //                    ref.child("numberoflikes").setValue(1)
                                      let newValues = ["likerName":usersShowName!, "likersid": self.uid!] as [String : Any]
                                      Database.database().reference().child("posts").child(self.events[indexPath.row].postID).updateChildValues(["numberoflikes": liked])
                                     // cell.likeLabel.text = String(liked);
                                      //Database.database().reference().child("posts").child(posts[indexPath.row].postID).child("likers").child(self.uid!).updateChildValues(newValues)
                                      
                                       cell.likeLabel.text = String(liked)
                                      //
                                     // print("liked")
                                      self.loadLikers2event( Message: self.events[indexPath.row].postID, completion: { message in
                                          
                                         // print("in here")
                                         cell.likeLabel.text = String(self.events[indexPath.row].numberoflikes);
                                          cell.likerstring.text = self.events[indexPath.row].likersstring
                                         if(self.events[indexPath.row].likedby == true){
                                             let heartFilled = UIImage(named: "heartfilled")
                                             cell.likeButton.setImage(heartFilled, for: .normal)
                                         }//close if
                                         if(self.events[indexPath.row].likedby == false){
                                             let heartEmpty = UIImage(named: "heartempty")
                                             cell.likeButton.setImage(heartEmpty, for: .normal)
                                         }//close if
                                      })
                                      
                             }
                                  else if( self.events[indexPath.row].likedby == true){
                                      self.events[indexPath.row].likedby = false
                                      let heartFilled = UIImage(named: "heartempty")
                                      Database.database().reference().child("users").child(self.events[indexPath.row].usersName).child("notifications").observe(.childAdded, with: { (snapshot) in
                                        //  print("true")
                                          
                                          let postid2 = snapshot.key
                                          Database.database().reference().child("users").child(self.events[indexPath.row].usersName).child("notifications").child(postid2).observe(.childAdded, with: {
                                              (snapshot) in
                                              
                                              let postid3 = snapshot.key
                                              if(postid3 == useridpluspostid){
                                                  Database.database().reference().child("users").child(self.events[indexPath.row].usersName).child("notifications").child(postid2).child(postid3).removeValue()
                                              }
                                              DispatchQueue.main.async(execute: {
                                              
                                              
                                              })
                                          })
                                      })
                                  
                                      
                                      
                                      
                                      
                                      cell.likeButton.setImage(heartFilled, for: .normal)
                                      var liked = self.events[indexPath.row].numberoflikes
                                      liked =  likes-1;
                                      self.events[indexPath.row].numberoflikes = liked
                                      Database.database().reference().child("posts").child(self.events[indexPath.row].postID).updateChildValues(["numberoflikes": liked])
                                      Database.database().reference().child("posts").child(self.events[indexPath.row].postID).child("likers").child(self.uid!).removeValue()
                                      
                                      cell.likeLabel.text = String(liked);
                                     
                                      
                                      self.loadLikers2event( Message: self.events[indexPath.row].postID, completion: { message in
                                          print("in here")
                                          cell.likerstring.text = self.events[indexPath.row].likersstring
                                          cell.likeLabel.text = String(self.events[indexPath.row].numberoflikes);
                                         if(self.events[indexPath.row].likedby == true){
                                             let heartFilled = UIImage(named: "heartfilled")
                                             cell.likeButton.setImage(heartFilled, for: .normal)
                                         }//close if
                                         if(self.events[indexPath.row].likedby == false){
                                             let heartEmpty = UIImage(named: "heartempty")
                                             cell.likeButton.setImage(heartEmpty, for: .normal)
                                         }//close if
                                      })
                                      
                                      
                                      
                                      
                                  }
                             
                                  
                                  
                           
                             
                         }else{
                             if( self.events[indexPath.row].likedby == false){
                                     
                                  
                                      let noti = ["Notification Type": "Like","ID Number": cell.cellID,"Userid":self.uid! ] as [String : Any]
                                     
                                      let new_date = Int(Date().timeIntervalSince1970 * 100000.0)
                                      Database.database().reference().child("users").child(cell.userid!).child("notifications").child(String(new_date)).child(useridpluspostid).updateChildValues(noti);
                                      self.events[indexPath.row].likedby = true
                                      let heartFilled = UIImage(named: "heartfilled")
                                      cell.likeButton.setImage(heartFilled, for: .normal)
                                      var liked = self.events[indexPath.row].numberoflikes
                                      liked =  likes  + 1
                                      self.events[indexPath.row].numberoflikes = liked
                                      //                 print(liked)
                                      //                    ref.child("numberoflikes").setValue(1)
                                      let newValues = ["likerName":usersShowName!, "likersid": self.uid!] as [String : Any]
                                      Database.database().reference().child("posts").child(self.events[indexPath.row].postID).updateChildValues(["numberoflikes": liked])
                                      cell.likeLabel.text = String(liked);
                                      Database.database().reference().child("posts").child(self.events[indexPath.row].postID).child("likers").child(self.uid!).updateChildValues(newValues)
                                      
                                      cell.likeLabel.text = String(liked)
                                      //
                                     // print("liked")
                                      self.loadLikers2event( Message: self.events[indexPath.row].postID, completion: { message in
                                          
                                         // print("in here")
                                         cell.likeLabel.text = String(self.events[indexPath.row].numberoflikes);
                                          cell.likerstring.text = self.events[indexPath.row].likersstring;
                                         if(self.events[indexPath.row].likedby == true){
                                             let heartFilled = UIImage(named: "heartfilled")
                                             cell.likeButton.setImage(heartFilled, for: .normal)
                                         }//close if
                                         if(self.events[indexPath.row].likedby == false){
                                             let heartEmpty = UIImage(named: "heartempty")
                                             cell.likeButton.setImage(heartEmpty, for: .normal)
                                         }//close if
                                      })
                                      
                                  }
                                  else if( self.events[indexPath.row].likedby == true){
                                      self.events[indexPath.row].likedby = false
                                      let heartFilled = UIImage(named: "heartempty")
                                      Database.database().reference().child("users").child(self.events[indexPath.row].usersName).child("notifications").observe(.childAdded, with: { (snapshot) in
                                        //  print("true")
                                          
                                          let postid2 = snapshot.key
                                          Database.database().reference().child("users").child(self.events[indexPath.row].usersName).child("notifications").child(postid2).observe(.childAdded, with: {
                                              (snapshot) in
                                              
                                              let postid3 = snapshot.key
                                              if(postid3 == useridpluspostid){
                                                  Database.database().reference().child("users").child(self.events[indexPath.row].usersName).child("notifications").child(postid2).child(postid3).removeValue()
                                              }
                                              DispatchQueue.main.async(execute: {
                                              
                                              
                                              })
                                          })
                                      })
                                  
                             
                                      
                                      
                                      
                                      cell.likeButton.setImage(heartFilled, for: .normal)
                                      var liked = self.events[indexPath.row].numberoflikes
                                      liked =  likes
                                      self.events[indexPath.row].numberoflikes = liked
                                      Database.database().reference().child("posts").child(self.events[indexPath.row].postID).updateChildValues(["numberoflikes": liked])
                                      Database.database().reference().child("posts").child(popposts[indexPath.row].postID).child("likers").child(self.uid!).removeValue()
                                      
                                      cell.likeLabel.text = String(liked);
                                     
                                      
                                      self.loadLikers2event( Message: self.events[indexPath.row].postID, completion: { message in
                                          print("in here")
                                          cell.likerstring.text = self.events[indexPath.row].likersstring
                                          cell.likeLabel.text = String(self.events[indexPath.row].numberoflikes);
                                         
                                         
                                      })
                                      
                                      
                                      
                                      
                                  }
                             
                         
                                  
                              }//close buttonAct
                             
                         })
                                        
                             })
                                 }})
                    
                         
                     }//close buttonAct
                                                
                                           // })
                                            
                                       }
         //   }
//            else  if( events[indexPath.row-1].eventDescription == "justadate" && events[indexPath.row-1].eventTitle == "justadate"  ){
//                cell.textLabel?.text = events[indexPath.row-1].DateString
//                cell.nameButton.isHidden = true
//                cell.profileImageView.isHidden = true
//                      cell.postImage.isHidden = true
//                      cell.postImage2.isHidden = true
//                      cell.postText.isHidden = true
//                     cell.locationButton.isHidden = true
//                     cell.profileImageViewTop.isHidden = true
//                cell.timeStamp.isHidden = true
//                      cell.likeButton.isHidden = true
//                   cell.threedots.isHidden = true
//                    cell.DateStamp.isHidden = true
//                      cell.DateStamp2.isHidden = true
//                   //  addSubview(threedots2)
//                     cell.likeLabel.isHidden = true
//                      cell.likerstring.isHidden = true
//                      cell.commentButton.isHidden = true
//                     cell.coverartphoto.isHidden = true
//
//                     cell.descriptionButt.isHidden = true
//                     cell.CommentStamp.isHidden = true
//                    cell.globalButton.isHidden = true
//
//
//                     //for replies only
//                      cell.replynameButton.isHidden = true
//                      cell.replyprofileImageView.isHidden = true
//                      cell.replyprofileImageViewTop.isHidden = true
//                      cell.replylocationButton.isHidden = true
//                     cell.replypostText.isHidden = true
//                    cell.threedots2.isHidden = true
//                      cell.globalButton2.isHidden = true
//
//            }
//            else {
//                cell.replynameButton.isHidden = true
//                 cell.replyprofileImageView.isHidden = true
//                 cell.replyprofileImageViewTop.isHidden = true
//                 cell.replylocationButton.isHidden = true
//                cell.replypostText.isHidden = true
//                cell.globalButton.isHidden = true
//                cell.nameButton.setTitle(events[indexPath.row-1].posterUsername, for: .normal)
//                cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: events[indexPath.row-1].profileUrl)
//
//                cell.DateStamp.text = (events[indexPath.row-1].timeStartString)
//                cell.DateStamp2.text = (events[indexPath.row-1].timeEndString)
//                cell.threedots.isHidden = true
//                cell.locationButton.setTitle("@\(events[indexPath.row-1].Locations)", for: .normal)
//                cell.postText.font = .boldSystemFont(ofSize: 15)
//                cell.postText.text =
//                    events[indexPath.row-1].eventTitle
//               // cell.descriptionButt.frame.size.height = CGFloat(24)
//                cell.descriptionButt.text = events[indexPath.row-1].eventDescription;
//                cell.postImage.isHidden = true
//                cell.CommentStamp.isHidden = false
//                cell.likeButton.isHidden = false
//                let heartFilled = UIImage(named: "heartfilled")
//                cell.likeButton.setImage(heartFilled, for: .normal)
//                cell.likeLabel.isHidden =  false
//                cell.likeLabel.text = "0"
//                cell.CommentStamp.text = "0"
//                cell.likerstring.isHidden = false
//                let earth = UIImage(named: "earth")
//              //  cell.globalButton.setImage(earth, for: .normal)
//
//
//            }
            return cell
            
        }//end friends posts
        
        else{
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! newsCell;
//      print(posts.count)
            cell.postImage2.isHidden = true
            cell.selectionStyle = .none;
        cell.cellID = posts[indexPath.row].postID
        cell.userid = posts[indexPath.row].usersName;
       
            cell.replypostText.isHidden = true
        cell.globalButton2.isHidden = true
            cell.threedots2.isHidden = true
        
         let toId = posts[indexPath.row].usersName
            cell.globalButton.isHidden = false
         let isGlobal = posts[indexPath.row].global
            if(isGlobal==true){
                cell.globalButton.setImage(UIImage(named:"earth"), for: .normal)
            }
            else if(isGlobal==false){
                cell.globalButton.setImage(UIImage(named:"lock"), for: .normal)
                
            }
         cell.CommentStamp.text = String(posts[indexPath.row].numberofcomments)
          
         self.loadLikers2( Message: posts[indexPath.row].postID, completion: { message in
          
         // print("in here")
         cell.likeLabel.text = String(posts[indexPath.row].numberoflikes);
          cell.likerstring.text = posts[indexPath.row].likersstring
            })
    
        if(posts[indexPath.row].likedby == true){
            let heartFilled = UIImage(named: "heartfilled")
            cell.likeButton.setImage(heartFilled, for: .normal)
        }//close if
        if(posts[indexPath.row].likedby == false){
            let heartEmpty = UIImage(named: "heartempty")
            cell.likeButton.setImage(heartEmpty, for: .normal)
        }//close if
        
      if(posts[indexPath.row].postorevent == "post"){
    //    print(posts[indexPath.row].postorevent )
        cell.postText.font = .systemFont(ofSize: 15)
        cell.postText.text = posts[indexPath.row].caption
      cell.descriptionButt.isHidden = true
        
cell.likeLabel.text = String(posts[indexPath.row].numberoflikes)
        //print(indexPath.row)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
       
      
       
        
         cell.timeStamp.isHidden =  false
        cell.DateStamp.isHidden =  true
        cell.DateStamp2.isHidden = true
      cell.threedots.isHidden =  false
        cell.postImage.isHidden = false
       // cell.threedots2.isHidden = true
        var timeStampString: String = findStringOfTime(newDate: Int(posts[indexPath.row].posttime))
       
        
                cell.timeStamp.text = timeStampString
        
            
        
        
       // print(posts[indexPath.row].postID)
  //cell.CommentStamp.text = posts[indexPath.row].
        
        
        
       
        if( posts[indexPath.row].likedby == true){
          
            let heartFilled = UIImage(named: "heartfilled")
            cell.likeButton.setImage(heartFilled, for: .normal)
        }//close if
    
        
  
            
            //cell.nameButton.setTitle(username, for: .normal)
          // cell.cellID = toId 8/12/2019
            //cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: profileimageURL)
            cell.nameButton.setTitle(posts[indexPath.row].displayName, for: .normal)
            // cell.cellID = toId
            cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: posts[indexPath.row].profImg)
          let numberoflines = posts[indexPath.row].Spaces // %42
            
           let height = numberoflines * 22
        

            
            //cell.postText.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
            
            cell.postText.frame.size.height = CGFloat(height) //https://stackoverflow.com/questions/38391528/how-to-set-dynamic-label-size-in-uitableviewcell
            cell.postText.text = posts[indexPath.row].caption
            var local2    = (posts[indexPath.row].location)
             local2 = "@\(local2)"
            cell.locationButton.setTitle(local2, for: .normal)
           
            
           //cell.songid =  posts[indexPath.row].audio64;
           
            
            
            //cell.likeLabel.text = String( posts[indexPath.row].numberoflikes)
            let url = posts[indexPath.row].imageUrl
            cell.postImage.loadImageUsingCacheWithUrlString(urlString: url)
            //cell.likeLabel.text = String(posts[indexPath.row].numberoflikes)
            cell.delegate = self //ADDED
            
//            DispatchQueue.main.async(execute: {
//                                                                    self.tableView.reloadData()
//                                                                })
            
            
          
            
            
            
            
            
            cell.commentAct = { sender in
                
                let vc = commeListController()
                vc.postId = posts[indexPath.row].postID
                vc.posterid = posts[indexPath.row].usersName
            
                self.navigationController?.pushViewController(vc, animated: true)

            }//close comment act

            
       
        
        }
         if(posts[indexPath.row].postorevent == "event"){
             cell.postImage2.isHidden = false //cell.nameButton.setTitle(posts[indexPath.row].posterUsername, for: .normal)
            cell.timeStamp.isHidden =  true
            cell.DateStamp.isHidden =  false
            cell.DateStamp2.isHidden = false
            cell.threedots.isHidden = true
           
            cell.globalButton.isHidden = true
            cell.globalButton2.isHidden =  false
            let isGlobal = posts[indexPath.row].global
            if(isGlobal==true){
                cell.globalButton2.setImage(UIImage(named:"earth"), for: .normal)
            }
            else if(isGlobal==false){
                cell.globalButton2.setImage(UIImage(named:"lock"), for: .normal)
                
            }
            cell.commentAct = { sender in
                       
                       let vc = commeListController()
            vc.postId = posts[indexPath.row].postID
            vc.posterid = posts[indexPath.row].usersName
                   
                       self.navigationController?.pushViewController(vc, animated: true)

                   }//close comment act
            
            cell.DateStamp.text = (posts[indexPath.row].timeStartString)
            cell.DateStamp2.text = (posts[indexPath.row].timeEndString)
            cell.threedots2.isHidden =  false
            //cell.threedots2.setImage(UIImage(named:"earth"), for: .normal)
            cell.locationButton.setTitle("@\(posts[indexPath.row].location)", for: .normal)
            cell.postText.font = .boldSystemFont(ofSize: 20)
            cell.postText.text = posts[indexPath.row].caption
            cell.postText.frame.size.height = CGFloat(22)
         
            cell.descriptionButt.isHidden = false;
            let numberoflines = posts[indexPath.row].Spaces
            
            let height = numberoflines * 22
            
            
            
            

            cell.descriptionButt.frame.size.height = CGFloat(height);
            cell.descriptionButt.text=posts[indexPath.row].audio64;
           
            cell.likeLabel.text = String(posts[indexPath.row].numberoflikes)
            cell.postImage2.loadImageUsingCacheWithUrlString(urlString: (posts[indexPath.row].imageUrl))
//            let ref = Database.database().reference().child("users").child(toId)
//            Database.database().reference().child("users").child(toId).observeSingleEvent(of: .value, with: { (snapshot) in
//                //print(snapshot.value ?? "")
//
//                let dictionary = snapshot.value as? [String: Any]
//                let username = dictionary?[ "username"] as? String
//
//                guard let profileimageURL = dictionary?[ "ProfileImage"] as? String else {return}
            
                
                cell.nameButton.setTitle(posts[indexPath.row].displayName, for: .normal)
               // cell.cellID = toId
            cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: posts[indexPath.row].profImg)
                
              
                  cell.timeStamp.isHidden =  true
                cell.postImage.isHidden = true

                
           // })
            
       }
            
            
            cell.replyAct = { sender in
                   print("in here now")
            if(cell.nameButton.titleLabel?.text == myUsername){
                   self.presentAlertWithTitle(title: "Would you like to delete your post?", message: "This action cannot be undone", options: "Yes", "No") { (option) in
                                      print("option: \(option)")
                                      switch(option) {
                                      case 0:
                                          print("option one")
                                          Database.database().reference().child("posts").child(cell.cellID).removeValue { (error, ref) in
                                                  if error != nil {
                                                      print("error \(error)")
                                                  }
                                            
                                            
                                              }
                                          
                                          Database.database().reference().child("comments").child(cell.cellID).removeValue { (error, ref) in
                                                if error != nil {
                                                    print("error \(error)")
                                                }
                                          
                                          
                                            }
                                          
                                          
                                          break
                                      //  return
                                      case 1:
                                          print("option two")
                                          break
                                      //return
                                      default:
                                          print("option two")
                                          break
                                      }
                                  }
            }
            
            else{
                                  self.presentAlertWithTitle(title: "Would you like to report this post?", message: "If you would like WRUD to know the reason behind this report email us directly.", options: "Yes", "No") { (option) in
                                                     print("option: \(option)")
                                                     switch(option) {
                                                     case 0:
                                                         print("option one")
                                                         break
                                                     //  return
                                                     case 1:
                                                         print("option two")
                                                         break
                                                     //return
                                                     default:
                                                         print("option two")
                                                         break
                                                     }
                                                 }
                           }
                   
            
            
               }
        
        
        cell.buttonAct = { sender in
            var useridpluspostid = ""
            var name = cell.userid
            useridpluspostid = "\(self.uid!)\(cell.cellID)";
            
            Database.database().reference().child("posts").child(posts[indexPath.row].postID).observeSingleEvent(of: .value, with: { (snapshot) in
             if let dict = snapshot.value as? [String: Any]{
             
               let likes = dict["numberoflikes"] as! Int
            
            DispatchQueue.main.async(execute: {
                                            
                                            
        Database.database().reference().child("posts").child(posts[indexPath.row].postID).child("likers").child(self.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
            if snapshot.exists(){
                if( posts[indexPath.row].likedby == false){
                        
                     
                         let noti = ["Notification Type": "Like","ID Number": cell.cellID,"Userid":self.uid! ] as [String : Any]
                        
                         let new_date = Int(Date().timeIntervalSince1970 * 100000.0)
                         Database.database().reference().child("users").child(cell.userid!).child("notifications").child(String(new_date)).child(useridpluspostid).updateChildValues(noti);
                         posts[indexPath.row].likedby = true
                         let heartFilled = UIImage(named: "heartfilled")
                         cell.likeButton.setImage(heartFilled, for: .normal)
                         var liked = posts[indexPath.row].numberoflikes
                        liked =  likes
                         //posts[indexPath.row].numberoflikes = likes
                         //                 print(liked)
                         //                    ref.child("numberoflikes").setValue(1)
                         let newValues = ["likerName":usersShowName!, "likersid": self.uid!] as [String : Any]
                         Database.database().reference().child("posts").child(posts[indexPath.row].postID).updateChildValues(["numberoflikes": liked])
                        // cell.likeLabel.text = String(liked);
                         //Database.database().reference().child("posts").child(posts[indexPath.row].postID).child("likers").child(self.uid!).updateChildValues(newValues)
                         
                          cell.likeLabel.text = String(liked)
                         //
                        // print("liked")
                         self.loadLikers2( Message: posts[indexPath.row].postID, completion: { message in
                             
                            // print("in here")
                            cell.likeLabel.text = String(posts[indexPath.row].numberoflikes);
                             cell.likerstring.text = posts[indexPath.row].likersstring
                            if(posts[indexPath.row].likedby == true){
                                let heartFilled = UIImage(named: "heartfilled")
                                cell.likeButton.setImage(heartFilled, for: .normal)
                            }//close if
                            if(posts[indexPath.row].likedby == false){
                                let heartEmpty = UIImage(named: "heartempty")
                                cell.likeButton.setImage(heartEmpty, for: .normal)
                            }//close if
                         })
                         
                }
                     else if( posts[indexPath.row].likedby == true){
                         posts[indexPath.row].likedby = false
                         let heartFilled = UIImage(named: "heartempty")
                         Database.database().reference().child("users").child(posts[indexPath.row].usersName).child("notifications").observe(.childAdded, with: { (snapshot) in
                           //  print("true")
                             
                             let postid2 = snapshot.key
                             Database.database().reference().child("users").child(posts[indexPath.row].usersName).child("notifications").child(postid2).observe(.childAdded, with: {
                                 (snapshot) in
                                 
                                 let postid3 = snapshot.key
                                 if(postid3 == useridpluspostid){
                                     Database.database().reference().child("users").child(posts[indexPath.row].usersName).child("notifications").child(postid2).child(postid3).removeValue()
                                 }
                                 DispatchQueue.main.async(execute: {
                                 
                                 
                                 })
                             })
                         })
                     
                         
                         
                         
                         
                         cell.likeButton.setImage(heartFilled, for: .normal)
                         var liked = posts[indexPath.row].numberoflikes
                         liked =  likes-1;
                         posts[indexPath.row].numberoflikes = liked
                         Database.database().reference().child("posts").child(posts[indexPath.row].postID).updateChildValues(["numberoflikes": liked])
                         Database.database().reference().child("posts").child(posts[indexPath.row].postID).child("likers").child(self.uid!).removeValue()
                         
                         cell.likeLabel.text = String(liked);
                        
                         
                         self.loadLikers2( Message: posts[indexPath.row].postID, completion: { message in
                             print("in here")
                             cell.likerstring.text = posts[indexPath.row].likersstring
                             cell.likeLabel.text = String(posts[indexPath.row].numberoflikes);
                            if(posts[indexPath.row].likedby == true){
                                let heartFilled = UIImage(named: "heartfilled")
                                cell.likeButton.setImage(heartFilled, for: .normal)
                            }//close if
                            if(posts[indexPath.row].likedby == false){
                                let heartEmpty = UIImage(named: "heartempty")
                                cell.likeButton.setImage(heartEmpty, for: .normal)
                            }//close if
                         })
                         
                         
                         
                         
                     }
                
                     
                     
              
                
            }else{
                if( posts[indexPath.row].likedby == false){
                        
                     
                         let noti = ["Notification Type": "Like","ID Number": cell.cellID,"Userid":self.uid! ] as [String : Any]
                        
                         let new_date = Int(Date().timeIntervalSince1970 * 100000.0)
                         Database.database().reference().child("users").child(cell.userid!).child("notifications").child(String(new_date)).child(useridpluspostid).updateChildValues(noti);
                         posts[indexPath.row].likedby = true
                         let heartFilled = UIImage(named: "heartfilled")
                         cell.likeButton.setImage(heartFilled, for: .normal)
                         var liked = posts[indexPath.row].numberoflikes
                         liked =  likes  + 1
                         posts[indexPath.row].numberoflikes = liked
                         //                 print(liked)
                         //                    ref.child("numberoflikes").setValue(1)
                         let newValues = ["likerName":usersShowName!, "likersid": self.uid!] as [String : Any]
                         Database.database().reference().child("posts").child(posts[indexPath.row].postID).updateChildValues(["numberoflikes": liked])
                         cell.likeLabel.text = String(liked);
                         Database.database().reference().child("posts").child(posts[indexPath.row].postID).child("likers").child(self.uid!).updateChildValues(newValues)
                         
                         cell.likeLabel.text = String(liked)
                         //
                        // print("liked")
                         self.loadLikers2( Message: posts[indexPath.row].postID, completion: { message in
                             
                            // print("in here")
                            cell.likeLabel.text = String(posts[indexPath.row].numberoflikes);
                             cell.likerstring.text = posts[indexPath.row].likersstring;
                            if(posts[indexPath.row].likedby == true){
                                let heartFilled = UIImage(named: "heartfilled")
                                cell.likeButton.setImage(heartFilled, for: .normal)
                            }//close if
                            if(posts[indexPath.row].likedby == false){
                                let heartEmpty = UIImage(named: "heartempty")
                                cell.likeButton.setImage(heartEmpty, for: .normal)
                            }//close if
                         })
                         
                     }
                     else if( posts[indexPath.row].likedby == true){
                         posts[indexPath.row].likedby = false
                         let heartFilled = UIImage(named: "heartempty")
                         Database.database().reference().child("users").child(posts[indexPath.row].usersName).child("notifications").observe(.childAdded, with: { (snapshot) in
                           //  print("true")
                             
                             let postid2 = snapshot.key
                             Database.database().reference().child("users").child(posts[indexPath.row].usersName).child("notifications").child(postid2).observe(.childAdded, with: {
                                 (snapshot) in
                                 
                                 let postid3 = snapshot.key
                                 if(postid3 == useridpluspostid){
                                     Database.database().reference().child("users").child(posts[indexPath.row].usersName).child("notifications").child(postid2).child(postid3).removeValue()
                                 }
                                 DispatchQueue.main.async(execute: {
                                 
                                 
                                 })
                             })
                         })
                     
                
                         
                         
                         
                         cell.likeButton.setImage(heartFilled, for: .normal)
                         var liked = posts[indexPath.row].numberoflikes
                         liked =  likes
                         posts[indexPath.row].numberoflikes = liked
                         Database.database().reference().child("posts").child(posts[indexPath.row].postID).updateChildValues(["numberoflikes": liked])
                         Database.database().reference().child("posts").child(posts[indexPath.row].postID).child("likers").child(self.uid!).removeValue()
                         
                         cell.likeLabel.text = String(liked);
                        
                         
                         self.loadLikers2( Message: posts[indexPath.row].postID, completion: { message in
                             print("in here")
                             cell.likerstring.text = posts[indexPath.row].likersstring
                             cell.likeLabel.text = String(posts[indexPath.row].numberoflikes);
                            
                            
                         })
                         
                         
                         
                         
                     }
                
            
                     
                 }//close buttonAct
                
            })
                           
                })
                    }})
       
            
            
        }//close buttonAct
        
        
        return cell;
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! newsCell;
        return cell
        
    }
  
  
}




class newsCell: UITableViewCell, UITextViewDelegate{
    var buttonAct: ((Any) -> Void)?
    var replyAct: ((Any) -> Void)?
     var commentAct: ((Any) -> Void)?
    
    var buttonPlay:  ((Any) -> Void)?
 
    
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
    
    let replynameButton: UIButton = {
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
    
    let replyprofileImageView: UIButton = {
        let profileImage = UIButton()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = 24
        profileImage.contentMode = .scaleAspectFill
        //  buttonView.backgroundColor = UIColor.blue
        return profileImage
    }()
    
    let globalButton: UIButton = {
        let profileImage = UIButton()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.masksToBounds = true
       //ju  profileImage.layer.cornerRadius = 24
        profileImage.contentMode = .scaleAspectFill
        //rofileImage.setImage(earth, for: .normal)
       // profileImage.isEnabled = false
        //  buttonView.backgroundColor = UIColor.blue
        return profileImage
    }()
    
    
    let globalButton2: UIButton = {
    let profileImage = UIButton()
    profileImage.translatesAutoresizingMaskIntoConstraints = false
    profileImage.layer.masksToBounds = true
    //ju  profileImage.layer.cornerRadius = 24
    profileImage.contentMode = .scaleAspectFill
    // profileImage.isEnabled = false
    //  buttonView.backgroundColor = UIColor.blue
    return profileImage
    }()
    
    
    let replyprofileImageViewTop: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 24
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let profileImageViewTop: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 24
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let coverartphoto: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        //imageView.layer.cornerRadius = 24
        imageView.contentMode = .scaleAspectFill
       
        return imageView
    }()
    
   
    let likerstring: UILabel = {
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
    
    
    
    let postText: UITextView = {
        let ptext = UITextView()
        ptext.translatesAutoresizingMaskIntoConstraints = false
        //ptext.layer.masksToBounds = true
       // ptext.contentMode = .scaleAspectFill
        ptext.font = .systemFont(ofSize: 15)
        //ptext.lineBreakMode = .byWordWrapping
        //ptext.backgroundColor = UIColor.blue
        ptext.textColor = UIColor.black
       // ptext.isEditable = false;
        //ptext.numberOfLines = 0
         ptext.dataDetectorTypes = .all
        ptext.isScrollEnabled = false;
        ptext.isEditable = false;
        return ptext
    }()
    
    let replypostText: UITextView = {
        let ptext = UITextView()
        ptext.translatesAutoresizingMaskIntoConstraints = false
        ptext.layer.masksToBounds = true
        ptext.contentMode = .scaleAspectFill
        ptext.font = .systemFont(ofSize: 15)
       // ptext.lineBreakMode = .byWordWrapping
        ptext.textColor = UIColor.black
        ptext.isScrollEnabled = false;
        ptext.isEditable = false;
        ptext.dataDetectorTypes = .all
       // ptext.textAlignment = .right
        //ptext.numberOfLines = 0
        return ptext
    }()
    
    
    
    let postImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let postImage2: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
//    let backgroundCell: UIButton = {
//        let backCell = UIButton()
//        backCell.backgroundColor = UIColor.white
//        backCell.translatesAutoresizingMaskIntoConstraints = false
//        backCell.layer.masksToBounds = true
//        backCell.layer.borderColor = UIColor.darkGray.cgColor
//        backCell.layer.borderWidth = 2
//        //backCell.contentMode = .scaleAspectFill
//
//        //backCell.layer.cornerRadius = 8
//        backCell.isEnabled = false
//        return backCell
//    }()
//
    
    let locationButton: UIButton = {
        let buttonView = UIButton()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.layer.masksToBounds = true
        //buttonView.contentMode = .scaleAspectFill
        //  buttonView.backgroundColor = UIColor.blue
        //buttonView.setTitle("@SJSU", for: .normal)
         buttonView.contentHorizontalAlignment = .left
       buttonView.setTitleColor( UIColor.gray, for: .normal )
        buttonView.titleLabel?.font = .systemFont(ofSize: 14)
        return buttonView
    }()
    
    let replylocationButton: UIButton = {//used as date for reply
        let buttonView = UIButton()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.layer.masksToBounds = true
        //buttonView.contentMode = .scaleAspectFill
        //backgroundColor = UIColor.blue
        //buttonView.setTitle("@SJSU", for: .normal)
        buttonView.contentHorizontalAlignment = .left
        buttonView.setTitleColor( UIColor.lightGray, for: .normal )
        buttonView.titleLabel?.font = .systemFont(ofSize: 14)
        return buttonView
    }()
    
    let likeButton: UIButton = {
        let buttonView = UIButton()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.layer.masksToBounds = true
      //  let heartEmpty = UIImage(named: "heartempty")
        //buttonView.setImage(heartEmpty, for: .normal)
        buttonView.setTitle("tommy", for: .normal)
        return buttonView
    }()
    
//    let playButton: UIButton = {
//        let buttonView = UIButton()
//        buttonView.translatesAutoresizingMaskIntoConstraints = false
//        buttonView.layer.masksToBounds = true
//        let heartEmpty = UIImage(named: "playbuttons")
//        buttonView.setImage(heartEmpty, for: .normal)
//        return buttonView
//    }()
    
    let likeLabel: UILabel = {
        let ptext = UILabel()
        ptext.translatesAutoresizingMaskIntoConstraints = false
        ptext.layer.masksToBounds = true
        ptext.contentMode = .scaleAspectFill
        ptext.font = .systemFont(ofSize: 8)
        //ptext.text = "0"
        ptext.textColor = UIColor.black
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
    
    let threedots2: UIButton = {
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
        ptext.font = .systemFont(ofSize: 13)
        //ptext.lineBreakMode = .byWordWrapping
        ptext.textColor = UIColor.gray
       // ptext.text = "MAY 5, 2019"
        ptext.numberOfLines = 0
        ptext.textAlignment = .right
        return ptext
    }()
    
    let DateStamp: UILabel = {
        let ptext = UILabel()
        ptext.translatesAutoresizingMaskIntoConstraints = false
        ptext.layer.masksToBounds = true
        ptext.contentMode = .scaleAspectFill
        ptext.font = .systemFont(ofSize: 10)
        //ptext.lineBreakMode = .byWordWrapping
        ptext.textColor = UIColor.gray
        // ptext.text = "MAY 5, 2019"
        ptext.numberOfLines = 1
        ptext.textAlignment = .right
        return ptext
    }()
    
    
    
    
    
    let DateStamp2: UILabel = {
        let ptext = UILabel()
        ptext.translatesAutoresizingMaskIntoConstraints = false
        ptext.layer.masksToBounds = true
        ptext.contentMode = .scaleAspectFill
        ptext.font = .systemFont(ofSize: 10)
        //ptext.lineBreakMode = .byWordWrapping
        ptext.textColor = UIColor.gray
        // ptext.text = "MAY 5, 2019"
      //  ptext.backgroundColor = UIColor.blue
        ptext.numberOfLines = 1
        ptext.textAlignment = .right
        return ptext
    }()
    
    let CommentStamp: UILabel = {
        let ptext = UILabel()
        ptext.translatesAutoresizingMaskIntoConstraints = false
        ptext.layer.masksToBounds = true
        ptext.contentMode = .scaleAspectFill
        ptext.font = .systemFont(ofSize: 13)
        //ptext.text = "0"
        //ptext.lineBreakMode = .byWordWrapping
        ptext.textColor = UIColor.white
        // ptext.text = "MAY 5, 2019"
        ptext.numberOfLines = 1
        ptext.textAlignment = .center
        return ptext
    }()
//    let commentArea: UITextView = {
//        let commenta = UITextView(); commenta.translatesAutoresizingMaskIntoConstraints = false
//        commenta.layer.masksToBounds = true
//        commenta.contentMode = .scaleAspectFill
//        //commenta.backgroundColor = UIColor.blue
//         commenta.font = .systemFont(ofSize: 15)
//        commenta.layer.cornerRadius = 5
//        commenta.layer.borderWidth = 2
//       // commenta.layer.borderColor = UIColor.black as! CGColor
//        return commenta
//    }()
    

    let descriptionButt: UILabel = {
        let buttonView = UILabel()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
         buttonView.numberOfLines = 0
        //buttonView.lineBreakMode = .byWordWrapping
      //  buttonView.backgroundColor = UIColor.blue;
       //buttonView.textColor = UIColor.blue;
        buttonView.textAlignment = .left
        buttonView.font = .systemFont(ofSize: 15)
        buttonView.layer.masksToBounds = true
       // buttonView.contentHorizontalAlignment = .left
        return buttonView
    }()
    
    let commentButton: UIButton = {
        let buttonView = UIButton()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.layer.masksToBounds = true
        //buttonView.backgroundColor = UIColor.gray
        // buttonView.layer.cornerRadius = 5
        buttonView.titleLabel?.font = .systemFont(ofSize: 10)
       // buttonView.setTitle("Post", for: .normal)
        buttonView.setImage(UIImage(named: "comment2"), for: .normal)
        return buttonView
    }()
    
    
    
    var cellID = ""
    
    var songid = ""
    
      var userid: String?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
      // self.addSubview(backgroundCell)
        addSubview(nameButton)
        addSubview(profileImageView)
        addSubview(postImage)
        addSubview(postImage2)
        addSubview(postText)
        addSubview(locationButton)
        addSubview(profileImageViewTop)
        addSubview(timeStamp)
        addSubview(likeButton)
        addSubview(threedots)
        addSubview(DateStamp)
        addSubview(DateStamp2)
      //  addSubview(threedots2)
        addSubview(likeLabel)
        addSubview(likerstring)
        addSubview(commentButton)
        //addSubview(playButton)
        addSubview(coverartphoto)
       
        addSubview(descriptionButt)
        addSubview(CommentStamp)
        addSubview(globalButton)
       
        
        //for replies only
        addSubview(replynameButton)
        addSubview(replyprofileImageView)
        addSubview(replyprofileImageViewTop)
        addSubview(replylocationButton)
        addSubview(replypostText)
        addSubview(threedots2)
         addSubview(globalButton2)
        //commentArea.delegate = self
//        backgroundCell.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
//      backgroundCell.widthAnchor.constraint(equalToConstant: 375 ).isActive = true
//        backgroundCell.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
       //backgroundCell.heightAnchor.constraint(equalToConstant:  80).isActive = true
        
        
//        playButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10).isActive = true
//         playButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        playButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 100).isActive = true
//        playButton.centerYAnchor.constraint(equalTo: backgroundCell.centerYAnchor).isActive = true
        
       // coverartphoto.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10).isActive = true
        coverartphoto.widthAnchor.constraint(equalToConstant: 50).isActive = true
        //coverartphoto.heightAnchor.constraint(equalToConstant: 50).isActive = true
        coverartphoto.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
       // coverartphoto.centerYAnchor.constraint(equalTo: backgroundCell.centerYAnchor).isActive = true
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        
        nameButton.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 3).isActive = true
        nameButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        nameButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
       
        nameButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        
        globalButton.rightAnchor.constraint(equalTo: threedots.leftAnchor, constant: -10).isActive = true
           globalButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
          globalButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
           globalButton.centerYAnchor.constraint(equalTo: threedots.centerYAnchor, constant:0 ).isActive = true
        
        globalButton2.rightAnchor.constraint(equalTo: threedots2.leftAnchor, constant: -10).isActive = true
        globalButton2.widthAnchor.constraint(equalToConstant: 15).isActive = true
        globalButton2.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        globalButton2.centerYAnchor.constraint(equalTo: threedots2.centerYAnchor, constant:0 ).isActive = true
        
        replynameButton.leftAnchor.constraint(equalTo:replyprofileImageViewTop.rightAnchor, constant: 3).isActive = true
        replynameButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        replynameButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        replynameButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        
        locationButton.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 3).isActive = true
        locationButton.topAnchor.constraint(equalTo: nameButton.bottomAnchor, constant: 3).isActive = true
        locationButton.widthAnchor.constraint(equalToConstant: 190).isActive = true
        locationButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        replylocationButton.leftAnchor.constraint(equalTo: replyprofileImageViewTop.rightAnchor, constant: 3).isActive = true
        replylocationButton.topAnchor.constraint(equalTo: replynameButton.bottomAnchor, constant: 3).isActive = true
        replylocationButton.widthAnchor.constraint(equalToConstant: 190).isActive = true
        replylocationButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        
        
        
        
        timeStamp.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
       // timeStamp.leftAnchor.constraint(equalTo: likeButton.rightAnchor).isActive = true
        
        timeStamp.centerYAnchor
            .constraint(equalTo: nameButton.centerYAnchor).isActive = true
      //  timeStamp.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        timeStamp.widthAnchor.constraint(equalToConstant: 120).isActive = true
        timeStamp.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        DateStamp.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        DateStamp.centerYAnchor
            .constraint(equalTo: nameButton.centerYAnchor).isActive = true
        DateStamp.widthAnchor.constraint(equalToConstant: 200).isActive = true
        DateStamp.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        DateStamp2.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        DateStamp2.topAnchor
            .constraint(equalTo: DateStamp.bottomAnchor).isActive = true
        DateStamp2.widthAnchor.constraint(equalToConstant: 200).isActive = true
        DateStamp2.heightAnchor.constraint(equalToConstant: 30).isActive = true


        threedots.rightAnchor.constraint(equalTo: timeStamp.rightAnchor).isActive = true
        threedots.topAnchor.constraint(equalTo: timeStamp.bottomAnchor).isActive = true
        threedots.widthAnchor.constraint(equalToConstant: 45).isActive = true
        threedots.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        threedots2.rightAnchor.constraint(equalTo: DateStamp.rightAnchor).isActive = true
        threedots2.topAnchor.constraint(equalTo: DateStamp2.bottomAnchor, constant: 0).isActive = true
        threedots2.widthAnchor.constraint(equalToConstant: 45).isActive = true
        threedots2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.topAnchor.constraint(equalTo:  self.topAnchor, constant: 12).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        profileImageViewTop.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        profileImageViewTop.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageViewTop.topAnchor.constraint(equalTo:  self.topAnchor, constant: 12).isActive = true
        profileImageViewTop.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        
        
        replyprofileImageViewTop.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -250).isActive = true
        replyprofileImageViewTop.widthAnchor.constraint(equalToConstant: 48).isActive = true
        replyprofileImageViewTop.topAnchor.constraint(equalTo:  self.topAnchor, constant: 12).isActive = true
        replyprofileImageViewTop.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        postText.leftAnchor.constraint(equalTo: profileImageView.leftAnchor).isActive = true
       postText.widthAnchor.constraint(equalToConstant: 300).isActive = true
        //postText.heightAnchor.constraint(equalToConstant: 24).isActive = true
            postText.topAnchor
            .constraint(equalTo: profileImageViewTop.bottomAnchor, constant: 5).isActive = true
        
        
        
        replypostText.leftAnchor.constraint(equalTo: replyprofileImageViewTop.leftAnchor, constant: 0).isActive = true
        replypostText.widthAnchor.constraint(equalToConstant: 300).isActive = true
        //postText.heightAnchor.constraint(equalToConstant: 24).isActive = true
        replypostText.topAnchor
            .constraint(equalTo: replyprofileImageViewTop.bottomAnchor, constant: 1).isActive = true
       
        descriptionButt.leftAnchor.constraint(equalTo: profileImageView.leftAnchor, constant: 5).isActive = true
        descriptionButt.widthAnchor.constraint(equalToConstant: 300).isActive = true
        //postText.heightAnchor.constraint(equalToConstant: 24).isActive = true
        descriptionButt.topAnchor
            .constraint(equalTo: postText.bottomAnchor, constant: 1).isActive = true
        
        
        
        likeButton.leftAnchor.constraint(equalTo: commentButton.rightAnchor).isActive = true
       likeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
       likeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
       likeButton.bottomAnchor //50
            .constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        likerstring.leftAnchor.constraint(equalTo: likeButton.rightAnchor).isActive = true
        likerstring.widthAnchor.constraint(equalToConstant: 200).isActive = true
        likerstring.heightAnchor.constraint(equalToConstant: 50).isActive = true
        likerstring.bottomAnchor //50
            .constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        
        
        
        likeLabel.leftAnchor.constraint(equalTo: likeButton.leftAnchor).isActive = true
         likeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
         likeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true//50
         likeLabel.bottomAnchor
            .constraint(equalTo:likeButton.bottomAnchor ).isActive = true
        
        
        postImage.leftAnchor.constraint(equalTo: profileImageView.leftAnchor).isActive = true
        postImage.topAnchor
           .constraint(equalTo: postText.bottomAnchor, constant: 0).isActive = true
        
        postImage.centerXAnchor
            .constraint(equalTo: postText.centerXAnchor).isActive = true
        postImage.widthAnchor.constraint(equalToConstant: 300).isActive = true
        postImage .heightAnchor.constraint(equalToConstant: 300).isActive = true
    
        
        postImage2.leftAnchor.constraint(equalTo: profileImageView.leftAnchor).isActive = true
        postImage2.topAnchor
           .constraint(equalTo: descriptionButt.bottomAnchor, constant: 5).isActive = true
        
        postImage2.centerXAnchor
            .constraint(equalTo: postText.centerXAnchor).isActive = true
        postImage2.widthAnchor.constraint(equalToConstant: 300).isActive = true
        postImage2.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        commentButton.leftAnchor
            .constraint(equalTo: postText.leftAnchor, constant:0).isActive = true
        commentButton.bottomAnchor
            .constraint(equalTo:self.bottomAnchor, constant: 0).isActive = true
        commentButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        commentButton.heightAnchor.constraint(equalToConstant: 50).isActive = true//50
        
        CommentStamp.leftAnchor
            .constraint(equalTo: postText.leftAnchor, constant:0).isActive = true
        CommentStamp.bottomAnchor
            .constraint(equalTo:self.bottomAnchor, constant: 0).isActive = true
        CommentStamp.widthAnchor.constraint(equalToConstant: 50).isActive = true
        CommentStamp.heightAnchor.constraint(equalToConstant: 50).isActive = true//50
        
        
        nameButton.addTarget(self, action: #selector(profileFunc), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        profileImageView.addTarget(self, action: #selector(profileFunc), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(takeCareOfLikes), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(takeCareOfComment), for: .touchUpInside)
        //playButton.addTarget(self, action: #selector(takeCareOfPlay), for: .touchUpInside)
        threedots.addTarget(self, action: #selector(commentreply), for: .touchUpInside)
        threedots2.addTarget(self, action: #selector(commentreply), for: .touchUpInside)
    }
    var delegate: newsCellDelegate?
    
    @objc func buttonAction(){
       var locationminusat = locationButton.titleLabel?.text ?? ""
          locationminusat.remove(at: locationminusat.startIndex)
        
        delegate?.didTapLocationButton(local: locationminusat)
    }
    
    @objc func profileFunc(){
        
        delegate?.didTapProfile(name: nameButton.titleLabel?.text ?? "", profilePicture: profileImageViewTop.image ?? UIImage(named: "unknown")!, nameid: userid!)
    }
    
    @objc func takeCareOfLikes(sender: Any){
        
        self.buttonAct?(sender)
        
}
    @objc func commentreply(sender: Any){
        print("comment HERE")
        self.replyAct?(sender)
        
    }
    
    
    @objc func takeCareOfPlay(sender: Any){
    
    self.buttonPlay?(sender)
    }
    
    @objc func takeCareOfComment(sender: Any){
    
   self.commentAct?(sender)
    
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension HomeViewController: newsCellDelegate {
    func didTapLocationButton(local: String) {
    
        let vc = AnnotationTableViewController()
        vc.spot = local
//        let navController = UINavigationController(rootViewController: vc)
//
//        present(navController, animated: true, completion: nil)
        let navController = UINavigationController(rootViewController: vc)
        
        present(navController, animated: true, completion: nil)
    }
    
    func didTapProfile(name: String, profilePicture: UIImage, nameid: String){
       
        
        
        let vc = AccountViewController()
       // print(id)
        vc.profilePicture = profilePicture
        vc.name = name
        vc.nameID = nameid
        let navController = UINavigationController(rootViewController: vc)
        
        present(navController, animated: true, completion: nil)
        
//      let navController = UINavigationController(rootViewController: vc)
////
//        present(navController, animated: true, completion: nil)
        
//        navigationController?.pushViewController(vc, animated: true)
    }
}
extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}


extension UIView {
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}



