//
//  MyFriendsTableViewCell.swift
//  VKapp
//
//  Created by Alexander Andrianov on 29.12.2020.
//

import UIKit
import RealmSwift

final class MyFriendsTableViewCell: UITableViewCell {
  
  @IBOutlet private weak var friendName: UILabel!
  @IBOutlet private weak var friendPhoto: UIImageView!
  @IBOutlet private weak var avatarImage: ShadowImage!
  
  private lazy var realm = RealmManager.shared
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.backgroundColor = .clear
    addGestureRecognizer()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {}
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  func configure(forUser: UserSJ) {
    self.friendName.text =
      "\(forUser.firstName) \(forUser.lastName)"
    
    guard let photoData = forUser.photoData else {
      NetworkManager
        .getPhotoDataFromUrl(url: forUser.photo) { [weak self] data in
          DispatchQueue.main.async { [weak self] in
            self?.friendPhoto.image =
              UIImage(data: data, scale: 0.3)
          }
          try? self?.realm?
            .update(type: forUser.self,
                    primaryKeyValue: forUser.userId,
                    setNewValue: data, forField: "photoData")
      }
      return
    }
    self.friendPhoto.image = UIImage(data: photoData, scale: 0.3)
  }
}

// MARK: - Functions
extension MyFriendsTableViewCell {
  @objc private func tappedOnImage() {
    avatarImage.animatedTap()
  }
  
  private func addGestureRecognizer() {
    let tapGesture = UITapGestureRecognizer(
      target: self, action: #selector(tappedOnImage))
    avatarImage.addGestureRecognizer(tapGesture)
    avatarImage.isUserInteractionEnabled = true
  }
  
}
