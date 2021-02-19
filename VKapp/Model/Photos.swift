//
//  Photos.swift
//  VKapp
//
//  Created by Alexander Andrianov on 18.02.2021.
//

import Foundation
import SwiftyJSON

class Photos {
    let photoId: String
    let datePosted: Int
    let imageUrl: [String]
    
    init(from json: JSON) {
        let photoId = json["id"].stringValue
        self.photoId = photoId
        
        let datePosted = json["date"].intValue
        self.datePosted = datePosted
        
        let imageSizes = json["sizes"].arrayValue
        self.imageUrl = imageSizes.map { $0["url"].stringValue }
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
