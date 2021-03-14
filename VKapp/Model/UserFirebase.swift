//
//  UserFirebase.swift
//  VKapp
//
//  Created by Alexander Andrianov on 12.03.2021.
//

import Foundation
import Firebase

class UserFirebase {
    let id: String
    let firstName: String
    let lastName: String
    let photo: String
    
    let ref: DatabaseReference?
    
    init(id: String,
         firstName: String,
         lastName: String,
         photo: String) {
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.photo = photo
        
        self.ref = nil
    }
    
    //From Firebase Database
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
              let id = value["id"] as? String,
              let firstName = value["firstName"] as? String,
              let lastName = value["lastName"] as? String,
              let photo = value["photo"] as? String else { return nil }
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.photo = photo
        
        self.ref = snapshot.ref
    }
    
    // From Firebase Firestore
    init?(dict: [String: Any]) {
        guard let id = dict["id"] as? String,
              let firstName = dict["firstName"] as? String,
              let lastName = dict["lastName"] as? String,
              let photo = dict["photo"] as? String else { return nil }
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.photo = photo
        
        self.ref = nil
    }
    
    //Convert from UserSJ
    convenience init(usermodel: UserSJ) {
        let id = usermodel.id
        let firstName = usermodel.firstName
        let lastName = usermodel.lastName
        let photo = usermodel.photo
        
        self.init(id: id,
                  firstName: firstName,
                  lastName: lastName,
                  photo: photo)
    }
    
    //To Firebase Database
    func toAnyObj() -> [String: Any] {
        [
            "id": id,
            "firstName": firstName,
            "lastName": lastName,
            "photo": photo
        ]
    }
}
