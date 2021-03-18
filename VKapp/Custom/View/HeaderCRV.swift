//
//  HeaderCRV.swift
//  VKapp
//
//  Created by Alexander Andrianov on 20.01.2021.
//

import UIKit

class HeaderCRV: UICollectionReusableView {
  
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var userAvatar: RoundImage!
  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var datePosted: UILabel!
  
  static let nib = UINib(nibName: "HeaderCRV", bundle: nil)
  static let identifier = "HeaderCRV"
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func configure (avatar: UIImage, name: String, date: Int) {
    self.userAvatar.image = avatar
    self.userName.text = name
    self.datePosted.text = String(date)
  }
  
  @IBAction func options(_ sender: Any) {
    print("Hello 101010101011110101111World")
  }
}
