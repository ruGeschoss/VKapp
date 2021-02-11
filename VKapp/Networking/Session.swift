//
//  Session.swift
//  VKapp
//
//  Created by Alexander Andrianov on 07.02.2021.
//

import Foundation

class Session {
    
    static let instance = Session()
    
    private init () {
    }
    
    var token = ""
    var userId = Int()
    var userName = ""
}
