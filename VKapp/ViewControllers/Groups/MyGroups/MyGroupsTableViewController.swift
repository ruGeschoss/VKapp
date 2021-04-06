//
//  MyGroupsTableViewController.swift
//  VKapp
//
//  Created by Alexander Andrianov on 28.12.2020.
//

import UIKit
import RealmSwift

class MyGroupsTableViewController: UITableViewController {
  
  var groups: Results<Group>? {
    let realm = try? Realm()
    let groups = realm?.objects(Group.self).filter("forUserId == %@", groupListForUserId)
    return groups
  }
  var groupListForUserId = Session.shared.userId
  private var groupsNotificationToken: NotificationToken?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.refreshControl = refresher
    
    createGroupsNotificationToken()
  }
  
  private lazy var refresher: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = .systemGray
    refreshControl.attributedTitle = NSAttributedString(string: "Обновление...",
                                                        attributes: [.font: UIFont.systemFont(ofSize: 10)])
    refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    return refreshControl
  }()
  
  private func createGroupsNotificationToken() {
    groupsNotificationToken = groups?.observe { [weak self] result in
      switch result {
      case .initial(let groupsData):
        print("Initiated with \(groupsData.count) groups")
        self?.tableView.reloadData()
      case .update(let groups,
                   deletions: let deletions,
                   insertions: let insertions,
                   modifications: let modifications):
        print("""
              New count \(groups.count)
              Deletions \(deletions)
              Insertions \(insertions)
              Modifications \(modifications)
              """)
        self?.tableView.beginUpdates()
        let deletionsIndexPaths = deletions.map { IndexPath(row: $0, section: 0) }
        let insertionsIndexPaths = insertions.map { IndexPath(row: $0, section: 0) }
        let modificationsIndexPaths = modifications.map { IndexPath(row: $0, section: 0) }
        
        self?.tableView.deleteRows(at: deletionsIndexPaths, with: .automatic)
        self?.tableView.insertRows(at: insertionsIndexPaths, with: .automatic)
        self?.tableView.reloadRows(at: modificationsIndexPaths, with: .automatic)
        self?.tableView.endUpdates()
      case .error(let error):
        print(error.localizedDescription)
      }
    }
  }
  
  deinit {
    groupsNotificationToken?.invalidate()
  }
  
  @objc private func refresh(_ sender: UIRefreshControl) {
    NetworkManager.loadGroupsSJ(forUserId: groupListForUserId) { [weak self] in
      self?.refresher.endRefreshing()
    }
  }
  
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return groups?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupCell",
                                                for: indexPath) as? MyGroupsTableViewCell {
      cell.configure(forGroup: groups![indexPath.row])
      return cell
    }
    
    return UITableViewCell()
  }
  
  // MARK: Add group
  @IBAction func addGroup(segue: UIStoryboardSegue) {
    //        if segue.identifier == "addGroup" {
    //            guard let allGroupsController = segue.source as? AllGroupsTableViewController else { return }
    //            if let indexPath = allGroupsController.tableView.indexPathForSelectedRow {
    //                let group = allGroupsController.groups[indexPath.row]
    //                if !groups.contains(group){
    //                    groups.append(group)
    //                    tableView.reloadData()
    //                }
    //            }
    //        }
  }
  
  // MARK: Remove group
//      override func tableView(_ tableView: UITableView,
//                              commit editingStyle: UITableViewCell.EditingStyle,
//                              forRowAt indexPath: IndexPath) {
  //        if editingStyle == .delete {
  //            groups.remove(at: indexPath.row)
  //            tableView.deleteRows(at: [indexPath], with: .fade)
  //        }
  //    }
  
  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
   
   }
   */
  
  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
