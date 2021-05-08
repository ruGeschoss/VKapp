//
//  Reposts.swift
//  VKapp
//
//  Created by Alexander Andrianov on 27.03.2021.
//

import Foundation
import SwiftyJSON

class Reposts: Decodable {
  var count: Int = 0
  var userReposted: Bool = false
  
  convenience init(from json: JSON) {
    self.init()
    
    let count = json["count"].intValue
    let userReposted = json["user_reposted"].intValue
    
    self.count = count
    self.userReposted = userReposted == 1
  }
}
