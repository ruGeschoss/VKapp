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
    @IBOutlet weak var avatarImage: ShadowImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnImage))
        avatarImage.addGestureRecognizer(tapGesture)
        avatarImage.isUserInteractionEnabled = true
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @objc func tappedOnImage() {
        tapAnimation()
    }

    private func tapAnimation() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
            self.avatarImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        })
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            self.avatarImage.transform = CGAffineTransform.identity
        })
    }
    
    func configure(forUser: UserSJ) {
        self.friendName.text = "\(forUser.firstName) \(forUser.lastName)"
        
        switch forUser.photoData {
        case nil:
            NetworkManager.getPhotoDataFromUrl(url: forUser.photo ,completion: { [weak self] data in
                self?.friendPhoto.image = UIImage(data: data, scale: 0.3)
                do {
                    let realm = try Realm()
                    realm.beginWrite()
                    forUser.photoData = data
                    try realm.commitWrite()
                } catch {
                    print(error.localizedDescription)
                }
            })
        default:
            self.friendPhoto.image = UIImage(data: forUser.photoData!, scale: 0.3)
        }
        
    }
    
}
