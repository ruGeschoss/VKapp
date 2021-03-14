//
//  GroupFirebase.swift
//  VKapp
//
//  Created by Alexander Andrianov on 12.03.2021.
//

import Foundation
import Firebase

class GroupFirebase {
    var groupId: String
    var groupName: String
    var groupAvatar: String
    
    var ref: DatabaseReference?
    
    init(groupId: String,
         groupName: String,
         groupAvatar: String) {
        
        self.groupId = groupId
        self.groupName = groupName
        self.groupAvatar = groupAvatar
        
        self.ref = nil
    }
    
    //From Firebase Database
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
              let groupId = value["groupId"] as? String,
              let groupName = value["groupName"] as? String,
              let groupAvatar = value["groupAvatar"] as? String else { return nil }
        
        self.groupId = groupId
        self.groupName = groupName
        self.groupAvatar = groupAvatar
        
        self.ref = snapshot.ref
    }
    
    // From Firebase Firestore
    init?(dict: [String: Any]) {
        guard let groupId = dict["groupId"] as? String,
              let groupName = dict["groupName"] as? String,
              let groupAvatar = dict["groupAvatar"] as? String else { return nil }
        
        self.groupId = groupId
        self.groupName = groupName
        self.groupAvatar = groupAvatar
        
        self.ref = nil
    }
    
    //Convert from Group
    convenience init(fromGroup: Group) {
        let groupId = fromGroup.groupId
        let groupName = fromGroup.groupName
        let groupAvatar = fromGroup.groupAvatarSizes.first!
        
        self.init(groupId: groupId,
                  groupName: groupName,
                  groupAvatar: groupAvatar)
    }
    
    //To Firebase Database
    func toAnyObj() -> [String: Any] {
        [
            "groupId": groupId,
            "groupName": groupName,
            "groupAvatar": groupAvatar
        ]
    }
    
}
