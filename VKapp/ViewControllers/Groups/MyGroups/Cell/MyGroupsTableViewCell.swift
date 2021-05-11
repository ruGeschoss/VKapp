//
//  MyGroupsTableViewCell.swift
//  VKapp
//
//  Created by Alexander Andrianov on 28.12.2020.
//

import UIKit
import RealmSwift

final class MyGroupsTableViewCell: UITableViewCell {
  @IBOutlet private weak var myGroupName: UILabel!
  @IBOutlet private weak var myGroupPhoto: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    myGroupPhoto.layer.cornerRadius =
      myGroupPhoto.frame.width / 2
  }
  
  func configure(forGroup: Group) {
    self.myGroupName.text = forGroup.groupName
    
    switch forGroup.groupAvatarData.first {
    case nil:
      getPhoto(forGroup)
    default:
      self.myGroupPhoto.image =
        UIImage(data: forGroup.groupAvatarData[0], scale: 0.3)
    }
  }
}

extension MyGroupsTableViewCell {
  /// Loadphoto, set it as avatar and store to realm.
  private func getPhoto(_ forGroup: Group) {
      NetworkManager
        .getPhotoDataFromUrl(
          url: forGroup.groupAvatarSizes[0],
          completion: { [weak self] data in
            
            DispatchQueue.main.async {
              self?.myGroupPhoto.image =
                UIImage(data: data, scale: 0.3)
            }
            do {
              let realm = try Realm()
              realm.beginWrite()
              forGroup.groupAvatarData.append(data)
              try realm.commitWrite()
            } catch {
              print(error.localizedDescription)
            }
          })
  }
  
}
