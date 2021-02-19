//
//  Profile.swift
//  VKapp
//
//  Created by Alexander Andrianov on 19.02.2021.
//

import Foundation
import SwiftyJSON

class ProfileSJ {
    let id: String
    let firstName: String
    let lastName: String
    let city: String?
    
    init(from json: JSON) {
        let id = json["id"].stringValue
        self.id = id
        
        let firstName = json["first_name"].stringValue
        self.firstName = firstName
        
        let lastName = json["last_name"].stringValue
        self.lastName = lastName
        
        let city = json["home_town"].stringValue
        self.city = city
    }
}

//struct Profile: Codable {
//    let response: MyProfile
//}
//
//struct MyProfile: Codable {
//    let firstName: String
//    let id: Int
//    let lastName, homeTown, status, bdate: String
//    let bdateVisibility: Int
//    let city, country: City
//    let phone: String
//    let relation: Int
//    let screenName: String
//    let sex: Int
//
//    enum CodingKeys: String, CodingKey {
//        case firstName = "first_name"
//        case id
//        case lastName = "last_name"
//        case homeTown = "home_town"
//        case status, bdate
//        case bdateVisibility = "bdate_visibility"
//        case city, country, phone, relation
//        case screenName = "screen_name"
//        case sex
//    }
//}
//
//struct City: Codable {
//    let id: Int
//    let title: String
//}
