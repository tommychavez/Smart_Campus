//
//  PostsViewController.swift
//  SmartCampus
//
//  Created by Tommy Chavez on 1/9/19.
//  Copyright © 2019 Tommy Chavez. All rights reserved.
//
import UIKit
import Firebase
import FirebaseDatabase //just added

class PostsViewController: UIViewController, CalendarCallBack, UITableViewDelegate{
    
    var events = [Event]()
    @IBOutlet weak var dateLabel: UILabel!
    let cellId = "PostCell"
    var selectedDate = Date()
    let tableView: UITableView = UITableView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 700));
    @IBOutlet weak var NavBAR: UINavigationItem!
 
    var currentDay: String?
    
     
    @IBAction func pressedcald(_ sender: Any) {
        print("PRESSED")
        //showCalendar( nil)
        let CalendarViewController = self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        CalendarViewController.modalPresentationStyle = .overCurrentContext
        CalendarViewController.delegate = self
        CalendarViewController.selectedDate = selectedDate
        self.present(CalendarViewController, animated: false, completion: nil)
        
    }
    
    
    
    
    @IBAction func showCalendar(_ sender: UIButton?){
//        let CalendarViewController = self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
//        CalendarViewController.modalPresentationStyle = .overCurrentContext
//        CalendarViewController.delegate = self
//        CalendarViewController.selectedDate = selectedDate
//        self.present(CalendarViewController, animated: false, completion: nil)
    }
    
    func didSelectDate(date: Date) {
        selectedDate = date
        dateLabel.isHidden = false
        
        dateLabel.text = date.getTitleDateFC()
    }
    
    override func viewDidLoad() {
        let date = Date()
        let  dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL dd, YYYY"
        
        currentDay =  dateFormatter.string(from: date)
        
        super.viewDidLoad()
        //NavBAR.title = "May 5, 2019"
            loadPosts()
        print("HERE")
        self.view.addSubview(tableView)
        tableView.register(newsCell.self, forCellReuseIdentifier: cellId)
        
        tableView.dataSource = self
        tableView.delegate = self
       // tableView.rowHeight = 450
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func loadPosts() {
        var current = "noday"
  Database.database().reference().child("events").observe(.childAdded) {(snapshot: DataSnapshot) in
            //print("HERE")
            let postid = snapshot.key
    print(postid)
   
            //  print(postid)
            Database.database().reference().child("events").child(postid).observe(.childAdded) {(snapshot: DataSnapshot) in
               
                if let dict = snapshot.value as? [String: Any]{
                    let enddate = dict["EndDate"] as! String
                    //let captionText = "Caption"
                    let eventdescription = dict["EventDescription"] as! String
                    //backgroundTableCellSize = 400
                    let eventtitle = dict["EventTitle"] as! String
                    let startdate = dict["StartDate"] as! String
                    print(startdate)
                    let posterid = dict["posterid"] as! String
                    let profileurl = dict["ProfileUrl"] as! String
                    let posterusername = dict["PosterUsername"] as! String
                    let timeendstring =  dict["EndDateString"] as! String
                    let timestartstring = dict["StartTimeString"] as! String
                    let locations = dict["Locations"] as! String
                    let descriptioncount =  dict["DescriptionCount"] as! Int
                    let eventcount = dict["EventCount"] as! Int
                    let datestring = dict["DateString"] as! String
                    //current = datestring
                    
                    
                    if(current != datestring && datestring != self.currentDay ){
                        print(datestring)
                        current = datestring
                        let event = Event(
                            enddate: "", eventdescription:"justadate",
                            eventtitle:"justadate",
                            startdate:"",
                            posterid:"",  profileurl: "", timestartstring: "", timeendstring: "",
                            posterusername: "", locations: "", descriptioncount: 0, eventcount: 0, datestring: datestring )
                        //self.events.insert(event, at: 0)
                        self.events.append(event)
                        
                    }
                    
                let event = Event(
                    enddate: enddate, eventdescription:eventdescription,
                    eventtitle:eventtitle,
                    startdate:startdate,
                    posterid:posterid,  profileurl: profileurl, timestartstring: timestartstring, timeendstring: timeendstring,
                    posterusername: posterusername, locations: locations, descriptioncount:descriptioncount, eventcount: eventcount, datestring: datestring )
                    //self.events.insert(event, at: 0)
                    self.events.append(event)
                    print("WE ARE HERE")
                    print(current)
                    print(datestring)
                  

                    DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
            
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    
    
}


extension PostsViewController: UITableViewDataSource {
    func tableView( _ tableView:UITableView, numberOfRowsInSection section: Int)-> Int {
        print(events.count)
        return events.count + 1
       // return 3
    }//how many cells
    
    
    func tableView(  _ tableView: UITableView, heightForRowAt indexPath: IndexPath)->CGFloat{
        if(indexPath.row == 0){
            return 50
        }
       else  if(events[indexPath.row-1].eventDescription == "justadate" && events[indexPath.row-1].eventTitle == "justadate" ){
            return 50
        }
        return 150
    }
    
    
    
    func tableView(  _ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell{

        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! newsCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
        //      print(posts.count)
        
        if(indexPath.row == 0){
            cell.textLabel?.text = currentDay
            cell.threedots.isHidden = true
            cell.commentButton.isHidden = true
            cell.likeButton.isHidden = true
        }
       else  if( events[indexPath.row-1].eventDescription == "justadate" && events[indexPath.row-1].eventTitle == "justadate"  ){
            cell.textLabel?.text = events[indexPath.row-1].DateString
            cell.threedots.isHidden = true
            cell.commentButton.isHidden = true
            cell.likeButton.isHidden = true
        }
        else { cell.nameButton.setTitle(events[indexPath.row-1].posterUsername, for: .normal)
        cell.profileImageViewTop.loadImageUsingCacheWithUrlString(urlString: events[indexPath.row-1].profileUrl)
       
        cell.DateStamp.text = (events[indexPath.row-1].timeStartString)
        cell.DateStamp2.text = (events[indexPath.row-1].timeEndString)
        cell.threedots.isHidden = true
        cell.locationButton.setTitle("@\(events[indexPath.row-1].Locations)", for: .normal)
        cell.postText.font = .boldSystemFont(ofSize: 15)
        cell.postText.text = events[indexPath.row-1].eventTitle
       cell.descriptionButt.frame.size.height = CGFloat(24)
        cell.descriptionButt.text = events[indexPath.row-1].eventDescription
        }
        return cell
    }
    
}


class calendarCell: UITableViewCell {
    //var buttonAct: ((Any) -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

