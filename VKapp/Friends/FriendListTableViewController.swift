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

class FriendListTableViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var charPicker: CharPicker!
    
    var friends:[UserModel] = [
        UserModel(userId: 1, userName: "Batz Maru", userAvatar: "Batz_Maru"),
        UserModel(userId: 2, userName: "Chococat", userAvatar: "Chococat"),
        UserModel(userId: 3, userName: "Cinnamoroll", userAvatar: "Cinnamoroll"),
        UserModel(userId: 4, userName: "My Melody", userAvatar: "My_Melody"),
        UserModel(userId: 5, userName: "Abigale", userAvatar: nil),
        UserModel(userId: 6, userName: "WadwTest", userAvatar: nil),
        UserModel(userId: 7, userName: "Atest", userAvatar: nil),
        UserModel(userId: 8, userName: "Dtest", userAvatar: nil),
        UserModel(userId: 9, userName: "YwadTest", userAvatar: nil),
        UserModel(userId: 10, userName: "Gtest", userAvatar: nil),
        UserModel(userId: 11, userName: "ZdwaTest", userAvatar: nil),
        UserModel(userId: 12, userName: "Gggggtest", userAvatar: nil),
        UserModel(userId: 13, userName: "Gztest", userAvatar: nil),
        UserModel(userId: 14, userName: "Gaztest", userAvatar: nil),
        UserModel(userId: 15, userName: "IIItest", userAvatar: nil),
        UserModel(userId: 16, userName: "Mtest", userAvatar: nil),
        UserModel(userId: 17, userName: "MadwTest", userAvatar: nil),
        UserModel(userId: 18, userName: "OooTest Test", userAvatar: nil),
        UserModel(userId: 19, userName: "OAtest test", userAvatar: nil),
        UserModel(userId: 20, userName: "Qtest", userAvatar: nil),
        UserModel(userId: 21, userName: "Gggtest", userAvatar: nil),
        UserModel(userId: 22, userName: "Dddtest", userAvatar: nil),
        UserModel(userId: 23, userName: "Atest", userAvatar: nil),
    ]
    var sortedFriends:[UserModel] = []
    var sectionTitles:[String] = []
    
    var selectedPhoto: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        sortedFriends = friends.sorted{$0.userName < $1.userName}
        
        for each in sortedFriends {
            let charForTitle = each.userName.first!
            if !sectionTitles.contains(String(charForTitle)) {
                sectionTitles.append(String(charForTitle))
            }
        }
        
        charPicker.chars = sectionTitles
        charPicker.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
                destination.userPhoto = selectedPhoto
            }
        }
    }
    
}

//MARK: Extensions

extension FriendListTableViewController: UITableViewDelegate {


    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return sectionTitles
//    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return compareByFirstChar(section).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendCell", for: indexPath) as? MyFriendsTableViewCell {
            let tmpArray = compareByFirstChar(indexPath.section)
            let friend = tmpArray[indexPath.row]
            cell.friendName.text = friend.userName
            cell.friendPhoto.image = UIImage(named: friend.userAvatar ?? "No_Image")
            return cell
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = compareByFirstChar(indexPath.section)
        selectedPhoto = user[indexPath.row].userAvatar ?? "No_Image"
        performSegue(withIdentifier: "ToMyFriendCell", sender: self)
    }
    
    
    
    
    func compareByFirstChar(_ indexInTitles: Int) -> [UserModel] {
        var tmpArray:[UserModel] = []
        for each in sortedFriends {
            if String(each.userName.first!) == sectionTitles[indexInTitles] {
                tmpArray.append(each)
            }
        }
        return tmpArray
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
