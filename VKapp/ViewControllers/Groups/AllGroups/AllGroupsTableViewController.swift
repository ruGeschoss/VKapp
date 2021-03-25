//
//  AllGroupsTableViewController.swift
//  VKapp
//
//  Created by Alexander Andrianov on 28.12.2020.
//

import UIKit

final class AllGroupsTableViewController: UITableViewController {
  
  @IBOutlet private weak var searchGroups: UISearchBar!
  
  private var groups = [Group]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchGroups.delegate = self
    loadAllGroups()
  }
  
  override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    self.searchGroups.endEditing(true)
  }
}

// MARK: - Table view data source
extension AllGroupsTableViewController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    groups.count
  }
  
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView
        .dequeueReusableCell(withIdentifier: "GroupCell",
                             for: indexPath) as? AllGroupsTableViewCell {
      cell.configure(forGroup: groups[indexPath.row])
      return cell
    }
    
    return UITableViewCell()
  }
}

extension AllGroupsTableViewController: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar,
                 textDidChange searchText: String) {
    guard !searchText.isEmpty else { return }
    NetworkManager
      .searchGroupSJ(searchText: searchText) { [weak self] (result) in
        guard let self = self else { return }
        switch result {
        case .success(let foundGroups):
          self.groups = foundGroups
          DispatchQueue.main.async {
            self.tableView.reloadData()
          }
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
  }
}

// MARK: - Functions
extension AllGroupsTableViewController {
  
  private func loadAllGroups() {
    NetworkManager.searchGroupSJ(searchText: nil) { [weak self] (result) in
      guard let self = self else { return }
      switch result {
      case .success(let groups):
        self.groups = groups
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
}
