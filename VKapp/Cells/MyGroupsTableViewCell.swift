//
//  MyGroupsTableViewCell.swift
//  VKapp
//
//  Created by Alexander Andrianov on 28.12.2020.
//

import UIKit
import RealmSwift

protocol EditCellName: class {
    func editNameAlert(_ group: GroupFirebase)
}

class MyGroupsTableViewCell: UITableViewCell {
    @IBOutlet weak var myGroupName: UILabel!
    @IBOutlet weak var myGroupPhoto: UIImageView!
    
    @IBAction func renameButton(_ sender: UIButton) {
        delegate?.editNameAlert(group!)
    }
    
    weak var delegate: EditCellName?
    
    private var group: GroupFirebase? {
        didSet {
            self.myGroupName.text = group!.groupName
            self.myGroupPhoto.image = UIImage(named: "No_Image")
            
            NetworkManager.getPhotoDataFromUrl(url: group!.groupAvatar ,completion: { [weak self] data in
                self?.myGroupPhoto.image = UIImage(data: data, scale: 0.3)
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myGroupPhoto.layer.cornerRadius = myGroupPhoto.frame.width / 2
    }
    
    func configure(forGroup: GroupFirebase) {
        self.group = forGroup
    }

}
