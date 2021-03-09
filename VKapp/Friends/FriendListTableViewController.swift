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
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.refreshControl = refreshControl
            tableView.dataSource = self
            tableView.delegate = self
            tableView.backgroundColor = UIColor.clear
        }
    }
    @IBOutlet weak var charPicker: CharPicker!
    @IBOutlet weak var friendSearch: UISearchBar! {
        didSet {
            friendSearch.delegate = self
        }
    }
    
    var usersData : Results<UserSJ>? {
        let realm = try? Realm()
        let users: Results<UserSJ>? = realm?.objects(UserSJ.self)
        return users?.sorted(byKeyPath: "lastName", ascending: true)
    }
    
    var searchData : Results<UserSJ>? {
        guard !searchText.isEmpty else {
            return usersData
        }
        return usersData?.filter("lastName CONTAINS %@", searchText)
    }
    
    private var searchText: String {
        friendSearch.text ?? ""
    }
    
    var sectionTitles = [String]()
    var selectedUser = String()
    var friendListForUserId = Session.shared.userId
    private var searchDataNotificationToken: NotificationToken?
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemGray
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление...", attributes: [.font: UIFont.systemFont(ofSize: 10)])
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        searchDataNotificationToken = usersData?.observe { [weak self] result in
            switch result {
            case .initial(let usersData):
                print("Initiated with \(usersData.count) users")
                self?.getSectionTitles()
                self?.tableView.reloadData()
                break
            case .update(let users, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                print("""
                    New count \(users.count)
                    Deletions \(deletions)
                    Insertions \(insertions)
                    Modifications \(modifications)
                    """)
//                self?.tableView.beginUpdates()
//                let deletionsIndexPaths = deletions.map { IndexPath(row: $0, section: 0) }
//                let insertionsIndexPaths = insertions.map { IndexPath(row: $0, section: 0) }
//                let modificationsIndexPaths = modifications.map { IndexPath(row: $0, section: 0) }
//
//                self?.tableView.deleteRows(at: deletionsIndexPaths, with: .automatic)
//                self?.tableView.insertRows(at: insertionsIndexPaths, with: .automatic)
//                self?.tableView.reloadRows(at: modificationsIndexPaths, with: .automatic)
//                self?.tableView.endUpdates()
                break
            case .error(let error):
                print(error.localizedDescription)
                break
            }
        }
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
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        NetworkManager.loadFriendsSJ(forUser: friendListForUserId) { [weak self] in
            self?.refreshControl.endRefreshing()
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
    }
    
    func friendsForSectionByFirstChar(_ indexInTitles: Int) -> [UserSJ] {
        var tmpArray:[UserSJ] = []
        for each in searchData! {
            if String(each.lastName.first ?? "-") == sectionTitles[indexInTitles] {
                tmpArray.append(each)
            }
        }
        return tmpArray
    }
    func getSectionTitles() {
        sectionTitles = []
        for each in searchData! {
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
        getSectionTitles()
        tableView.reloadData()
    }
    
}
