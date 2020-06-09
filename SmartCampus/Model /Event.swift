//
//  Event.swift
//  SmartCampus
//
//  Created by Tommy Chavez on 7/12/19.
//  Copyright © 2019 Tommy Chavez. All rights reserved.
//

import Foundation
class  Event {
    var endDate: String
    //let captionText = "Caption"
    var eventDescription: String
   
    var eventTitle: String
    var startDate: String
    var posterId: String
    var profileUrl: String
    var posterUsername: String
    var timeStartString: String
    var timeEndString: String
    var Locations: String
    var DescriptionCount: Int
    var EventCount: Int
    var DateString: String
    
    init(enddate: String, eventdescription: String, eventtitle: String, startdate: String, posterid: String, profileurl: String, timestartstring: String, timeendstring: String,
         posterusername: String, locations: String,descriptioncount: Int, eventcount: Int, datestring: String){
        // init(captionText: String, photoURLString: String){
        endDate = enddate
        eventDescription = eventdescription
        eventTitle = eventtitle
        startDate = startdate
        posterId = posterid
        profileUrl = profileurl
        posterUsername = posterusername
        timeStartString = timestartstring
        timeEndString = timeendstring
        Locations = locations
        DescriptionCount = descriptioncount
        EventCount = eventcount
        DateString = datestring
    }
}
