//
//  FirebaseConfig.swift
//  VKapp
//
//  Created by Alexander Andrianov on 13.03.2021.
//

import Foundation

enum DatabaseType {
    case database, firestore
}

enum FirebaseConfig {
    static let databaseType = DatabaseType.firestore
}
