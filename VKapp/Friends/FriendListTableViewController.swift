//
//  FriendListTableViewController.swift
//  VKapp
//
//  Created by Александр Андрианов on 29.12.2020.
//

import UIKit

protocol PhotoDelegate:AnyObject {
    func getPhoto(photo:String)
}

class FriendListTableViewController: UITableViewController {

    var friends:[UserModel] = [
        UserModel(userId: 1241311, userName: "Batz Maru", userAvatar: "Batz_Maru"),
        UserModel(userId: 99897, userName: "Chococat", userAvatar: "Chococat"),
        UserModel(userId: 67899, userName: "Cinnamoroll", userAvatar: "Cinnamoroll"),
        UserModel(userId: 7765433, userName: "My Melody", userAvatar: "My_Melody")
    ]
    
    weak var photoDelegate:PhotoDelegate?
// MARK: - NEED HELP!
// Не получилось отправить фото извыбранной ячейки на следующую страницу в ячейку
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToMyFriendCell" {
            if let destination = segue.destination as? FriendPhotoCollectionViewController{
                destination.userPhoto =
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendCell", for: indexPath) as? MyFriendsTableViewCell {
            let selectedFriend = friends[indexPath.row]
            cell.friendName.text = selectedFriend.userName
            cell.friendPhoto.image = UIImage(named:selectedFriend.userAvatar)

            return cell
        }

        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        photoDelegate?.getPhoto(photo: friends[indexPath.row].userAvatar)
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
