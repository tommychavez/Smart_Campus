
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
 
    init(captionText: String, photoURLString: String, USERNAME: String, locationText: String, likes: Int, likedbyme: Bool, postid: String, postcount: Int, Audio64: String, postTime: TimeInterval){
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
    }
}
