//
//  NewsHeaderView.swift
//  VKapp
//
//  Created by Alexander Andrianov on 23.03.2021.
//

import UIKit

final class NewsHeaderView: UITableViewHeaderFooterView {
  @IBOutlet private weak var headerBackgroundView: UIView!
  @IBOutlet private weak var profileStackView: UIStackView!
  @IBOutlet private weak var profileAvatar: RoundImage!
  @IBOutlet private weak var profileName: UILabel!
  @IBOutlet private weak var profileNameUnderline: UILabel!
  @IBOutlet private weak var headerMenuButton: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    addGestureRecogniser()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.frame = headerBackgroundView.frame
    contentView.roundCorners(
      corners: Constants.newsHeaderCornersToRound,
      radius: Constants.newsHeaderCornerRadius)
    contentView.backgroundColor = Constants
      .newsHeaderViewBackgroundcolor
    contentView.alpha = Constants
      .newsHeaderViewBackgroudAlpha
    self.backgroundView = self.contentView
  }
  
  // MARK: Setup
  func configure() {
    #if DEBUG
    self.profileAvatar.image = UIImage(named: "Chococat")
    self.profileName.text = "Alexander Andrianov"
    self.profileNameUnderline.text = "23 марта 2021 18:31"
    print("Header configured")
    #endif
  }
  
  private func addGestureRecogniser() {
    let tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(tappedOnProfile))
    profileStackView.addGestureRecognizer(tapGesture)
    profileStackView.isUserInteractionEnabled = true
  }
  
  // MARK: - Actions
  @objc private func tappedOnProfile() {
    profileStackView.animatedTap()
  }
  
  @IBAction private func headerMenuButton(_ sender: UIButton) {
    UIView.animate(withDuration: 0.1,
                   delay: 0,
                   options: .curveLinear,
                   animations: {
      self.headerMenuButton.transform =
        CGAffineTransform(rotationAngle: -60)
    })
    UIView.animate(withDuration: 0.1,
                   delay: 0.1,
                   options: .curveLinear,
                   animations: {
      self.headerMenuButton.transform =
        CGAffineTransform.identity
    })
  }
  
}
