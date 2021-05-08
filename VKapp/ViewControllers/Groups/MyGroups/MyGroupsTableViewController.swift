//
//  MyGroupsTableViewController.swift
//  VKapp
//
//  Created by Alexander Andrianov on 28.12.2020.
//

import UIKit
import RealmSwift

final class MyGroupsTableViewController: UITableViewController {
  
  var groupListForUserId = Session.shared.userId
  private var groupsNotificationToken: NotificationToken?
  private lazy var realm = RealmManager.shared
  private var groups: Results<Group>? {
    realm?.getObjects(type: Group.self)
      .filter("forUserId == %@", groupListForUserId)
  }
  private lazy var refresher: UIRefreshControl = {
    return createRefreshControl()
  }()
  
  deinit {
    groupsNotificationToken?.invalidate()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.refreshControl = refresher
    createGroupsNotificationToken()
  }
}

// MARK: - Table view data source
extension MyGroupsTableViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    return groups?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView
        .dequeueReusableCell(withIdentifier: "MyGroupCell",
                             for: indexPath) as? MyGroupsTableViewCell {
      cell.configure(forGroup: groups![indexPath.row])
      return cell
    }
    
    return UITableViewCell()
  }
}

// MARK: - Refresh control
extension MyGroupsTableViewController {
  
  @objc private func refresh(_ sender: UIRefreshControl) {
    NetworkManager
      .loadGroupsSJ(forUserId: groupListForUserId) { [weak self] in
        self?.refresher.endRefreshing()
    }
  }
  
  private func createRefreshControl() -> UIRefreshControl {
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = .systemGray
    refreshControl.attributedTitle =
      NSAttributedString(
        string: "Обновление...",
        attributes: [.font: UIFont.systemFont(ofSize: 10)])
    refreshControl.addTarget(self, action: #selector(refresh(_:)),
                             for: .valueChanged)
    return refreshControl
  }
}

// MARK: - Notification token
extension MyGroupsTableViewController {
  
  private func createGroupsNotificationToken() {
    groupsNotificationToken = groups?
      .observe { [weak self] result in
        switch result {
        case .initial(let groupsData):
          print("Initiated with \(groupsData.count) groups")
          self?.tableView.reloadData()
        case .update(let groups,
                     deletions: let deletions,
                     insertions: let insertions,
                     modifications: let modifications):
          #if DEBUG
          print("""
              New count \(groups.count)
              Deletions \(deletions)
              Insertions \(insertions)
              Modifications \(modifications)
              """)
          #endif
          let deletionsIndexPaths =
            deletions.map { IndexPath(row: $0, section: 0) }
          let insertionsIndexPaths =
            insertions.map { IndexPath(row: $0, section: 0) }
          let modificationsIndexPaths =
            modifications.map { IndexPath(row: $0, section: 0) }
          
          DispatchQueue.main.async {
            self?.tableView.beginUpdates()
            self?.tableView
              .deleteRows(at: deletionsIndexPaths, with: .automatic)
            self?.tableView
              .insertRows(at: insertionsIndexPaths, with: .automatic)
            self?.tableView
              .reloadRows(at: modificationsIndexPaths, with: .automatic)
            self?.tableView.endUpdates()
          }
        case .error(let error):
          print(error.localizedDescription)
        }
      }
  }
}
