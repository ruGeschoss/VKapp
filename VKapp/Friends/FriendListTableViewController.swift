//
//  FriendListTableViewController.swift
//  VKapp
//
//  Created by Alexander Andrianov on 29.12.2020.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore

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
    
    //Firebase Database
    let appUserRef = Database.database().reference(withPath: "appUsers/\(Session.shared.userId)")
    
    //Firebase Firestore
    let appUserCollection = Firestore.firestore().collection("AppUsers").document(Session.shared.userId)
    var listener: ListenerRegistration?
    
    var usersFirebase = [UserFirebase]()
    var filtredUsersFirebase: [UserFirebase]? {
        guard !searchText.isEmpty else { return usersFirebase }
        
        var userLastNames = usersFirebase.map { $0.lastName }
        userLastNames = searchText.isEmpty ? userLastNames : userLastNames.filter { (lastName:String) -> Bool in
            lastName.range(of: searchText, options: .caseInsensitive) != nil
            }
        
        return usersFirebase.filter { userLastNames.contains($0.lastName) }
    }
    
    
    private var searchText: String {
        friendSearch.text ?? ""
    }
    
    var sectionTitles = [String]()  //Whole tableView based on those titles
    var selectedUser = String()
    var friendListForUserId = Session.shared.userId
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemGray
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление...", attributes: [.font: UIFont.systemFont(ofSize: 10)])
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeFirebase()
    }
    
    private func observeFirebase() {
        switch FirebaseConfig.databaseType {
        case .database:
            appUserRef.child("friends").observe(.value) { [weak self] (snapshot) in
                self?.usersFirebase.removeAll()
                guard !snapshot.children.allObjects.isEmpty else {
                    NetworkManager.loadFriendsSJ(forUser: self?.friendListForUserId) {
                        self?.tableView.reloadData()
                    }
                    return
                }
                for child in snapshot.children {
                    guard let child = child as? DataSnapshot,
                          let friend = UserFirebase(snapshot: child) else { continue }
                    self?.usersFirebase.append(friend)
                }
                self?.usersFirebase.sort { $0.lastName < $1.lastName }
                self?.getSectionTitles()
                self?.tableView.reloadData()
            }
        case .firestore:
            listener = appUserCollection.collection("Friends").addSnapshotListener { [weak self] (snapshot, error) in
                self?.usersFirebase.removeAll()
                guard let snapshot = snapshot, !snapshot.documents.isEmpty else {
                    NetworkManager.loadFriendsSJ(forUser: self?.friendListForUserId) {
                        self?.tableView.reloadData()
                    }
                    return
                }
                for doc in snapshot.documents {
                    guard let friend = UserFirebase(dict: doc.data()) else { continue }
                    self?.usersFirebase.append(friend)
                }
                self?.usersFirebase.sort { $0.lastName < $1.lastName }
                self?.getSectionTitles()
                self?.tableView.reloadData()
            }
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
    //MARK: Deinit
    deinit {
        switch FirebaseConfig.databaseType {
        case .database:
            appUserRef.removeAllObservers()
        case .firestore:
            listener?.remove()
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

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? MyFriendsTableViewCell {
            cell.friendPhoto.image = UIImage(named: "No_Image")
        }
        cell.prepareForReuse()
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
    
    func friendsForSectionByFirstChar(_ indexInTitles: Int) -> [UserFirebase] {
        var tmpArray:[UserFirebase] = []
        for each in filtredUsersFirebase! {
            if String(each.lastName.first ?? "-") == sectionTitles[indexInTitles] {
                tmpArray.append(each)
            }
        }
        return tmpArray
    }
    func getSectionTitles() {
        sectionTitles = []
        for each in filtredUsersFirebase! {
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
//        tableView.reloadData()
    }
    
}
