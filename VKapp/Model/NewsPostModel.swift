//
//  NewsPostModel.swift
//  VKapp
//
//  Created by Alexander Andrianov on 26.03.2021.
//

import Foundation
import SwiftyJSON

final class NewsPostModel: Decodable {
  
  var sourceId: Int = 0
  var date: Int = 0
  var postType: String = ""
  var text: String = ""
  var markedAsAds: Bool = false
  var postId: Int = 0
  var isFavorite: Bool = false
  var type: String = ""
  var photoAttachments: [Photos] = []
  var comments: Comments = Comments()
  var likes: Likes = Likes()
  var reposts: Reposts = Reposts()
  var views: Views = Views()
  
  convenience init(from json: JSON) {
    self.init()
    
    let sourceId = json["source_id"].intValue
    let date = json["date"].intValue
    let postType = json["post_type"].stringValue
    let text = json["text"].stringValue
    let markedAsAds = json["marked_as_ads"].intValue
    let isFavorite = json["is_favorite"].boolValue
    let postId = json["post_id"].intValue
    let type = json["type"].stringValue
    
    #if DEBUG
    let attachments = json["attachments"].arrayValue
    if attachments.count != 0 {
      let photoAttachments = attachments.filter { (element) in
        element["type"] == "photo"
      }
      self.photoAttachments = photoAttachments
        .map { Photos(from: $0["photo"]) }
    }
    #endif
    let likes = json["likes"]
    let comments = json["comments"]
    let reposts = json["reposts"]
    let views = json["views"]
    
    self.sourceId = sourceId
    self.date = date
    self.postType = postType
    self.text = text
    self.markedAsAds = markedAsAds == 1
    self.isFavorite = isFavorite
    self.postId = postId
    self.type = type
    self.likes = Likes(from: likes)
    self.comments = Comments(from: comments)
    self.reposts = Reposts(from: reposts)
    self.views = Views(from: views)
  }
  
}
