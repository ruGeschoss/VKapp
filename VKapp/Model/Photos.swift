//
//  Photos.swift
//  VKapp
//
//  Created by Alexander Andrianov on 18.02.2021.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Photos: Object, Decodable {
    @objc dynamic var photoId: String = ""
    @objc dynamic var datePosted: Int = 0
    @objc dynamic var ownerId: String = ""
//    var imageUrl: [String] = []
    var imageUrl = List<String>()
    
    convenience init(from json: JSON) {
        self.init()
        
        let photoId = json["id"].stringValue
        self.photoId = photoId
        
        let datePosted = json["date"].intValue
        self.datePosted = datePosted
        
        let imageSizes = json["sizes"].arrayValue
//        self.imageUrl = imageSizes.map { $0["url"].stringValue }
        let tmpArray = imageSizes.map { $0["url"].stringValue }
        tmpArray.forEach({ self.imageUrl.append($0) })
        
        self.ownerId = ownerId
    }
    
    override static func primaryKey() -> String? {
        "photoId"
    }
}

//struct VKResponseAllPhotos: Codable {
//    let response: PhotoResponse
//}
//
//// MARK: - Response
//struct PhotoResponse: Codable {
//    let count: Int
//    let items: [Photo]
//}
//
//// MARK: - Item
//struct Photo: Codable {
//    let photoId: Int
//    let datePosted: Int
//    let photoSizes: [Size]  // contains width, height, url, size letter
//
//    enum CodingKeys: String, CodingKey {
//        case photoId = "id"
//        case datePosted = "date"
//        case photoSizes = "sizes"
//    }
//}
//
//// MARK: - Size 
//struct Size: Codable {
//    let imageUrl: String
//
//    enum CodingKeys: String, CodingKey {
//        //case x,m,s - photo sizes (VK documetation)
//        case imageUrl = "url"
//    }
//}
