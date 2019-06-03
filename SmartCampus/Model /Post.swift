
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
    init(captionText: String, photoURLString: String, USERNAME: String, locationText: String, likes: Int, likedbyme: Bool, postid: String, postcount: Int){
   // init(captionText: String, photoURLString: String){
      caption = captionText
      imageUrl = photoURLString
      usersName = USERNAME
      location = locationText
      numberoflikes = likes
      likedby = likedbyme
      postID = postid
      postCount = postcount
    }
}
