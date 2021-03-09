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
    static let shared = NetworkManager()


    private init() {

    }
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
    //MARK: Saving data to Realm
    static func saveUsersDataToRealm(_ users: [UserSJ], forUser: String) {
            do {
                let realm = try Realm()
                let prevSavedData = realm.objects(UserSJ.self).filter("forUser == %@", forUser)
                realm.beginWrite()
                realm.delete(prevSavedData)
                realm.add(users, update: .modified)
                try realm.commitWrite()
            } catch {
                print(error.localizedDescription)
            }
    }
    
    static func savePhotosToRealm(_ photos: [Photos], ownerId: String) {
            do {
                let realm = try Realm()
                let prevSavedData = realm.objects(Photos.self).filter("ownerId == %@", ownerId)
                realm.beginWrite()
                realm.delete(prevSavedData)
                realm.add(photos, update: .modified)
                try realm.commitWrite()
            } catch {
                print(error.localizedDescription)
            }
    }
    
    static func saveGroupsDataToRealm(_ groups: [Group], forUserId: String) {
            do {
                let realm = try Realm()
                let prevSavedData = realm.objects(Group.self).filter("forUserId == %@", forUserId)
                realm.beginWrite()
                realm.delete(prevSavedData)
                realm.add(groups, update: .modified)
                print(realm.configuration.fileURL)
                try realm.commitWrite()
            } catch {
                print(error.localizedDescription)
            }
    }
    
    static func saveProfileDataToRealm(_ profile: ProfileSJ) {
            do { 
                let realm = try Realm()
                realm.beginWrite()
                realm.add(profile, update: .modified)
                try realm.commitWrite()
            } catch {
                print(error.localizedDescription)
            }
    }
    
    //MARK: Load Groups
//    static func loadGroups() {
//        let baseUrl = "https://api.vk.com"
//        let path = "/method/groups.get"
//        let params: Parameters = [
//            "access_token": Session.shared.token,
//            "extended": 1,
//            "v": "5.92"
//        ]
//
//        NetworkManager.alamoFireSession.request(baseUrl + path, method: .get, parameters: params).responseJSON { (response) in
//            guard let json = response.value else { return }
//
//            print(json)
//        }
//    }
    static func loadGroupsSJ(forUserId: String?, completion: @escaping () -> Void) {
//    static func loadGroupsSJ(forUserId: String?, completion: ((Result<[Group],Error>) -> Void)? = nil) {
        let target = forUserId ?? Session.shared.userId
        let baseUrl = "https://api.vk.com"
        let path = "/method/groups.get"
        let params: Parameters = [
            "access_token": Session.shared.token,
            "user_id" : target,
            "extended": 1,
            "v": "5.92"
        ]
        
        NetworkManager.alamoFireSession.request(baseUrl + path, method: .get, parameters: params).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                let response = json["response"]["items"].arrayValue
                let groups = response.map { Group(from: $0) }
                groups.forEach { $0.forUserId = target }
                self.saveGroupsDataToRealm(groups, forUserId: target)
                completion()
//                completion?(.success(groups))
            case .failure(let error):
                print(error.localizedDescription)
//                completion?(.failure(error))
            }
        }
    }
    
    //MARK: Search Groups
