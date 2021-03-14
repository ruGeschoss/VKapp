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
import FirebaseDatabase
import FirebaseFirestore

class NetworkManager {
    
    private static let alamoFireSession: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = false
        let session = Alamofire.Session(configuration: configuration)

        return session
    }()

    static let shared = NetworkManager()
    static let appUserRef = Database.database().reference(withPath: "appUsers/\(Session.shared.userId)")
    static let appUserCollection = Firestore.firestore().collection("AppUsers").document(Session.shared.userId)

    private init() {

    }
    //MARK: Saving data to Realm
    static func saveUsersDataToRealm(_ users: [UserSJ], forUser: String) {
            do {
                let realm = try Realm()
                print(realm.configuration.fileURL)
                realm.beginWrite()
                realm.add(users, update: .modified)
                try realm.commitWrite()
            } catch {
                print(error.localizedDescription)
            }
    }
    
    static func savePhotosToRealm(_ photos: [Photos], ownerId: String) {
            do {
                let realm = try Realm()
                realm.beginWrite()
                realm.add(photos, update: .modified)
                try realm.commitWrite()
            } catch {
                print(error.localizedDescription)
            }
    }
    
    static func saveGroupsDataToRealm(_ groups: [Group], forUserId: String) {
            do {
                let realm = try Realm()
                realm.beginWrite()
                realm.add(groups, update: .modified)
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

    static func loadGroupsSJ(forUserId: String?, completion: @escaping () -> Void) {
        let target = forUserId ?? Session.shared.userId
        let baseUrl = "https://api.vk.com"
        let path = "/method/groups.get"
        let params: Parameters = [
            "access_token": Session.shared.token,
            "user_id" : target,
            "extended": 1,
            "v": "5.92"
        ]
        
        NetworkManager.alamoFireSession.request(baseUrl + path,
                                                method: .get,
                                                parameters: params).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                let response = json["response"]["items"].arrayValue
                let groups = response.map { Group(from: $0) }
                groups.forEach { $0.forUserId = target }
                self.saveGroupsDataToRealm(groups, forUserId: target)
                
                let firebaseGroups = groups.map { GroupFirebase(fromGroup: $0) }
                
                switch FirebaseConfig.databaseType {
                case .database:
                    firebaseGroups.forEach {
                        appUserRef.child("groups")
                            .child($0.groupId)
                            .setValue($0.toAnyObj())
                    }
                case .firestore:
                    firebaseGroups.forEach {
                        appUserCollection
                            .collection("Groups")
                            .document($0.groupId)
                            .setData($0.toAnyObj())
                    }
                print("")
                }
                
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: Search Groups
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
        
        NetworkManager.alamoFireSession.request(baseUrl + path,
                                                method: .get,
                                                parameters: params).responseJSON { (response) in
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
    
    //MARK: Load Friends SJ
    static func loadFriendsSJ(forUser: String?, completion: @escaping () -> Void) {
        let target = forUser ?? Session.shared.userId
        let baseUrl = "https://api.vk.com"
        let path = "/method/friends.get"
        let params: Parameters = [
            "access_token": Session.shared.token,
            "user_id": target,
            "fields" : "photo_50",
            "v": "5.92"
        ]
        
        NetworkManager.alamoFireSession.request(baseUrl + path,
                                                method: .get,
                                                parameters: params).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                let response = json["response"]["items"].arrayValue
                let friends = response.map { UserSJ(from: $0) }
                friends.forEach { $0.forUser = target }
                self.saveUsersDataToRealm(friends, forUser: target)
                
                let firebaseFriends = friends.map { UserFirebase(usermodel: $0) }

                switch FirebaseConfig.databaseType {
                case .database:
                    firebaseFriends.forEach {
                        appUserRef
                            .child("friends")
                            .child($0.id)
                            .setValue( $0.toAnyObj() )
                    }
                case .firestore:
                    firebaseFriends.forEach {
                        appUserCollection
                            .collection("Friends")
                            .document($0.id)
                            .setData($0.toAnyObj())
                    }
                }
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    //MARK: Load Photos
    static func loadPhotosSJ(ownerId: String, completion: @escaping () -> Void) {
        let baseUrl = "https://api.vk.com"
        let path = "/method/photos.getAll"
        let params: Parameters = [
            "access_token": Session.shared.token,
            "owner_id": ownerId,
            "v": "5.92"
        ]
        
        NetworkManager.alamoFireSession.request(baseUrl + path,
                                                method: .get,
                                                parameters: params).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                let response = json["response"]["items"].arrayValue
                let photos = response.map { Photos(from: $0) }
                photos.forEach { $0.ownerId = ownerId }
                self.savePhotosToRealm(photos, ownerId: ownerId)
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: Get Photo Data
    static func getPhotoDataFromUrl(url: String, completion: @escaping (Data) -> ()) {
        NetworkManager.alamoFireSession.request(url,
                                                method: .get).responseData { (response) in
            guard let data = response.data else { return }
            completion(data)
        }
    }

    //MARK: User Profile Data
    static func getProfileDataSJ() {
        let baseUrl = "https://api.vk.com"
        let path = "/method/account.getProfileInfo"
        let params: Parameters = [
            "access_token": Session.shared.token,
            "v": "5.92"
        ]
        NetworkManager.alamoFireSession.request(baseUrl + path,
                                                method: .get,
                                                parameters: params).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                let user = ProfileSJ(from: json["response"])
                self.saveProfileDataToRealm(user)
                Session.shared.userName = user.firstName
                
                let appUser = ProfileFirebase(fromProfile: user)
                
                switch FirebaseConfig.databaseType {
                case .database:
                    appUserRef.setValue(appUser.toAnyObj())
                case .firestore:
                    appUserCollection.setData(appUser.toAnyObj())
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
