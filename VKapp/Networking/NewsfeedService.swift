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
  static func getPostNews() {
    let params: Parameters = [
      "access_token": Session.shared.token,
      "v": "5.92",
      "fields": "post",
      "count": 10
    ]
    NewsfeedService.alamoFireSession
      .request(baseUrl + getPath, method: .get, parameters: params)
      .responseJSON { (response) in
      switch response.result {
      case .success(let data):
        let json = JSON(data)
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
  // MARK: - get "photo"
  static func getPhotoNews() {
    let params: Parameters = [
      "access_token": Session.shared.token,
      "v": "5.92",
      "fields": "photo",
      "count": 10
    ]
    NewsfeedService.alamoFireSession
      .request(baseUrl + getPath, method: .get, parameters: params)
      .responseJSON { (response) in
      switch response.result {
      case .success(let data):
        let json = JSON(data)
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
}
