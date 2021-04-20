//
//  FriendListTableViewController.swift
//  VKapp
//
//  Created by Alexander Andrianov on 29.12.2020.
//

import UIKit
import RealmSwift

protocol PhotoDelegate: AnyObject {
  func getPhoto(photo: String)
}

final class FriendListTableViewController: UIViewController {
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var charPicker: CharPicker!
  @IBOutlet private weak var friendSearch: UISearchBar!

  private lazy var realm = RealmManager.shared
  private var searchDataNotificationToken: NotificationToken?
  private var testToken: NotificationToken?
  private var sectionTitles = [String]()
  private var selectedUser = String()
  private var friendListForUserId = Session.shared.userId
  private lazy var refreshControl: UIRefreshControl = {
    createRefreshControl()
  }()
  private var searchText: String {
    friendSearch.text ?? ""
  }
  private var usersData: Results<UserSJ>? {
    realm?.getObjects(type: UserSJ.self)
      .filter("forUser CONTAINS %@", Session.shared.userId)
      .sorted(byKeyPath: "lastName", ascending: true)
  }
  private var searchData: Results<UserSJ>? {
    filterUsers()
  }
  
  deinit {
    searchDataNotificationToken?.invalidate()
    testToken?.invalidate()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupController()
    createSingleTargetToken()
    createSearchDataNotificationToken()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ToMyFriendCell" {
      if let destination = segue.destination
          as? FriendPhotoCollectionViewController {
        destination.photosForUserID = selectedUser
      }
    }
  }

  // MARK: - Actions
  @IBAction private func charPicked(_ sender: CharPicker) {
    let selectedChar = charPicker.selectedChar
    var indexPath = IndexPath(item: 0, section: 0)
    
    for (index, section) in sectionTitles.enumerated()
    where selectedChar == section {
        indexPath = IndexPath(item: 0, section: index)
    }
    tableView.scrollToRow(at: indexPath, at: .top, animated: true)
  }

  @IBAction private func didMakePan(_ sender: UIPanGestureRecognizer) {
    view.endEditing(true)

    let location = sender.location(in: charPicker)
    let coeff = Int(charPicker.frame.height) /  charPicker.chars.count
    let letterIndex = Int(location.y) / coeff

    if letterIndex < charPicker.chars.count && letterIndex >= 0 {
      charPicker.selectedChar = charPicker.chars[letterIndex]
    }

    switch sender.state {
    case .cancelled, .ended, .failed:
      charPicker.buttons
        .filter { $0.isSelected == true }
        .forEach { $0.isSelected = false }
    default:
      break
    }
  }
}

// MARK: - Functions
extension FriendListTableViewController {
  private func setupController() {
    tableView.refreshControl = refreshControl
    tableView.dataSource = self
    tableView.delegate = self
    tableView.backgroundColor = UIColor.clear
    friendSearch.delegate = self
  }
  
  private func filterUsers() -> Results<UserSJ>? {
    guard !searchText.isEmpty else { return usersData }
    let lastNamePredicate =
      NSPredicate(format: "lastName CONTAINS[cd] %@", searchText)
    let firstNamePredicate =
      NSPredicate(format: "firstName CONTAINS[cd] %@", searchText)
    let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [firstNamePredicate, lastNamePredicate])
    return usersData?.filter(predicate)
  }
}

// MARK: - TableView Datasouce
extension FriendListTableViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return sectionTitles.count
  }

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return friendsForSectionByFirstChar(section).count
  }

  func tableView(_ tableView: UITableView,
                 titleForHeaderInSection section: Int) -> String? {
    return sectionTitles[section]
  }

  func tableView(_ tableView: UITableView,
                 willDisplayHeaderView view: UIView,
                 forSection section: Int) {
    guard let header = view as? UITableViewHeaderFooterView else { return }
    header.textLabel?.textColor = UIColor.black
    header.alpha = 0.5
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView
        .dequeueReusableCell(withIdentifier: "MyFriendCell",
                             for: indexPath) as? MyFriendsTableViewCell {
      let friend =
        friendsForSectionByFirstChar(indexPath.section)[indexPath.row]
      cell.configure(forUser: friend)
      return cell
    }
    return UITableViewCell()
  }
}

