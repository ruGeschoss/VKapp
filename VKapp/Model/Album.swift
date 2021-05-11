//
//  Album.swift
//  VKapp
//
//  Created by Alexander Andrianov on 10.05.2021.
//

import Foundation
import SwiftyJSON

final class Album: Decodable {
  
  var albumId: String = ""
  var thumbId: String = ""
  var ownerId: String = ""
  var title: String = ""
  var description: String = ""
  var dateCreated: Int = 0
  var dateUpdated: Int = 0
  var photosCount: Int = 0
  
  convenience init(from json: JSON) {
    self.init()
  
    let albumId = json["id"].intValue
    let thumbId = json["thumb_id"].intValue
    let ownerId = json["owner_id"].intValue
    let title = json["title"].stringValue
    let description = json["description"].stringValue
    let dateCreated = json["created"].intValue
    let dateUpdated = json["updated"].intValue
    let size = json["size"].intValue
    
    self.albumId = String(albumId)
    self.thumbId = String(thumbId)
    self.ownerId = String(ownerId)
    self.title = title
    self.description = description
    self.dateCreated = dateCreated
    self.dateUpdated = dateUpdated
    self.photosCount = size
  }
}

extension Album: Hashable {
  static func == (lhs: Album, rhs: Album) -> Bool {
    lhs.albumId == rhs.albumId
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(albumId + ownerId)
  }
}
