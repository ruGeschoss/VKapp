//
//  NetworkManager.swift
//  VKapp
//
//  Created by Alexander Andrianov on 11.02.2021.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift
import PromiseKit

final class NetworkManager {
  
  private static let alamoFireSession: Alamofire.Session = {
    let configuration = URLSessionConfiguration.default
    configuration.allowsCellularAccess = false
    let session = Alamofire.Session(configuration: configuration)
    
    return session
  }()
  
  private static let realm = RealmManager.shared
}

// MARK: - Load Friends
extension NetworkManager {
  
  static func loadFriendsSJ(
    forUser: String?,
    completion: @escaping () -> Void) {
    
    let target = forUser ?? Session.shared.userId
    let baseUrl = "https://api.vk.com"
    let path = "/method/friends.get"
    let params: Parameters = [
      "access_token": Session.shared.token,
      "user_id": target,
      "fields": "photo_50",
      "v": "5.92"
    ]
    
    let request = NetworkManager.alamoFireSession
      .request(baseUrl + path, method: .get, parameters: params)
    
    let requestOperation = RequestDataOperation(
      request: request, forUser: target)
    let parseOperation = ParseDataOperation()
    let savingOperation = SavingToRealmOperation()
    parseOperation.addDependency(requestOperation)
    savingOperation.addDependency(parseOperation)
    
    let requestQueue = OperationQueue()
    requestQueue.addOperation(requestOperation)
    requestQueue.addOperation(parseOperation)
    requestQueue.addOperation(savingOperation)
    
    savingOperation.completionBlock = {
      completion()
    }
  }
}

// MARK: - Load Photos
extension NetworkManager {
  
