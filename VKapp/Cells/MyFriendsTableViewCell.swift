//
//  MyFriendsTableViewCell.swift
//  VKapp
//
//  Created by Alexander Andrianov on 29.12.2020.
//

import UIKit

class MyFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendPhoto: UIImageView!
    @IBOutlet weak var avatarImage: ShadowImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
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

    func tapAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            self.avatarImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        })
        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveLinear, animations: {
            self.avatarImage.transform = CGAffineTransform.identity
        })
    }
}
