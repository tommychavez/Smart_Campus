//
//  practiceViewController.swift
//  SmartCampus
//
//  Created by Tomas Chavez on 8/8/19.
//  Copyright © 2019 Tommy Chavez. All rights reserved.
//

import UIKit

class practiceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
        let tableView2: UITableView = UITableView(frame: CGRect(x: 0, y: 250, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height));
    
    let tableView3: UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-250));
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView2)
        tableView2.register(newsCell.self, forCellReuseIdentifier: "postCell")
        tableView2.delegate = self
        tableView2.dataSource = self
        
        view.addSubview(tableView3)
        tableView3.register(newsCell.self, forCellReuseIdentifier: "postCell2")
        tableView3.delegate = self
        tableView3.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }
  
    func tableView( _ tableView:UITableView, numberOfRowsInSection section: Int)-> Int {
        if(tableView == tableView3){
            return 10
        }
        else if(tableView == tableView2){
            return 5
        }
    return 100
    }//how many cells
    
    
    
    func tableView(  _ tableView: UITableView, heightForRowAt indexPath: IndexPath)->CGFloat{
        
        return 80
        
       
    }
    
    func tableView(  _ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell{
        if(tableView == tableView2){
        var cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! newsCell
        cell.textLabel?.text = "tommy"
            return cell
        //  cell.backgroundColor = UIColor.gray
        }
        if(tableView == tableView3){
            
             var cell = tableView.dequeueReusableCell(withIdentifier: "postCell2", for: indexPath) as! newsCell
            cell.textLabel?.text = "MARCUS"
            return cell
        }
       var cell = tableView.dequeueReusableCell(withIdentifier: "postCell2", for: indexPath) as! newsCell
        return cell
    }
    
    

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