//    static func searchGroup(searchText: String) {
//        let baseUrl = "https://api.vk.com"
//        let path = "/method/groups.search"
//        let params: Parameters = [
//            "access_token": Session.shared.token,
//            "q": "\(searchText)",
//            "type": "group",
//            "sort": "0",
//            "count": "50",
//            "v": "5.92"
//        ]
//        
//        NetworkManager.alamoFireSession.request(baseUrl + path, method: .get, parameters: params).responseJSON { (response) in
//            guard let json = response.value else { return }
//            
//            print(json)
//        }
//    }
    
    static func searchGroupSJ(searchText: String?, completion: ((Result<[Group],Error>) -> Void)? = nil) {
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
        
        NetworkManager.alamoFireSession.request(baseUrl + path, method: .get, parameters: params).responseJSON { (response) in
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
    
    //MARK: Load Friends
//    static func loadFriends(completion: @escaping ([User]) -> ()) {
//        let baseUrl = "https://api.vk.com"
//        let path = "/method/friends.get"
//        let params: Parameters = [
//            "access_token": Session.shared.token,
//            "fields" : "photo_50",
//            "v": "5.92"
//        ]
//        
//        NetworkManager.alamoFireSession.request(baseUrl + path, method: .get, parameters: params).responseJSON { (response) in
//                guard let data = response.data else { return }
//                
//                do {
//                    let friends = try JSONDecoder().decode(VKResponseAllFriends.self, from: data)
//                    let friendsArray = friends.response.friends
//                    completion(friendsArray)
//                } catch {
//                    print(error.localizedDescription)
//                }
//        }
//    }
    //MARK: Load Friends SJ
    static func loadFriendsSJ(forUser: String?, completion: @escaping () -> Void) {
//    static func loadFriendsSJ(forUser: String?, completion: ((Result<[UserSJ],Error>) -> Void)? = nil) {
        let target = forUser ?? Session.shared.userId
        let baseUrl = "https://api.vk.com"
        let path = "/method/friends.get"
        let params: Parameters = [
            "access_token": Session.shared.token,
            "user_id": target,
            "fields" : "photo_50",
            "v": "5.92"
        ]
        
        NetworkManager.alamoFireSession.request(baseUrl + path, method: .get, parameters: params).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                let response = json["response"]["items"].arrayValue
                let friends = response.map { UserSJ(from: $0) }
                friends.forEach { $0.forUser = target }
                self.saveUsersDataToRealm(friends, forUser: target)
                completion()
//                completion?(.success(friends))
            case .failure(let error):
                print(error.localizedDescription)
//                completion?(.failure(error))
            }
        }
    }
    
    
    
    //MARK: Load Photos
//    static func loadPhotos(ownerId: String, completion: @escaping ([Photo]) -> ()) {
//        let baseUrl = "https://api.vk.com"
//        let path = "/method/photos.getAll"
//        let params: Parameters = [
//            "access_token": Session.shared.token,
//            "owner_id": ownerId,
//            "v": "5.92"
//        ]
//        
//        NetworkManager.alamoFireSession.request(baseUrl + path, method: .get, parameters: params).responseJSON { (response) in
//            guard let data = response.data else { return }
//            
//            do {
//                let photos = try JSONDecoder().decode(VKResponseAllPhotos.self, from: data)
//                let allPhotos = photos.response.items
//                completion(allPhotos)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    static func loadPhotosSJ(ownerId: String, completion: @escaping () -> Void) {
//    static func loadPhotosSJ(ownerId: String, completion: ((Result<[Photos],Error>) -> Void)? = nil) {
        let baseUrl = "https://api.vk.com"
        let path = "/method/photos.getAll"
        let params: Parameters = [
            "access_token": Session.shared.token,
            "owner_id": ownerId,
            "v": "5.92"
        ]
        
        NetworkManager.alamoFireSession.request(baseUrl + path, method: .get, parameters: params).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                let response = json["response"]["items"].arrayValue
                let photos = response.map { Photos(from: $0) }
                photos.forEach { $0.ownerId = ownerId }
                self.savePhotosToRealm(photos, ownerId: ownerId)
                completion()
//                completion?(.success(photos))
            case .failure(let error):
                print(error.localizedDescription)
//                completion?(.failure(error))
            }
        }
    }
    
    //MARK: Get Photo Data
    static func getPhotoDataFromUrl(url: String, completion: @escaping (Data) -> ()) {
        NetworkManager.alamoFireSession.request(url, method: .get).responseData { (response) in
            guard let data = response.data else { return }
            completion(data)
        }
    }

    //MARK: User Profile Data
//    static func getProfileData() {
//        let baseUrl = "https://api.vk.com"
//        let path = "/method/account.getProfileInfo"
//        let params: Parameters = [
//            "access_token": Session.shared.token,
//            "v": "5.92"
//        ]
//        NetworkManager.alamoFireSession.request(baseUrl + path, method: .get, parameters: params).responseJSON { (response) in
//            guard let data = response.data else { return }
//            do {
//                let profileData = try JSONDecoder().decode(Profile.self, from: data)
//                Session.shared.userName = profileData.response.firstName
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    static func getProfileDataSJ() {
        let baseUrl = "https://api.vk.com"
        let path = "/method/account.getProfileInfo"
        let params: Parameters = [
            "access_token": Session.shared.token,
            "v": "5.92"
        ]
        NetworkManager.alamoFireSession.request(baseUrl + path, method: .get, parameters: params).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                let user = ProfileSJ(from: json["response"])
                self.saveProfileDataToRealm(user)
                Session.shared.userName = user.firstName
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
