//
//  MyGroupsTableViewController.swift
//  VKapp
//
//  Created by Alexander Andrianov on 28.12.2020.
//

import UIKit
import RealmSwift

class MyGroupsTableViewController: UITableViewController {

    var groups = [Group] ()
    var groupListForUserId = Session.shared.userId
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NetworkManager.loadGroupsSJ(forUserId: nil) { [weak self] (result) in
//            guard let self = self else { return }
//            switch result {
//            case .success(let group):
//                self.groups = group
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
        getDataFromRealm()
        tableView.reloadData()

    }

    func getDataFromRealm() {
        do {
            let realm = try Realm()
            let groupsData = realm.objects(Group.self).filter("forUserId == %@", groupListForUserId)
            self.groups = Array(groupsData)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupCell", for: indexPath) as? MyGroupsTableViewCell {
            cell.configure(forGroup: groups[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }

    //MARK: Add group
    @IBAction func addGroup(segue:UIStoryboardSegue) {
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
    
    //MARK: Remove group
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