  /// With album ID
  static func loadPhotos(
    ownerId: String?,
    albumId: String,
    offset: Int?,
    count: Int,
    completion: @escaping ([Photos]) -> Void) {
    
    let baseUrl = "https://api.vk.com"
    let path = "/method/photos.get"
    let params: Parameters = [
      "access_token": Session.shared.token,
      "owner_id": ownerId ?? Session.shared.userId,
      "album_id": albumId,
      "offset": offset ?? 0,
      "count": count,
      "rev": 1,
      "v": "5.92"
    ]
    
    NetworkManager.alamoFireSession
      .request(baseUrl + path, method: .get, parameters: params)
      .responseJSON { (response) in
      switch response.result {
      case .success(let data):
        let json = JSON(data)
        let response = json["response"]["items"].arrayValue
        let photos = response.map { Photos(from: $0) }
        completion(photos)
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
  /// All albums of user by ID
  static func loadAlbums(
    ownerId: String?,
    completion: @escaping ([Album]) -> Void) {
    
    let baseUrl = "https://api.vk.com"
    let path = "/method/photos.getAlbums"
    let params: Parameters = [
      "access_token": Session.shared.token,
      "owner_id": ownerId ?? Session.shared.userId,
      "v": "5.92"
    ]
    
    NetworkManager.alamoFireSession
      .request(baseUrl + path, method: .get, parameters: params)
      .responseJSON { (response) in
      switch response.result {
      case .success(let data):
        let json = JSON(data)
        let response = json["response"]["items"].arrayValue
        let albums = response.map { Album(from: $0) }
        completion(albums)
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
  /// All photos of user by ID
  static func loadPhotosSJ(
    ownerId: String,
    completion: @escaping () -> Void) {
    
    let baseUrl = "https://api.vk.com"
    let path = "/method/photos.getAll"
    let params: Parameters = [
      "access_token": Session.shared.token,
      "owner_id": ownerId,
      "v": "5.92"
    ]
    
    NetworkManager.alamoFireSession
      .request(baseUrl + path, method: .get, parameters: params)
      .responseJSON { (response) in
      switch response.result {
      case .success(let data):
        let json = JSON(data)
        let response = json["response"]["items"].arrayValue
        let photos = response.map { Photos(from: $0) }
        photos.forEach { $0.ownerId = ownerId }
        try? realm?.add(objects: photos)
        completion()
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
}

// MARK: - Load User Profile
extension NetworkManager {
  
  static func getProfileDataSJ() {
    
    let baseUrl = "https://api.vk.com"
    let path = "/method/account.getProfileInfo"
    let params: Parameters = [
      "access_token": Session.shared.token,
      "v": "5.92"
    ]
    NetworkManager.alamoFireSession
      .request(baseUrl + path, method: .get, parameters: params)
      .responseJSON { (response) in
      switch response.result {
      case .success(let data):
        let json = JSON(data)
        let user = ProfileSJ(from: json["response"])
        try? realm?.add(object: user)
        Session.shared.userName = user.firstName
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
}

// MARK: - Load Groups
extension NetworkManager {
  
  static func loadGroupsSJ(
    forUserId: String?, completion: @escaping () -> Void) {
    let target = forUserId ?? Session.shared.userId
    
    firstly {
      requestGroups(target: target)
    }.then { (data) in
      parseGroups(target: target, fromData: data)
    }.done { (groups) in
      storeToRealm(groups: groups)
    }.catch { (error) in
      print(error.localizedDescription)
    }.finally {
      completion()
      #if DEBUG
      print("NM.loadGroupsSJ successfully finished tasks")
      #endif
    }
  }
  
  private static func requestGroups(
    target: String) -> Promise<Data> {
    let (promise, resolver) = Promise<Data>.pending()
    let baseUrl = "https://api.vk.com"
    let path = "/method/groups.get"
    let params: Parameters = [
      "access_token": Session.shared.token,
      "user_id": target,
      "extended": 1,
      "v": "5.92"
    ]
    
    Self.alamoFireSession
      .request(baseUrl + path, method: .get,
               parameters: params)
      .response { response in
        switch response.result {
        case .success(let data):
          if let data = data {
            resolver.fulfill(data)
          }
        case .failure(let error):
          resolver.reject(error)
        }
      }
    return promise
  }
  
  private static func parseGroups(
    target: String,
    fromData: Data) -> Promise<[Group]> {
    let promise = Promise<[Group]> { resolver in
      let json = JSON(fromData)
      let response = json["response"]["items"].arrayValue
      let groups = response.map { Group(from: $0) }
      groups.forEach { $0.forUserId = target }
      resolver.fulfill(groups)
    }
    return promise
  }
  
  private static func storeToRealm(groups: [Group]) {
    do {
      try realm?.add(objects: groups)
    } catch {
      print(error.localizedDescription)
    }
  }
}

// MARK: - Search Groups
extension NetworkManager {
  
  static func searchGroupSJ(
    searchText: String?, completion: @escaping ([Group]) -> Void) {
    let text = searchText ?? " "
    
    firstly {
      requestGroupSearch(searchText: text)
    }.then { (data) in
      parseGroups(target: "", fromData: data)
    }.done(on: .main) { (groups) in
      completion(groups)
    }.catch { (error) in
      print(error.localizedDescription)
    }
    
  }
  
  private static func requestGroupSearch(searchText: String) -> Promise<Data> {
    let (promise, resolver) = Promise<Data>.pending()
    let baseUrl = "https://api.vk.com"
    let path = "/method/groups.search"
    let params: Parameters = [
      "access_token": Session.shared.token,
      "q": searchText,
      "type": "group",
      "sort": "0",
      "count": "50",
      "v": "5.92"
    ]
    
    Self.alamoFireSession
      .request(baseUrl + path, method: .get,
               parameters: params)
      .response { response in
        switch response.result {
        case .success(let data):
          if let data = data {
            resolver.fulfill(data)
          }
        case .failure(let error):
          resolver.reject(error)
        }
      }
    return promise
  }
}

// MARK: - Get Single Photo Data
extension NetworkManager {
  
  static func getPhotoDataFromUrl(
    url: String,
    completion: @escaping (Data) -> Void) {
    
    NetworkManager.alamoFireSession
      .request(url, method: .get)
      .responseData { (response) in
      guard let data = response.data else { return }
      completion(data)
    }
  }
}
