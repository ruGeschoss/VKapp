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
  @objc dynamic var albumId: Int = 0
  @objc dynamic var datePosted: Int = 0
  @objc dynamic var photoId: String = ""
  @objc dynamic var ownerId: String = ""
  @objc dynamic var hasTags: Bool = false
  @objc dynamic var postId: Int = 0
  @objc dynamic var text: String = ""
  @objc dynamic var aspectRatio: Double = 0
  var imageUrl = List<String>()
  
  convenience init(from json: JSON) {
    self.init()
    
    let albumId = json["album_id"].intValue
    let datePosted = json["date"].intValue
    let photoId = json["id"].stringValue
    let ownerId = json["owner_id"].intValue
    let hasTags = json["has_tags"].boolValue
    let postId = json["post_id"].intValue
    let imageSizes = json["sizes"].arrayValue
    let text = json["text"].stringValue
    
    let height = imageSizes.last!["height"].doubleValue
    let width = imageSizes.last!["width"].doubleValue
    let aspectRatio = width / height
      
    imageSizes
      .map { $0["url"].stringValue }
      .forEach { self.imageUrl.append($0) }
    
    self.albumId = albumId
    self.datePosted = datePosted
    self.photoId = photoId
    self.ownerId = "\(ownerId)"
    self.hasTags = hasTags
    self.postId = postId
    self.text = text
    self.aspectRatio = aspectRatio
  }
  
  override static func primaryKey() -> String? {
    "photoId"
  }
}
