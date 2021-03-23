//
//  FooterCRV.swift
//  VKapp
//
//  Created by Alexander Andrianov on 20.01.2021.
//

import UIKit

class FooterCRV: UICollectionReusableView {
  
  @IBOutlet weak var footerView: UIView!
  @IBOutlet weak var viewCount: UILabel!
  @IBOutlet weak var likeButton: LikeButtonUIButton!
  @IBOutlet weak var commentButtonCounter: UIButton!
  @IBOutlet weak var shareButtonCounter: UIButton!
  
  static let nib = UINib(nibName: "FooterCRV", bundle: nil)
  static let identifier = "FooterCRV"
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func configure (viewCount: Int,
                  likeCount: Int,
                  commentCount: Int,
                  shareCount: Int) {
    self.viewCount.text = String(viewCount)
    self.commentButtonCounter.setTitle(String(commentCount), for: .normal)
    self.shareButtonCounter.setTitle(String(shareCount), for: .normal)
  }
  
  @IBAction func commentButton(_ sender: UIButton) {
  }
  @IBAction func shareButton(_ sender: UIButton) {
  }
  @IBAction func likeButton(_ sender: FooterCRV) {
  }
  
}
