//
//  DropDownViewController.swift
//  SmartCampus
//
//  Created by Tommy Chavez on 4/10/19.
//  Copyright © 2019 Tommy Chavez. All rights reserved.
//

import UIKit



class DropDownViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var location = "San Jose State University"
    var locationSet = false
    @IBOutlet weak var Popupview: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var names: [String] = ["ATM Machines", "Charles W. Davidson Building","CVB","Martin Luther King Jr Library","San Jose State University (default)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Apply radius to Popupview
        Popupview.layer.cornerRadius = 10
        Popupview.layer.masksToBounds = true
       // tableView.delegate = self
   
              AppUtility.lockOrientation(.portrait)
        }
            
            override func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)

                // Don't forget to reset when view is being removed
                AppUtility.lockOrientation(.all)
            }
    

    
    // Returns count of items in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.names.count;
    }
    
    
    // Select item from tableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(names[indexPath.row])
        location = names[indexPath.row]
       
        print(location)
        
        Shared.shared.companyName = names[indexPath.row]
        
    }
    
    //Assign values for tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
    
    // Close PopUp
//    @IBAction func closePopup(_ sender: Any) {
//        print(location)
//        dismiss(animated: true, completion: nil)
//    }
    }


