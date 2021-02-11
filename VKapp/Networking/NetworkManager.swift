//
//  NetworkManager.swift
//  VKapp
//
//  Created by Alexander Andrianov on 11.02.2021.
//

import Foundation
import Alamofire

class NetworkManager {
    
    private static let alamoFireSession: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = false
        let session = Alamofire.Session(configuration: configuration)

        return session
    }()
    
//    private static let session: URLSession = {
//        let configuration = URLSessionConfiguration.default
//        configuration.allowsCellularAccess = false
//        let session = URLSession(configuration: configuration)
//
//        return session
//    }()
//
//    static let shared = NetworkManager()
//
//    private init() {
//
//    }
//
//    func advancedRequest(city:String) {
//        var urlComponents = URLComponents()
//        urlComponents.scheme = "http"
//        urlComponents.host = "api.openweathermap.org"
//        urlComponents.path = "/data/2.5/weather"
//        urlComponents.queryItems = [
//            URLQueryItem(name: "q", value: city),
//            URLQueryItem(name: "appid", value: "87cfbe1aa9823b8c75d4427336656de7"),
//            URLQueryItem(name: "units", value: "metric")
//        ]
//        guard let url = urlComponents.url else { return }
//
//        let dataTask = NetworkManager.session.dataTask(with: url) { (data, response, error) in
//            if let data = data {
//                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
//                print(json)
//                }
//            } else if let error = error {
//                print(error.localizedDescription)
//            }
//        }
//        dataTask.resume()
//    }
//
//    func sendPostRequest() {
//        var urlComponents = URLComponents()
//        urlComponents.scheme = "http"
//        urlComponents.host = "jsonplaceholder.typicode.com"
//        urlComponents.path = "/posts"
//        urlComponents.queryItems = [
//            URLQueryItem(name: "userId", value: "1"),
//            URLQueryItem(name: "title", value: "awdda"),
//            URLQueryItem(name: "body", value: "adwdwasga")
//        ]
//        guard let url = urlComponents.url else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.timeoutInterval = 30
//
//        let dataTask = NetworkManager.session.dataTask(with: request) { (data, response, error) in
//            if let data = data {
//                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
//                print(json)
//                }
//            } else if let error = error {
//                print(error.localizedDescription)
//            }
//        }
//        dataTask.resume()
//    }
//
//    func alamofireRequest(city:String) {
//
//        let host = "http://api.openweathermap.org"
//        let path = "/data/2.5/weather"
//        let params = [
//            "q": city,
//            "appid": "87cfbe1aa9823b8c75d4427336656de7",
//            "units": "metric"
//        ]
//
//        AF.request(host + path, method: .get, parameters: params).responseJSON { (response) in
//            switch response.result {
//            case .success:
//                if let data = response.data {
//                    if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
//                    print(json)
//                    }
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    static func loadGroups(token: String) {
        let baseUrl = "https://api.vk.com"
        let path = "/method/groups.get"
        let params: Parameters = [
            "access_token": token,
            "extended": 1,
            "v": "5.92"
        ]
        
        NetworkManager.alamoFireSession.request(baseUrl + path, method: .get, parameters: params).responseJSON { (response) in
            guard let json = response.value else { return }
            
            print(json)
        }
    }
    
    static func searchGroup(token: String, searchText: String) {
        let baseUrl = "https://api.vk.com"
        let path = "/method/groups.search"
        let params: Parameters = [
            "access_token": token,
            "q": "\(searchText)",
            "type": "group",
            "sort": "0",
            "count": "50",
            "v": "5.92"
        ]
        
        NetworkManager.alamoFireSession.request(baseUrl + path, method: .get, parameters: params).responseJSON { (response) in
            guard let json = response.value else { return }
            
            print(json)
        }
    }
    
    static func loadFriends(token: String) {
        let baseUrl = "https://api.vk.com"
        let path = "/method/friends.get"
        let params: Parameters = [
            "access_token": token,
            "fields" : "nickname, sex, online",
            "v": "5.92"
        ]
        
        NetworkManager.alamoFireSession.request(baseUrl + path, method: .get, parameters: params).responseJSON { (response) in
            guard let json = response.value else { return }
            
            print(json)
        }
    }
    
    static func loadPhotos(token: String, count: Int) {
        let baseUrl = "https://api.vk.com"
        let path = "/method/photos.getAll"
        let params: Parameters = [
            "access_token": token,
            "extended": "1",
            "count": "\(count)",
            "photo_sizes": "0",
            "no_service_albums": "0",
            "v": "5.92"
        ]
        
        NetworkManager.alamoFireSession.request(baseUrl + path, method: .get, parameters: params).responseJSON { (response) in
            guard let json = response.value else { return }
            
            print(json)
        }
    }
    
    
}
