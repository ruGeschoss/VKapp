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
    self.backgroundView = self.contentView
  }
  
  // MARK: Setup
  func configureForUser(date: Int, user: UserSJ) {
    self.profileName.text = user.firstName + " " + user.lastName
    setDateToUnderline(date)
    
    NetworkManager.getPhotoDataFromUrl(url: user.photo) { data in
      DispatchQueue.main.async {
        self.profileAvatar.image = UIImage(data: data)
      }
    }
    #if DEBUG
    print("Header configured")
    #endif
  }
  
  func configureForGroup(date: Int, group: Group) {
    self.profileName.text = group.groupName
    setDateToUnderline(date)
    
    NetworkManager.getPhotoDataFromUrl(url: group.groupAvatarSizes.first!) { data in
      DispatchQueue.main.async {
        self.profileAvatar.image = UIImage(data: data)
      }
    }
    #if DEBUG
    print("Header configured")
    #endif
  }
}

extension NewsHeaderView {
  
  // MARK: - Recogniser
  private func addGestureRecogniser() {
    let tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(tappedOnProfile))
    profileStackView.addGestureRecognizer(tapGesture)
    profileStackView.isUserInteractionEnabled = true
  }
  
  // MARK: - Date formatter
  private func setDateToUnderline(_ date: Int) {
    DispatchQueue.global().async {
      let date = date.convertToDate()
      DispatchQueue.main.async {
        self.profileNameUnderline.text = date
      }
    }
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
