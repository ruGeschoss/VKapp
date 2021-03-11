//
//  MyGroupsTableViewCell.swift
//  VKapp
//
//  Created by Alexander Andrianov on 28.12.2020.
//

import UIKit
import RealmSwift

class MyGroupsTableViewCell: UITableViewCell {
    @IBOutlet weak var myGroupName: UILabel!
    @IBOutlet weak var myGroupPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myGroupPhoto.layer.cornerRadius = myGroupPhoto.frame.width / 2
    }
    
    func configure(forGroup: Group) {
        self.myGroupName.text = forGroup.groupName

        switch forGroup.groupAvatarData.first {
        case nil:
            NetworkManager.getPhotoDataFromUrl(url: forGroup.groupAvatarSizes[0] ,completion: { [weak self] data in
                self?.myGroupPhoto.image = UIImage(data: data, scale: 0.3)
                
                do {
                    let realm = try Realm()
                    realm.beginWrite()
                    forGroup.groupAvatarData.append(data)
                    try realm.commitWrite()
                } catch {
                    print(error.localizedDescription)
                }
            })
        default:
            self.myGroupPhoto.image = UIImage(data: forGroup.groupAvatarData[0], scale: 0.3)
        }
    }

}
