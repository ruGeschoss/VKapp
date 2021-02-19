//
//  MyGroupsTableViewCell.swift
//  VKapp
//
//  Created by Alexander Andrianov on 28.12.2020.
//

import UIKit

class MyGroupsTableViewCell: UITableViewCell {
    @IBOutlet weak var myGroupName: UILabel!
    @IBOutlet weak var myGroupPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        myGroupPhoto.layer.cornerRadius = myGroupPhoto.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated) 
    }
    
    func configure(forGroup: Group) {
        self.myGroupName.text = forGroup.groupName
        NetworkManager.getPhotoDataFromUrl(url: forGroup.groupAvatarSizes[0] ,completion: { [weak self] data in
            self?.myGroupPhoto.image = UIImage(data: data, scale: 0.5)
        })
    }

}