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

final class NetworkManager {
  
  private static let alamoFireSession: Alamofire.Session = {
    let configuration = URLSessionConfiguration.default
    configuration.allowsCellularAccess = false
    let session = Alamofire.Session(configuration: configuration)
    
    return session
  }()
  
  private static let realm = RealmManager.shared

  // MARK: Load Groups
  static func loadGroupsSJ(
    forUserId: String?,
    completion: @escaping () -> Void) {
    
    let target = forUserId ?? Session.shared.userId
    let baseUrl = "https://api.vk.com"
    let path = "/method/groups.get"
    let params: Parameters = [
      "access_token": Session.shared.token,
      "user_id": target,
      "extended": 1,
      "v": "5.92"
    ]
    
    NetworkManager.alamoFireSession
      .request(baseUrl + path, method: .get, parameters: params)
      .responseJSON { (response) in
      switch response.result {
      case .success(let data):
        let json = JSON(data)
        let response = json["response"]["items"].arrayValue
        let groups = response.map { Group(from: $0) }
        groups.forEach { $0.forUserId = target }
        try? realm?.add(objects: groups)
        completion()
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
  // MARK: Load Friends
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
    
    NetworkManager.alamoFireSession
      .request(baseUrl + path, method: .get, parameters: params)
      .responseJSON { (response) in
      switch response.result {
      case .success(let data):
        let json = JSON(data)
        let response = json["response"]["items"].arrayValue
        let friends = response
          .map { UserSJ(from: $0) }
          .filter { $0.lastName != "" }
        friends.forEach { $0.forUser = target }
        try? realm?.add(objects: friends)
        completion()
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
  // MARK: Load Photos
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
 
  // MARK: Load User Profile
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
  
  // MARK: Search Groups
  static func searchGroupSJ(
    searchText: String?,
    completion: ((Result<[Group], Error>) -> Void)? = nil) {
    
    let baseUrl = "https://api.vk.com"
    let path = "/method/groups.search"
    let params: Parameters = [
      "access_token": Session.shared.token,
      "q": searchText ?? " ",
      "type": "group",
      "sort": "0",
      "count": "50",
      "v": "5.92"
    ]
    
    NetworkManager.alamoFireSession
      .request(baseUrl + path,
               method: .get,
               parameters: params)
      .responseJSON { (response) in
      switch response.result {
      case .success(let data):
        let json = JSON(data)
        let response = json["response"]["items"].arrayValue
        let groups = response.map { Group(from: $0) }
        completion?(.success(groups))
      case .failure(let error):
        completion?(.failure(error))
      }
    }
  }
  
  // MARK: Get Single Photo Data
  static func getPhotoDataFromUrl(
    url: String,
    completion: @escaping (Data) -> Void) {
    
    NetworkManager.alamoFireSession
      .request(url,
               method: .get)
      .responseData { (response) in
      guard let data = response.data else { return }
      completion(data)
    }
  }
}
