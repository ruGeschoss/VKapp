//
//  Comments.swift
//  VKapp
//
//  Created by Alexander Andrianov on 27.03.2021.
//

import Foundation
import SwiftyJSON

class Comments: Decodable {
  var count: Int = 0
  var canPost: Bool = false
  var groupsCanPost: Bool = false
  
  convenience init(from json: JSON) {
    self.init()
    
    let count = json["count"].intValue
    let canPost = json["can_post"].intValue
    let groupsCanPost = json["groups_can_post"].boolValue
    
    self.count = count
    self.canPost = canPost == 1
    self.groupsCanPost = groupsCanPost
  }
}
