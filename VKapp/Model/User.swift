//
//  User.swift
//  VKapp
//
//  Created by Alexander Andrianov on 16.02.2021.
//

import Foundation
import SwiftyJSON

class UserSJ {
    let id: String
    let firstName: String
    let lastName: String
    let photo: String
    
    init(from json: JSON) {
        let userId = json["id"].stringValue
        self.id = userId
        
        let firstName = json["first_name"].stringValue
        self.firstName = firstName
        
        let lastName = json["last_name"].stringValue
        self.lastName = lastName
        
        let photo = json["photo_50"].stringValue
        self.photo = photo
    }
    
}

//struct VKResponseAllFriends: Codable {
//    var response: Response
//}
//
//struct Response: Codable {
//    var friendsCount: Int
//    var friends: [User]
//    
//    enum CodingKeys: String, CodingKey {
//        case friendsCount = "count"
//        case friends = "items"
//    }
//}
//
//struct User: Codable {
//    var id: String
//    var firstName: String
//    var lastName: String
//    var photo: String
//    
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case photo = "photo_50"
//    }
//    
//    //MARK:- Changing id's type from Int to String
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        let id = try container.decode(Int.self, forKey: .id)
//        let stringId = "\(id)"
//        
//        let firstName = try container.decode(String.self, forKey: .firstName)
//        let lastName = try container.decode(String.self, forKey: .lastName)
//        let photo = try container.decode(String.self, forKey: .photo)
//        
//        self.init(id: stringId, firstName: firstName, lastName: lastName, photo: photo)
//    }
//    
//    init(id: String, firstName: String, lastName: String, photo: String) {
//        self.id = id
//        self.firstName = firstName
//        self.lastName = lastName
//        self.photo = photo
//    }
//    
//    //MARK:- **********************
//}
