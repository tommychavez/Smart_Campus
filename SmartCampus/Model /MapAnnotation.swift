//
//  MapAnnotation.swift
//  SmartCampus
//
//  Created by Tommy Chavez on 7/5/19.
//  Copyright © 2019 Tommy Chavez. All rights reserved.
//
import UIKit
import MapKit

class PointAnnotation : MKPointAnnotation {
   
    var personlocation: Bool
    var userid: String
    var userimage: String
    var username: String
   // var image: UIImage
   // var md: String
    
    init(personLocation: Bool, userId: String, userImage: String, userName: String ) {
        personlocation = personLocation
        userid = userId
        userimage = userImage
        username = userName
        
       
      //  self.image = UIImage(named: "annotation.png")!
        
    }
}
