
import Foundation
class Post {
    var caption: String
    var imageUrl: String
    var usersName: String
    var location: String
    var numberoflikes: Int
    var likedby: Bool
    var postID: String
    var postCount: Int
    var audio64: String
    var posttime: TimeInterval
    var likerarray: Array<User2>
    var likersstring: String
    var numberofcomments: Int
    var global: Bool
    var postorevent: String
    var timeStartString: String
    var timeEndString: String
    var displayName: String
    var profImg: String
    var Score: Int
    var Spaces: Int
    init(captionText: String, photoURLString: String, USERNAME: String, locationText: String, likes: Int, likedbyme: Bool, postid: String, postcount: Int, Audio64: String, postTime: TimeInterval,  likerArray: Array<User2>,likersString: String, numberOfComments: Int, Global: Bool, postOrEvent:String, timestartstring: String, timeendstring: String, displayname: String, profimg: String, score: Int, spaces: Int){
        
   // init(captionText: String, photoURLString: String){
      caption = captionText
      imageUrl = photoURLString
      usersName = USERNAME
      location = locationText
      numberoflikes = likes
      likedby = likedbyme
      postID = postid
      postCount = postcount
      audio64 = Audio64
      posttime = postTime
      likerarray = likerArray
        likersstring = likersString
        numberofcomments = numberOfComments
        global = Global
        postorevent = postOrEvent
        timeStartString = timestartstring
        timeEndString = timeendstring
        displayName = displayname
        profImg = profimg
        Score = score;
        Spaces = spaces;
    }
}
