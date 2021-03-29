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
  
  @objc dynamic var firstName: String = ""
  @objc dynamic var userId: String = ""
  @objc dynamic var lastName: String = ""
  @objc dynamic var canAccessClosed: Bool = false
  @objc dynamic var isClosed: Bool = false
  @objc dynamic var photo: String = ""
  @objc dynamic var trackCode: String = ""
  @objc dynamic var photoData: Data?
  @objc dynamic var forUser: String = ""
  
  convenience init(from json: JSON) {
    self.init()
  
    let firstName = json["first_name"].stringValue
    let userId = json["id"].stringValue
    let lastName = json["last_name"].stringValue
    let canAccessClosed = json["can_access_closed"].boolValue
    let isClosed = json["is_closed"].boolValue
    let photo = json["photo_50"].stringValue
    let trackCode = json["track_code"].stringValue
    
    self.firstName = firstName
    self.userId = userId
    self.lastName = lastName
    self.canAccessClosed = canAccessClosed
    self.isClosed = isClosed
    self.photo = photo
    self.trackCode = trackCode
  }
  
  override static func primaryKey() -> String? {
    "userId"
  }
  
}
