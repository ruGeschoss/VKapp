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
    
    func configure(forUser: UserFirebase) {
        self.friendName.text = "\(forUser.firstName) \(forUser.lastName)"
        self.friendPhoto.image = UIImage(named: "No_Image")
        
        NetworkManager.getPhotoDataFromUrl(url: forUser.photo) { [weak self] data in
            DispatchQueue.main.async {
                self?.friendPhoto.image = UIImage(data: data, scale: 0.3)
            }
        }
    }
    
}
