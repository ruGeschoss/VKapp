//
//  AllGroupsTableViewController.swift
//  VKapp
//
//  Created by Александр Андрианов on 28.12.2020.
//

import UIKit

class AllGroupsTableViewController: UITableViewController {

    var groups:[GroupModel] = [
        GroupModel(groupId: 123, groupName: "Hello Kitty Fans", groupAvatar: "Batz_Maru"),
        GroupModel(groupId: 321, groupName: "HKFriens", groupAvatar: "Chococat"),
        GroupModel(groupId: 342324, groupName: "Cinnamoroll", groupAvatar: "Cinnamoroll"),
        GroupModel(groupId: 57656, groupName: "Cartoons", groupAvatar: "My_Melody"),
        GroupModel(groupId: 747, groupName: "For those who like Hello Kitty", groupAvatar: "My_Melody")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? AllGroupsTableViewCell {
            let selectedGroup = groups[indexPath.row]
            cell.groupName.text = selectedGroup.groupName
            cell.groupPhoto.image = UIImage(named: selectedGroup.groupAvatar)
            
            return cell
        }
        
        return UITableViewCell()
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

}
