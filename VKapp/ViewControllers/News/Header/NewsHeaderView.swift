//
//  NewsHeaderView.swift
//  VKapp
//
//  Created by Alexander Andrianov on 03.05.2021.
//

import UIKit

final class NewsHeaderView: UITableViewHeaderFooterView {
  
  typealias Constant = Constants.News.Header
  private let backgroundInsets: UIEdgeInsets = Constant.backgroundInsets
  private let contentInsets: UIEdgeInsets = Constant.contentInsets
  
  private var backgroundHeightInsetsSumm: CGFloat {
    backgroundInsets.top + backgroundInsets.bottom
  }
  private var backgroundWidthInsetsSumm: CGFloat {
    backgroundInsets.left + backgroundInsets.right
  }
  private var contentHeightInsetsSumm: CGFloat {
    contentInsets.top + contentInsets.bottom
  }
  private var contentWidthInsetsSumm: CGFloat {
    contentInsets.left + contentInsets.right
  }
  
  private var nameLabelText: String?
  private var dateLabelText: String?
  private var avatarImage: UIImage?
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    addSubviews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    nameLabelText = nil
    dateLabelText = nil
    avatarImage = nil
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setBackgroundFrame()
    setButtonFrame()
    setProfileViewFrame()
    setAvatarFrame()
    setLabelsFrame()
  }
  
  func configure(for owner: NewsOwner, date: String) {
    nameLabelText = owner.ownerName
    dateLabelText = date
    
    NetworkManager
      .getPhotoDataFromUrl(
        url: owner.ownerAvatarURL) { [weak self] data in
        self?.avatarImage = UIImage(data: data)
        self?.layoutSubviews()
    }
  }
  
  // MARK: Actions
  @objc private func didTapOnMenuButton(sender: UIButton) {
    print(#function)
    sender.animatedSpin()
  }
  
  @objc private func didTapOnProfile(sender: UITapGestureRecognizer) {
    print(#function)
    sender.view?.animatedTap()
  }
}

// MARK: - Set frames
extension NewsHeaderView {
  
  // MARK: Background frame
  private func setBackgroundFrame() {
    guard let background = backgroundView else { return }
    
    let backgroundX = bounds.minX + backgroundInsets.left
    let backgroundY = bounds.minY + backgroundInsets.top
    let backgroundWidth = bounds.width - backgroundWidthInsetsSumm
    let backgroundHeight = bounds.height - backgroundHeightInsetsSumm
    
    let backgroundOrigin = CGPoint(x: backgroundX, y: backgroundY)
    let backgroundSIze = CGSize(width: ceil(backgroundWidth), height: ceil(backgroundHeight))
    
    background.frame = CGRect(origin: backgroundOrigin, size: backgroundSIze)
    
    let cornersToRound = Constant.cornersToRound
    let cornerRadius = Constant.cornerRadius
    background.roundCorners(corners: cornersToRound, radius: cornerRadius)
    background.backgroundColor = Constant.backgroundColor
  }
  
  // MARK: Set MenuButton Frame
  private func setButtonFrame() {
    guard
      let menuButton = contentView.subviews[1] as? UIButton
    else { return }
    
    let container = contentView.frame
    let buttonHeight = Constant.menuButtonHeight
    let menuButtonX = container.maxX - buttonHeight - backgroundInsets.right - contentInsets.right
    let menuButtonY = container.minY + backgroundInsets.top + contentInsets.top
    
    let menuButtonSize = CGSize(width: buttonHeight, height: buttonHeight)
    let menuButtonOrigin = CGPoint(x: menuButtonX, y: menuButtonY)
    
    menuButton.frame = CGRect(origin: menuButtonOrigin, size: menuButtonSize)
  }
  
  // MARK: Set ProfileView Frame
  private func setProfileViewFrame() {
    guard
      let profileView = contentView.subviews.first
    else { return }

    let container = contentView.frame
    let buttonWidth = Constant.menuButtonHeight
    let widthInsetsSumm = backgroundWidthInsetsSumm + contentWidthInsetsSumm
    let profileViewX = container.minX + backgroundInsets.left
    let profileViewY = container.minY + backgroundInsets.top
    let profileViewWidth = container.width - buttonWidth - widthInsetsSumm
    let profileViewHeight = container.height - profileViewY

    let profileViewOrigin = CGPoint(x: profileViewX, y: profileViewY)
    let profileViewSize = CGSize(width: profileViewWidth, height: profileViewHeight)
    profileView.frame = CGRect(origin: profileViewOrigin, size: profileViewSize)
  }
  
  // MARK: Set Avatar Frame
  private func setAvatarFrame() {
    guard
      let container = contentView.subviews.first,
      let shadowImageView = container.subviews.first as? UIImageView,
      let avatarImageView = shadowImageView.subviews.first as? UIImageView
    else { return }
    let avatarHeight = Constant.avatarImageHeight
    let avatarSize = CGSize(width: avatarHeight, height: avatarHeight)
    let shadowImageOrigin = CGPoint(x: contentInsets.left, y: contentInsets.top)
    
    shadowImageView.frame = CGRect(origin: shadowImageOrigin, size: avatarSize)
    avatarImageView.frame = CGRect(origin: CGPoint.zero, size: avatarSize)
    avatarImageView.image = avatarImage
  }
  
  // MARK: Set Name/Date Frames
  private func setLabelsFrame() {
    guard
      let container = contentView.subviews.first,
      let avatarImageView = container.subviews.first as? UIImageView,
      let nameLabel = container.subviews[1] as? UILabel,
      let dateLabel = container.subviews[2] as? UILabel
    else { return }
    
    let labelWidth = container.frame.width - avatarImageView.frame.maxX - contentInsets.left
    let maxLabelHeight = (container.frame.height - contentHeightInsetsSumm) / 2
    let labelX = avatarImageView.frame.maxX + contentInsets.left
    let nameLabelY = (container.frame.height / 2) - maxLabelHeight
    let dateLabelY = nameLabelY + maxLabelHeight
    
    let nameLabelOrigin = CGPoint(x: labelX, y: ceil(nameLabelY))
    let dateLabelOrigin = CGPoint(x: labelX, y: ceil(dateLabelY))
    
    let nameLabelSize = CGSize(width: labelWidth, height: ceil(maxLabelHeight))
    let dateLabelSize = CGSize(width: labelWidth, height: ceil(maxLabelHeight))
    
    nameLabel.frame = CGRect(origin: nameLabelOrigin, size: nameLabelSize)
    dateLabel.frame = CGRect(origin: dateLabelOrigin, size: dateLabelSize)
    
    nameLabel.text = nameLabelText
    dateLabel.text = dateLabelText
  }
}

// MARK: - Create Subviews
extension NewsHeaderView {
  
  private func addSubviews() {
    
    let background = createBackground()
    let menuButton = createMenuButton()
    let avatarImage = createAvatarView()
    let nameLabel = createLabel(ofSize: 14)
    let dateLabel = createLabel(ofSize: 12)
    let profileView = createBackground()
    
    let tapGesture = UITapGestureRecognizer()
    tapGesture.addTarget(self, action: #selector(didTapOnProfile(sender:)))
    
    dateLabel.textColor = .darkGray
    profileView.backgroundColor = .clear
    
    profileView.addSubview(avatarImage)
    profileView.addSubview(nameLabel)
    profileView.addSubview(dateLabel)
    
    profileView.isUserInteractionEnabled = true
    profileView.addGestureRecognizer(tapGesture)
    
    backgroundView = background
    contentView.addSubview(profileView)
    contentView.addSubview(menuButton)
  }
  
  private func createBackground() -> UIView {
    let background = UIView()
    background.backgroundColor = Constant.backgroundColor
    background.translatesAutoresizingMaskIntoConstraints = false
    return background
  }
  
  private func createLabel(ofSize size: CGFloat) -> UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.backgroundColor = .clear
    label.font = UIFont.systemFont(ofSize: size)
    label.numberOfLines = 1
    return label
  }
  
  private func createMenuButton() -> UIButton {
    let button = UIButton()
    button.backgroundColor = .clear
    button.setImage(UIImage(systemName: "scale.3d"), for: .normal)
    button.addTarget(self, action: #selector(didTapOnMenuButton), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }
  
  private func createAvatarView() -> UIImageView {
    let shadowImage = ShadowImage()
    let roundedImage = RoundImage()
    shadowImage.translatesAutoresizingMaskIntoConstraints = false
    roundedImage.translatesAutoresizingMaskIntoConstraints = false
    roundedImage.contentMode = .scaleAspectFill
    shadowImage.addSubview(roundedImage)
    return shadowImage
  }
}
