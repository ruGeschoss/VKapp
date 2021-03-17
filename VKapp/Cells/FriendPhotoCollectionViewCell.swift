//
//  FriendPhotoCollectionViewCell.swift
//  VKapp
//
//  Created by Alexander Andrianov on 28.12.2020.
//

import UIKit

class FriendPhotoCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var friendAlbumPhoto: UIImageView!
  @IBAction func likeButton(_ sender: Any) {}
  
  func configure(photoUrl: String) {
    NetworkManager.getPhotoDataFromUrl(url: photoUrl ,completion: { [weak self] data in
      self?.friendAlbumPhoto.image = UIImage(data: data) //scale?
    })
  }
  
}
