//
//  User.swift
//  VKapp
//
//  Created by Alexander Andrianov on 16.02.2021.
//

import Foundation
import SwiftyJSON
import RealmSwift

final class UserSJ: Object, Decodable {
  @objc dynamic var userId: String = ""
  @objc dynamic var firstName: String = ""
  @objc dynamic var lastName: String = ""
  @objc dynamic var photo: String = ""
  @objc dynamic var photoData: Data?
  @objc dynamic var forUser: String = ""
  
  convenience init(from json: JSON) {
    self.init()
    
    let userId = json["id"].stringValue
    let firstName = json["first_name"].stringValue
    let lastName = json["last_name"].stringValue
    let photo = json["photo_50"].stringValue
    
    self.userId = userId
    self.firstName = firstName
    self.lastName = lastName
    self.photo = photo
  }
  
  override static func primaryKey() -> String? {
    "userId"
  }
  
}
