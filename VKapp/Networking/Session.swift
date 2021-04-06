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
  
  var tokenExpires = KeychainWrapper.standard.double(forKey: "tokenExpires") ?? 0 {
    didSet {
      KeychainWrapper.standard.set(tokenExpires, forKey: "tokenExpires")
    }
  }
  
  var userId = KeychainWrapper.standard.string(forKey: "userId") ?? "" {
    didSet {
      KeychainWrapper.standard.set(userId, forKey: "userId")
    }
  }
  
  var userName = KeychainWrapper.standard.string(forKey: "userName") ?? "" {
    didSet {
      KeychainWrapper.standard.set(userName, forKey: "userName")
    }
  }
}
