//
//  Session.swift
//  VKapp
//
//  Created by Alexander Andrianov on 07.02.2021.
//

import Foundation
import SwiftKeychainWrapper

class Session {
    
    static let shared = Session()
    
    private init () {
    }
    
    var token = KeychainWrapper.standard.string(forKey: "userToken") ?? "" {
        didSet {
            KeychainWrapper.standard.set(token, forKey: "userToken")
        }
    }
    
    var userId = UserDefaults.standard.string(forKey: "userId") ?? "" {
        didSet {
            UserDefaults.standard.set(userId, forKey: "userId")
        }
    }
    var userName = UserDefaults.standard.string(forKey: "userName") ?? "" {
        didSet {
            UserDefaults.standard.set(userName, forKey: "userName")
        }
    }
}
