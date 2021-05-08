//
//  NewsPhotoModel.swift
//  VKapp
//
//  Created by Alexander Andrianov on 26.03.2021.
//

import Foundation
import SwiftyJSON

final class NewsPhotoModel: Decodable {
  
  var sourceId: Int = 0
  var date: Int = 0
  var stringDate: String?
  var photosCount: Int = 0
  var photos: [Photos] = []
  var postId: Int = 0
  var type: String = ""
  
  convenience init(from json: JSON) {
    self.init()
    
    let sourceId = json["source_id"].intValue
    let date = json["date"].intValue
    let photos = json["photos"]["items"].arrayValue
    let photosCount = photos.count
    let photosArray = photos.map { Photos(from: $0) }
    let postId = json["post_id"].intValue
    let type = json["type"].stringValue
    
    self.sourceId = sourceId
    self.date = date
    self.photosCount = photosCount
    self.photos = photosArray
    self.postId = postId
    self.type = type
  }
}
