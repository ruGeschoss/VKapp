//
//  ProfileFirebase.swift
//  VKapp
//
//  Created by Alexander Andrianov on 13.03.2021.
//

import Foundation
import Firebase

class ProfileFirebase {
    var id: String
    var firstName: String
    var lastName: String
    var city: String
    
    var ref: DatabaseReference?
    
    init(id: String,
         firstName: String,
         lastName: String,
         city: String) {
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.city = city
        
        self.ref = nil
    }
    
    //From Firebase Database
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
              let id = value["id"] as? String,
              let firstName = value["firstName"] as? String,
              let lastName = value["lastName"] as? String,
              let city = value["city"] as? String else { return nil }
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.city = city
        
        self.ref = snapshot.ref
    }
    
    // From Firebase Firestore
    init?(dict: [String: Any]) {
        guard let id = dict["id"] as? String,
              let firstName = dict["firstName"] as? String,
              let lastName = dict["lastName"] as? String,
              let city = dict["city"] as? String else { return nil }
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.city = city
        
        self.ref = nil
    }
    
    //Convert from ProfileSJ
    convenience init(fromProfile: ProfileSJ) {
        let id = fromProfile.id
        let firstName = fromProfile.firstName
        let lastName = fromProfile.lastName
        let city = fromProfile.city ?? ""
        
        self.init(id: id,
                  firstName: firstName,
                  lastName: lastName,
                  city: city)
    }
    
    //To Firebase Database
    func toAnyObj() -> [String: Any] {
        [
            "id": id,
            "firstName": firstName,
            "lastName": lastName,
            "city": city
        ]
    }
}
