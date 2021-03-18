//
//  AllGroupsTableViewCell.swift
//  VKapp
//
//  Created by Alexander Andrianov on 28.12.2020.
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
  
  func configure(forGroup: Group) {
    self.groupName.text = forGroup.groupName
    NetworkManager.getPhotoDataFromUrl(url: forGroup.groupAvatarSizes[0],
                                       completion: { [weak self] data in
      self?.groupPhoto.image = UIImage(data: data, scale: 0.5)
    })
  }
  
}
