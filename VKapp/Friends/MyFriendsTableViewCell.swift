//
//  MyFriendsTableViewCell.swift
//  VKapp
//
//  Created by Александр Андрианов on 29.12.2020.
//

import UIKit

class MyFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendPhoto: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
