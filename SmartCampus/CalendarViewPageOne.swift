//
//  PostsViewController.swift
//  SmartCampus
//
//  Created by Tommy Chavez on 1/9/19.
//  Copyright © 2019 Tommy Chavez. All rights reserved.
//
import UIKit

class PostsViewController: UIViewController, CalendarCallBack {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var selectedDate = Date()
    
    @IBOutlet weak var NavBAR: UINavigationItem!
    @IBAction func showCalendar(_ sender: UIButton){
        let CalendarViewController = self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        CalendarViewController.modalPresentationStyle = .overCurrentContext
        CalendarViewController.delegate = self
        CalendarViewController.selectedDate = selectedDate
        self.present(CalendarViewController, animated: false, completion: nil)
    }
    
    func didSelectDate(date: Date) {
        selectedDate = date
        dateLabel.isHidden = false
        
        dateLabel.text = date.getTitleDateFC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavBAR.title = "May 5, 2019"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
