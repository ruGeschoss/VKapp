//
//  Likes.swift
//  VKapp
//
//  Created by Alexander Andrianov on 27.03.2021.
//

import Foundation
import SwiftyJSON

class Likes: Decodable {
  var count: Int = 0
  var userLikes: Bool = false
  var canLike: Bool = false
  var canPublish: Bool = false
  
  convenience init(from json: JSON) {
    self.init()
    
    let count = json["count"].intValue
    let userLikes = json["user_likes"].intValue
    let canLike = json["can_like"].intValue
    let canPublish = json["can_publish"].intValue
    
    self.count = count
    self.userLikes = userLikes == 1
    self.canLike = canLike == 1
    self.canPublish = canPublish == 1
  }
}
