//
//  MyGroupsTableViewCell.swift
//  VKapp
//
//  Created by Александр Андрианов on 28.12.2020.
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
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
