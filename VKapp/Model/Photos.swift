//
//  Photos.swift
//  VKapp
//
//  Created by Alexander Andrianov on 18.02.2021.
//

import Foundation
import SwiftyJSON
import RealmSwift

final class Photos: Object, Decodable {
  @objc dynamic var photoId: String = ""
  @objc dynamic var datePosted: Int = 0
  @objc dynamic var ownerId: String = ""
  var imageUrl = List<String>()
  
  convenience init(from json: JSON) {
    self.init()
    
    let photoId = json["id"].stringValue
    let datePosted = json["date"].intValue
    let imageSizes = json["sizes"].arrayValue
    imageSizes
      .map { $0["url"].stringValue }
      .forEach { self.imageUrl.append($0) }
    
    self.photoId = photoId
    self.datePosted = datePosted
  }
  
  override static func primaryKey() -> String? {
    "photoId"
  }
}
