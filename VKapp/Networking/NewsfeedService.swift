//
//  NewsfeedService.swift
//  VKapp
//
//  Created by Alexander Andrianov on 26.03.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

final class NewsfeedService {
  
  private static let alamoFireSession: Alamofire.Session = {
    let configuration = URLSessionConfiguration.default
    configuration.allowsCellularAccess = false
    let session = Alamofire.Session(configuration: configuration)
    
    return session
  }()
  
  private static let baseUrl = "https://api.vk.com"
  private static let getPath = "/method/newsfeed.get"
  
  // MARK: - get "post"
  static func getPostNews(
    completion: @escaping ([NewsPostModel], [UserSJ], [Group], String) -> Void) {
    
    let params: Parameters = [
      "access_token": Session.shared.token,
      "v": "5.92",
      "filters": "post",
      "count": 5
    ]
    
    NewsfeedService.alamoFireSession
      .request(baseUrl + getPath, method: .get, parameters: params)
      .responseJSON { (response) in
      switch response.result {
      case .success(let data):
        let json = JSON(data)
        let nextFrom = json["response"]["next_from"].stringValue
        let dispatchGroup = DispatchGroup()
        
        var parsedNews: [NewsPostModel] = []
        var parsedUsers: [UserSJ] = []
        var parsedGroups: [Group] = []
        
        DispatchQueue.global().async(group: dispatchGroup) {
          parsedNews = json["response"]["items"]
            .arrayValue
            .map { NewsPostModel(from: $0) }
        }

        DispatchQueue.global().async(group: dispatchGroup) {
          parsedUsers = json["response"]["profiles"]
            .arrayValue
            .map { UserSJ(from: $0) }
        }

        DispatchQueue.global().async(group: dispatchGroup) {
          parsedGroups = json["response"]["groups"]
            .arrayValue
            .map { Group(from: $0) }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
          completion(parsedNews, parsedUsers, parsedGroups, nextFrom)
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
  // MARK: - get "photo"
  static func getPhotoNews(
    completion: @escaping ([NewsPhotoModel], [UserSJ], [Group], String) -> Void) {
    let params: Parameters = [
      "access_token": Session.shared.token,
      "v": "5.92",
      "filters": "photo",
      "count": 10
    ]
    NewsfeedService.alamoFireSession
      .request(baseUrl + getPath, method: .get, parameters: params)
      .responseJSON { (response) in
      switch response.result {
      case .success(let data):
        let json = JSON(data)
        let nextFrom = json["response"]["next_from"].stringValue
        let dispatchGroup = DispatchGroup()
        var parsedNews: [NewsPhotoModel] = []
        var parsedUsers: [UserSJ] = []
        var parsedGroups: [Group] = []
        
        DispatchQueue.global().async(group: dispatchGroup) {
          parsedNews = json["response"]["items"]
            .arrayValue
            .map { NewsPhotoModel(from: $0) }
        }

        DispatchQueue.global().async(group: dispatchGroup) {
          parsedUsers = json["response"]["profiles"]
            .arrayValue
            .map { UserSJ(from: $0) }
        }

        DispatchQueue.global().async(group: dispatchGroup) {
          parsedGroups = json["response"]["groups"]
            .arrayValue
            .map { Group(from: $0) }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
          completion(parsedNews, parsedUsers, parsedGroups, nextFrom)
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
}
