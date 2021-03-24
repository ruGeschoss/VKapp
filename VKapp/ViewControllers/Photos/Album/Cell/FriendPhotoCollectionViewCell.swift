//
//  FriendPhotoCollectionViewCell.swift
//  VKapp
//
//  Created by Alexander Andrianov on 28.12.2020.
//

import UIKit

class FriendPhotoCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var friendAlbumPhoto: UIImageView!
  
  func configure(photoUrl: String) {
    NetworkManager
      .getPhotoDataFromUrl(url: photoUrl) { [weak self] data in
        DispatchQueue.main.async {
          self?.friendAlbumPhoto.image = UIImage(data: data)
        }
      }
  }
  
}
