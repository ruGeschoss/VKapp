//
//  Profile.swift
//  VKapp
//
//  Created by Alexander Andrianov on 19.02.2021.
//

import Foundation
import SwiftyJSON
import RealmSwift

class ProfileSJ: Object, Decodable {
  @objc dynamic var userId: String = ""
  @objc dynamic var firstName: String = ""
  @objc dynamic var lastName: String = ""
  @objc dynamic var city: String? = ""
  
  convenience init(from json: JSON) {
    self.init()
    
    let userId = json["id"].stringValue
    let firstName = json["first_name"].stringValue
    let lastName = json["last_name"].stringValue
    let city = json["home_town"].stringValue
    
    self.userId = userId
    self.firstName = firstName
    self.lastName = lastName
    self.city = city
  }
  
  override static func primaryKey() -> String? {
    "userId"
  }
}
