//
//  Views.swift
//  VKapp
//
//  Created by Alexander Andrianov on 27.03.2021.
//

import Foundation
import SwiftyJSON

class Views: Decodable {
  var count: Int = 0
  
  convenience init(from json: JSON) {
    self.init()
    
    let count = json["count"].intValue
    self.count = count
  }
}
