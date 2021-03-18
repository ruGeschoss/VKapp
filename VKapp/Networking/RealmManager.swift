//
//  RealmManager.swift
//  VKapp
//
//  Created by Alexander Andrianov on 09.03.2021.
//

import RealmSwift

// class RealmManager {
//  
//  static let shared = RealmManager()
//  private let realm: Realm
//  
//  private init?() {
//    let configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
//    guard let realm = try? Realm(configuration: configuration) else { return nil }
//    self.realm = realm
//    
//    print(realm.configuration.fileURL ?? "")
//  }
//  
//  func add<T: Object>(object: T) throws {
//    try realm.write {
//      realm.add(object)
//    }
//  }
//  
//  func add<T: Object>(objects: [T]) throws {
//    try realm.write {
//      realm.add(objects, update: .all)
//    }
//  }
//  
//  func getObjects<T: Object>() -> Results<T> {
//    return realm.objects(T.self)
//  }
//  
//  func delete<T: Object>(object: T) throws {
//    try realm.write {
//      realm.delete(object)
//    }
//  }
//  
//  func deleteAll() throws {
//    try realm.write {
//      realm.deleteAll()
//    }
//  }
// }
