//
//  NewsPostModel.swift
//  VKapp
//
//  Created by Alexander Andrianov on 26.03.2021.
//

import Foundation

final class NewsPostModel {
  
  var sourceId: Int  // source_id : int
  var date: Int     // date : int
  var postType: String // post_type : str
  var text: String    // text : str
  var markedAsAds: Int // marked_as_ads : 0 1
  
  // comments
  var comments: [String: Int] // comments: [str: int]
  var commentscount: Int // count: int
  var commentscanPost: Int // can_post: int 0 1
  
  //
  
  // attachments
  var attachments: [Any] // attachments : [Any] /// [{}]
  var type: String // type : str
  
  /// photo
  var photo: [String: Any] // photo : [Str: Any]
  var photoalbumId: Int // album_id : int
  var photodate: Int // date: int
  var photoid: Int // id: int
  var photoownerId: Int // owner_id: int
  var photopostId: Int // post_id: int
  
  ////  photosizes
  var photosizes: [Any] // sizes: [Any] /// [{}]
  var photosizesType: [String: Any] // each photo
  var photoSizesHeight: Int // height: Int
  var photoSizesWidth: Int // hidth: Int
  var photoSizesUrl: String // url: Str
  
  
  init() {
  }
  
  var a = [
    
    "comments": {
      "count": 0,
      "can_post": 1
    },
    "likes": {
      "count": 18,
      "user_likes": 0,
      "can_like": 1,
      "can_publish": 1
    },
    "reposts": {
      "count": 0,
      "user_reposted": 0
    },
    "views": {
      "count": 556
    },
    "post_id": 5122447,
    "type": "post"
  }
]
}
