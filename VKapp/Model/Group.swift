//
//  Group.swift
//  VKapp
//
//  Created by Alexander Andrianov on 19.02.2021.
//

import Foundation
import SwiftyJSON
import RealmSwift

final class Group: Object, Decodable {
  @objc dynamic var groupId: String = ""
  @objc dynamic var groupName: String = ""
  @objc dynamic var screenName: String = ""
  @objc dynamic var isClosed: Bool = false
  @objc dynamic var type: String = ""
  @objc dynamic var isAdmin: Bool = false
  @objc dynamic var isMember: Bool = false
  @objc dynamic var isAdvertiser: Bool = false
  @objc dynamic var forUserId: String = ""
  var groupAvatarSizes = List<String>()
  var groupAvatarData = List<Data>()
  
  convenience init (from json: JSON) {
    self.init()
    
    let groupId = json["id"].stringValue
    let groupName = json["name"].stringValue
    let screenName = json["screen_name"].stringValue
    let isClosed = json["is_closed"].intValue
    let type = json["type"].stringValue
    let isAdmin = json["is_admin"].intValue
    let isMember = json["is_member"].intValue
    let isAdvertiser = json["is_advertiser"].intValue
    let groupAvaS = json["photo_50"].stringValue
    let groupAvaM = json["photo_100"].stringValue
    let groupAvaL = json["photo_200"].stringValue
    
    self.groupId = groupId
    self.groupName = groupName
    self.screenName = screenName
    self.isClosed = isClosed == 1
    self.type = type
    self.isAdmin = isAdmin == 1
    self.isMember = isMember == 1
    self.isAdvertiser = isAdvertiser == 1
    self.groupAvatarSizes.append(groupAvaS)
    self.groupAvatarSizes.append(groupAvaM)
    self.groupAvatarSizes.append(groupAvaL)
  }
  
  override static func primaryKey() -> String? {
    "groupId"
  }
}

extension Group: NewsOwner {
  var ownerName: String {
    groupName
  }
  
  var ownerAvatarURL: String {
    groupAvatarSizes.first!
  }
  
  var ownerId: String {
    groupId
  }
}
