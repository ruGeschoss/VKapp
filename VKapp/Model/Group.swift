//
//  Group.swift
//  VKapp
//
//  Created by Alexander Andrianov on 19.02.2021.
//

import Foundation
import SwiftyJSON

class Group {
    let groupId: String
    let groupName: String
    let groupAvatarSizes: [String]
    
    init (from json: JSON) {
        let groupId = json["id"].stringValue
        self.groupId = groupId
        
        let groupName = json["name"].stringValue
        self.groupName = groupName
        
        let groupAvaS = json["photo_50"].stringValue
        let groupAvaM = json["photo_100"].stringValue
        let groupAvaL = json["photo_200"].stringValue
        self.groupAvatarSizes = [groupAvaS, groupAvaM, groupAvaL]
    }
    
}
