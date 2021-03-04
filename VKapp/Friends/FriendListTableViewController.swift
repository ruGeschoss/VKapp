//
//  FriendListTableViewController.swift
//  VKapp
//
//  Created by Alexander Andrianov on 29.12.2020.
//

import UIKit
import RealmSwift

protocol PhotoDelegate:AnyObject {
    func getPhoto(photo:String)
}

class FriendListTableViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var charPicker: CharPicker!
    @IBOutlet weak var friendSearch: UISearchBar!
    
    var usersData = [UserSJ]()        // data from VK.api
    var searchData = [UserSJ]()       // data to show
    
    var sectionTitles = [String]()  // titles for sections by first char of lastName
    var selectedUser = String()     // String id of selected user
    
    var friendListForUserId = Session.shared.userId
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendSearch.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear

        //MARK:- Loading friends list
        
        //        NetworkManager.loadFriendsSJ(forUser: nil) { [weak self] in
        //            self?.getDataFromRealm()
        //            self?.tableView.reloadData()
        //        }
        getDataFromRealm()
        tableView.reloadData()
                
        //        showWelcomeMessage()
        
        
//        NetworkManager.loadFriendsSJ(forUser: nil) { [weak self] (result) in
//            guard let self = self else { return }
//
//            switch result {
//            case .success(let users):
//                self.usersData = users.sorted {$0.lastName < $1.lastName}
//                self.searchData = self.usersData
//                self.getSectionTitles()
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }
    
    @IBAction func charPicked(_ sender: CharPicker) {
        let selectedChar = charPicker.selectedChar
        var indexPath = IndexPath(item: 0, section: 0)
        for (index,section) in sectionTitles.enumerated() {
            if selectedChar == section {
                indexPath = IndexPath(item: 0, section: index)
            }
        }
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    @IBAction func didMakePan(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: charPicker)
        let coeff = Int(charPicker.frame.height) /  sectionTitles.count
        let letterIndex = Int(location.y) / coeff
        
        if letterIndex < sectionTitles.count && letterIndex >= 0 {
            charPicker.selectedChar = sectionTitles[letterIndex]
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToMyFriendCell" {
            if let destination = segue.destination as? FriendPhotoCollectionViewController{
                destination.photosForUserID = selectedUser
            }
        }
    }
    
//    func showWelcomeMessage() {
//        let alert = UIAlertController(title: "Welcome!", message: "Добро пожаловать, \(Session.shared.userName)! \n Хорошего Вам дня!", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Продолжить", style: .cancel, handler: nil)
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
//    }
    
    func getDataFromRealm() {
        do {
            let realm = try Realm()
            let usersData = realm.objects(UserSJ.self).filter("forUser == %@", friendListForUserId)
            self.usersData = Array(usersData).sorted {$0.lastName < $1.lastName}
            self.searchData = self.usersData
            self.getSectionTitles()
        } catch {
            print(error)
        }
    }
    
}

//MARK: TableViewDelegate

extension FriendListTableViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsForSectionByFirstChar(section).count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
        header.alpha = 0.5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendCell", for: indexPath) as? MyFriendsTableViewCell {
            let friend = friendsForSectionByFirstChar(indexPath.section)[indexPath.row]
            cell.configure(forUser: friend)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = friendsForSectionByFirstChar(indexPath.section)[indexPath.row].id
        NetworkManager.loadPhotosSJ(ownerId: selectedUser) {
            self.performSegue(withIdentifier: "ToMyFriendCell", sender: self)
        }
//        performSegue(withIdentifier: "ToMyFriendCell", sender: self)
    }
    
    func friendsForSectionByFirstChar(_ indexInTitles: Int) -> [UserSJ] {
        var tmpArray:[UserSJ] = []
        for each in searchData {
            if String(each.lastName.first ?? "-") == sectionTitles[indexInTitles] {
                tmpArray.append(each)
            }
        }
        return tmpArray
    }
    func getSectionTitles() {
        sectionTitles = []
        for each in searchData {
            let charForTitle = each.lastName.first ?? "-"
            if !sectionTitles.contains(String(charForTitle)) {
                sectionTitles.append(String(charForTitle))
            }
        }
        charPicker.chars = sectionTitles
        charPicker.setupUI()
    }
}

//MARK:- SearchBarDelegate
extension FriendListTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var userLastNames = usersData.map({$0.lastName})
        
        userLastNames = searchText.isEmpty ? userLastNames : userLastNames.filter({(dataString:String) -> Bool in
            return dataString.range(of: searchText, options: .caseInsensitive) != nil
            })
        
        searchData = usersData.filter({userLastNames.contains($0.lastName)})
        getSectionTitles()
        tableView.reloadData()
    }
    
}
