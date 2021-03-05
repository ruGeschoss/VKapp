//
//  Group.swift
//  VKapp
//
//  Created by Alexander Andrianov on 19.02.2021.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Group: Object, Decodable {
    @objc dynamic var groupId: String = ""
    @objc dynamic var groupName: String = ""
    @objc dynamic var forUserId: String = ""
//    var groupAvatarSizes: [String] = []
    var groupAvatarSizes = List<String>()
    var groupAvatarData = List<Data>()
    
    convenience init (from json: JSON) {
        self.init()
        
        let groupId = json["id"].stringValue
        self.groupId = groupId
        
        let groupName = json["name"].stringValue
        self.groupName = groupName
        
        let groupAvaS = json["photo_50"].stringValue
        let groupAvaM = json["photo_100"].stringValue
        let groupAvaL = json["photo_200"].stringValue
//        self.groupAvatarSizes = [groupAvaS, groupAvaM, groupAvaL]
        self.groupAvatarSizes.append(groupAvaS)
        self.groupAvatarSizes.append(groupAvaM)
        self.groupAvatarSizes.append(groupAvaL)
        self.forUserId = forUserId
    }
    
    override static func primaryKey() -> String? {
        "groupId"
    }
    
}
