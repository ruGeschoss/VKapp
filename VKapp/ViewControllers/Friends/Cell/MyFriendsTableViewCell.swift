//
//  MyFriendsTableViewCell.swift
//  VKapp
//
//  Created by Alexander Andrianov on 29.12.2020.
//

import UIKit
import RealmSwift

class MyFriendsTableViewCell: UITableViewCell {
  
  @IBOutlet weak var friendName: UILabel!
  @IBOutlet weak var friendPhoto: UIImageView!
  @IBOutlet private weak var avatarImage: ShadowImage!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.backgroundColor = .clear
    let tapGesture = UITapGestureRecognizer(target: self,
                                            action: #selector(tappedOnImage))
    avatarImage.addGestureRecognizer(tapGesture)
    avatarImage.isUserInteractionEnabled = true
  }
  
  override func setSelected(_ selected: Bool,
                            animated: Bool) {
    //        super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
  @objc func tappedOnImage() {
    tapAnimation()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  private func tapAnimation() {
    avatarImage.animatedTap()
  }
  
  func configure(forUser: UserSJ) {
    self.friendName.text = "\(forUser.firstName) \(forUser.lastName)"
    
    guard let photoData = forUser.photoData else {
      NetworkManager
        .getPhotoDataFromUrl(url: forUser.photo) { [weak self] data in
          DispatchQueue.main.async {
            self?.friendPhoto.image = UIImage(data: data, scale: 0.3)
          }
        do {
          let realm = try Realm()
          realm.beginWrite()
          forUser.photoData = data
          try realm.commitWrite()
        } catch {
          print(error.localizedDescription)
        }
      }
      return
    }
    self.friendPhoto.image = UIImage(data: photoData, scale: 0.3)
  }
  
}