// MARK: - TableView Delegate
extension FriendListTableViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    selectedUser =
      friendsForSectionByFirstChar(indexPath.section)[indexPath.row]
      .userId
    NetworkManager.loadPhotosSJ(ownerId: selectedUser) {
      self.performSegue(withIdentifier: "ToMyFriendCell", sender: self)
    }
  }

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    view.endEditing(true)
  }
}

// MARK: - SearchBarDelegate
extension FriendListTableViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar,
                 textDidChange searchText: String) {
    getSectionTitles()
    tableView.reloadData()

    guard let count = searchData?.count,
          count > tableView.visibleCells.count else {
      charPicker.isUserInteractionEnabled = false
      charPicker.isHidden = true
      return
    }
    charPicker.isUserInteractionEnabled = true
    charPicker.isHidden = false
  }
}

// MARK: - Private functions
extension FriendListTableViewController {
  
  private func friendsForSectionByFirstChar(
    _ indexInTitles: Int) -> [UserSJ] {
    
    var tmpArray: [UserSJ] = []
    for each in searchData! {
      if String(each.lastName.first ?? "-") ==
          sectionTitles[indexInTitles] {
        tmpArray.append(each)
      }
    }
    return tmpArray
  }

  private func getSectionTitles() {
    sectionTitles = []
    var shouldAppendEmptySection = false
    
    for friend in searchData! {
      let charForTitle = friend.lastName.first ?? "-"
      
      guard charForTitle != "-" else {
        shouldAppendEmptySection = true
        continue
      }
      if !sectionTitles.contains(String(charForTitle)) {
        sectionTitles.append(String(charForTitle))
      }
    }
    shouldAppendEmptySection ? (sectionTitles.append("-")) : ()
    charPicker.chars = sectionTitles
    charPicker.setupUI()
  }
}

// MARK: - Refresh control
extension FriendListTableViewController {
  
  private func createRefreshControl() -> UIRefreshControl {
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = .systemGray
    refreshControl.attributedTitle =
      NSAttributedString(
        string: "Обновление...",
        attributes: [.font: UIFont.systemFont(ofSize: 10)])
    refreshControl.addTarget(
      self, action: #selector(refresh(_:)),
      for: .valueChanged)
    return refreshControl
  }
  
  @objc private func refresh(_ sender: UIRefreshControl) {
    NetworkManager
      .loadFriendsSJ(forUser: friendListForUserId) {
        DispatchQueue.main.async {
          self.refreshControl.endRefreshing()
        }
    }
  }
}

// MARK: - Notification Tokens
extension FriendListTableViewController {
  
  private func createSingleTargetToken() {
    testToken = usersData?.last?.observe { change in
      switch change {
      case .change(let object, let properties):
        let changes = properties.reduce("") { (res, new) in
          """
          \(res)\n\(new.name):
          \t\(new.oldValue ?? "nil")
          -> \(new.newValue ?? "nil")
          """
        }
        let user = object as? UserSJ
        #if DEBUG
//        print("""
//              Changed properties for user:
//              \(user?.lastName ?? "")\n\(changes)
//              """)
        #endif
      case .deleted:
        print("obj deleted")
      case .error(let error):
        print(error.localizedDescription)
      }
    }
  }

  private func createSearchDataNotificationToken() {
    searchDataNotificationToken = usersData?
      .observe { [weak self] result in
        switch result {
        case .initial(let usersData):
          print("Initiated with \(usersData.count)")
          self?.getSectionTitles()
          self?.tableView.reloadData()
        case .update(let users,
                     deletions: let deletions,
                     insertions: let insertions,
                     modifications: let modifications):
          #if DEBUG
//          print("""
//              New count \(users.count)
//              Deletions \(deletions)
//              Insertions \(insertions)
//              Modifications \(modifications)
//              """)
          #endif
          if !deletions.isEmpty || !insertions.isEmpty {
            self?.getSectionTitles()
            self?.tableView.reloadData()
          }
        case .error(let error):
          print(error.localizedDescription)
        }
      }
  }
}
