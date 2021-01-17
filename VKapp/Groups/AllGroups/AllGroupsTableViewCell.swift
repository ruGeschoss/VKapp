//
//  AllGroupsTableViewCell.swift
//  VKapp
//
//  Created by Александр Андрианов on 28.12.2020.
//

import UIKit

class AllGroupsTableViewCell: UITableViewCell {
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        groupPhoto.layer.cornerRadius = groupPhoto.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
