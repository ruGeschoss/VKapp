//
//  MyGroupsTableViewController.swift
//  VKapp
//
//  Created by Alexander Andrianov on 28.12.2020.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore

class MyGroupsTableViewController: UITableViewController {

    var groups = [GroupFirebase]()
    var groupListForUserId = Session.shared.userId
    
    //Firebase Database
    let appUserRef = Database.database().reference(withPath: "appUsers/\(Session.shared.userId)")
    
    //Firebase Firestore
    let appUserCollection = Firestore.firestore().collection("AppUsers").document(Session.shared.userId)
    var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.refreshControl = refresher
        
        switch FirebaseConfig.databaseType {
        case .database:
            appUserRef.child("groups").observe(.value) { [weak self] (snapshot) in
                self?.groups.removeAll()
                guard !snapshot.children.allObjects.isEmpty else {
                    NetworkManager.loadGroupsSJ(forUserId: self?.groupListForUserId) {
                        self?.tableView.reloadData()
                    }
                    return
                }
                for child in snapshot.children {
                    guard let child = child as? DataSnapshot,
                          let group = GroupFirebase(snapshot: child) else { continue }
                    self?.groups.append(group)
                }
                self?.tableView.reloadData()
            }
        case .firestore:
            listener = appUserCollection.collection("Groups").addSnapshotListener { [weak self] (snapshot, error) in
                self?.groups.removeAll()
                guard let snapshot = snapshot,
                      !snapshot.documents.isEmpty else {
                    NetworkManager.loadGroupsSJ(forUserId: self?.groupListForUserId) {
                        self?.tableView.reloadData()
                    }
                    return
                }
                for doc in snapshot.documents {
                    guard let group = GroupFirebase(dict: doc.data()) else { continue }
                    self?.groups.append(group)
                }
                self?.tableView.reloadData()
            }
        }
    }
    
    private lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemGray
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление...", attributes: [.font: UIFont.systemFont(ofSize: 10)])
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    deinit {
        switch FirebaseConfig.databaseType {
        case .database:
            appUserRef.removeAllObservers()
        case .firestore:
            listener?.remove()
        }
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
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupCell", for: indexPath) as? MyGroupsTableViewCell {
            cell.configure(forGroup: groups[indexPath.row])
            cell.delegate = self
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch FirebaseConfig.databaseType {
            case .database:
                let group = groups[indexPath.row]
                group.ref?.removeValue { [weak self] (error, ref) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        self?.tableView.reloadData()
                    }
                }
            case .firestore:
                appUserCollection.collection("Groups").document(groups[indexPath.row].groupId).delete { [weak self] (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        self?.tableView.reloadData()
                    }
                }
            }
        }
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

//MARK: Cell delegate
extension MyGroupsTableViewController: EditCellName {
    
    func editNameAlert(_ group: GroupFirebase) {
        let alert = UIAlertController(title: "Редактирование группы",
                                      message: "Введите новое название для группы",
                                      preferredStyle: .alert)
        alert.addTextField { (groupTextField) in
            groupTextField.placeholder = "Название группы"
            groupTextField.text = group.groupName
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            guard let newName = alert.textFields?[0].text,
                  newName != group.groupName else { return }
            
            let modifiedGroup = group
            modifiedGroup.groupName = newName
            
            switch FirebaseConfig.databaseType {
            case .database:
                self.appUserRef.child("groups")
                    .child(group.groupId)
                    .setValue(modifiedGroup.toAnyObj()) { [weak self] (error, _) in
                        
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        self?.tableView.reloadData()
                    }
                }
            case .firestore:
                self.appUserCollection.collection("Groups")
                    .document(group.groupId)
                    .setData(modifiedGroup.toAnyObj()) { [weak self] (error) in
                        
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        self?.tableView.reloadData()
                    }
                }
            }
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
