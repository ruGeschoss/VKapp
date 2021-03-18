//
//  AllGroupsTableViewController.swift
//  VKapp
//
//  Created by Alexander Andrianov on 28.12.2020.
//

import UIKit

class AllGroupsTableViewController: UITableViewController {
  
  @IBOutlet weak var searchGroups: UISearchBar!
  
  var groups = [Group]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchGroups.delegate = self
    
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
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    return groups.count
  }
  
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell",
                                                for: indexPath) as? AllGroupsTableViewCell {
      cell.configure(forGroup: groups[indexPath.row])
      return cell
    }
    
    return UITableViewCell()
  }
}

extension AllGroupsTableViewController: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    guard !searchText.isEmpty else { return }
    NetworkManager.searchGroupSJ(searchText: searchText) { [weak self] (result) in
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
  
  override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    self.searchGroups.endEditing(true)
  }
  
}
/*
 // Override to support conditional editing of the table view.
 override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 */

/*
 // Override to support editing the table view.
 override func tableView(_ tableView: UITableView,
                         commit editingStyle: UITableViewCell.EditingStyle,
                         forRowAt indexPath: IndexPath) {
 if editingStyle == .delete {
 // Delete the row from the data source
 tableView.deleteRows(at: [indexPath], with: .fade)
 } else if editingStyle == .insert {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }    
 }
 */

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
