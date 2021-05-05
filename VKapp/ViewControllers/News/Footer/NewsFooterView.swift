//
//  NewsFooterView.swift
//  VKapp
//
//  Created by Alexander Andrianov on 23.03.2021.
//

import UIKit

final class NewsFooterView: UITableViewHeaderFooterView {
  
  private let backgroundInsets: UIEdgeInsets = Constants.newsFooterBackgroundInsets
  private let contentInsets: UIEdgeInsets = Constants.newsFooterContentInsets
  
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
  
  private var newsPost: NewsPostModel?
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    addSubviews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    newsPost = nil
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupFrames()
  }
  
  func configure(post: NewsPostModel) {
    newsPost = post
    setupFrames()
  }
  
  // MARK: - Actions
  @objc private func didTapOnLikeButton(sender: UIButton) {
    print(#function)
    sender.animatedTap()
  }
  
  @objc private func didTapOnCommentButton(sender: UIButton) {
    print(#function)
    sender.animatedTap()
  }
  
  @objc private func didTapOnRepostButton(sender: UIButton) {
    print(#function)
    sender.animatedTap()
  }
}

// MARK: Set frames
extension NewsFooterView {
  
  private func setupFrames() {
    setBackgroundFrame()
    setLikeButtonFrame()
    setCommentButtonFrame()
    setRepostButtonFrame()
    setViewsCountFrame()
  }
  
  // MARK: Set background frame
  private func setBackgroundFrame() {
    guard let background = backgroundView else { return }
    
    let backgroundX = bounds.minX + backgroundInsets.left
    let backgroundY = bounds.minY + backgroundInsets.top
    let backgroundWidth = bounds.width - backgroundWidthInsetsSumm
    let backgroundHeight = bounds.height - backgroundHeightInsetsSumm
    
    let backgroundOrigin = CGPoint(x: backgroundX, y: backgroundY)
    let backgroundSIze = CGSize(width: ceil(backgroundWidth), height: ceil(backgroundHeight))
    
    background.frame = CGRect(origin: backgroundOrigin, size: backgroundSIze)
    
    let cornersToRound = Constants.newsFooterCornersToRound
    let cornerRadius = Constants.newsFooterCornerRadius
    background.roundCorners(corners: cornersToRound, radius: cornerRadius)
    background.backgroundColor = Constants.newsFooterViewBackgroundcolor
  }
  
  // MARK: Set like button frame
  private func setLikeButtonFrame() {
    guard
      let likeButton = contentView.subviews.first as? UIButton,
      let likes = newsPost?.likes
    else { return }
    
    let buttonHeight = Constants.newsFooterButtonsHeight
    let buttonWidth = buttonHeight * 2 + likeButton.titleEdgeInsets.left
    let availableHeight = contentView.bounds.height
    let buttonY = (availableHeight - buttonHeight) / 2
    let buttonX = contentView.bounds.minX + backgroundInsets.left + contentInsets.left
    
    let buttonSize = CGSize(width: buttonWidth, height: buttonHeight)
    let buttonOrigin = CGPoint(x: buttonX, y: buttonY)
    
    likeButton.frame = CGRect(origin: buttonOrigin, size: buttonSize)
    
    likeButton.isHidden = !likes.canLike
    
    let image = likes.userLikes ?
      UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    let title = likes.count.shortStringVersion
    
    likeButton.setTitleColor(.black, for: .normal)
    likeButton.setImage(image, for: .normal)
    likeButton.setTitle(title, for: .normal)
    likeButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    
  }
  
  // MARK: Set comment button frame
  private func setCommentButtonFrame() {
    guard let likeButton = contentView.subviews.first as? UIButton,
          let commentButton = contentView.subviews[1] as? UIButton,
          let comments = newsPost?.comments
    else { return }
    
    let buttonHeight = Constants.newsFooterButtonsHeight
    let buttonWidth = buttonHeight * 2 + commentButton.titleEdgeInsets.left
    let buttonY = likeButton.frame.minY
    let buttonX = likeButton.frame.maxX
    
    let buttonSize = CGSize(width: buttonWidth, height: buttonHeight)
    let buttonOrigin = CGPoint(x: buttonX, y: buttonY)
    
    commentButton.frame = CGRect(origin: buttonOrigin, size: buttonSize)
    
    commentButton.isHidden = !comments.canPost
    
    let image = UIImage(systemName: "message")
    let title = comments.count.shortStringVersion
    
    commentButton.setTitleColor(.black, for: .normal)
    commentButton.setImage(image, for: .normal)
    commentButton.setTitle(title, for: .normal)
    commentButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    
  }
  
  // MARK: Set repost button frame
  private func setRepostButtonFrame() {
    guard
      let commentButton = contentView.subviews[1] as? UIButton,
      let repostButton = contentView.subviews[2] as? UIButton,
      let likes = newsPost?.likes,
      let reposts = newsPost?.reposts
    else { return }
    
    let buttonHeight = Constants.newsFooterButtonsHeight
    let buttonWidth = buttonHeight * 2 + repostButton.titleEdgeInsets.left
    let buttonY = commentButton.frame.minY
    let buttonX = commentButton.frame.maxX
    
    let buttonSize = CGSize(width: buttonWidth, height: buttonHeight)
    let buttonOrigin = CGPoint(x: buttonX, y: buttonY)
    
    repostButton.frame = CGRect(origin: buttonOrigin, size: buttonSize)
    
    repostButton.isHidden = !likes.canPublish
    
    let image = reposts.userReposted ?
      UIImage(systemName: "arrowshape.turn.up.forward.fill") : UIImage(systemName: "arrowshape.turn.up.forward")
    let title = reposts.count.shortStringVersion
    
    repostButton.setTitleColor(.black, for: .normal)
    repostButton.setImage(image, for: .normal)
    repostButton.setTitle(title, for: .normal)
    repostButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    
  }
  
  // MARK: Set views count frame
  private func setViewsCountFrame() {
    guard let viewsCount = contentView.subviews[3] as? UIButton,
          let views = newsPost?.views
    else { return }
    
    let image = UIImage(systemName: "eye.circle")
    let title = views.count.shortStringVersion
    let titleWidth = title.width(withConstrainedHeight: 30, font: UIFont.systemFont(ofSize: 10))
    
    let buttonHeight = Constants.newsFooterButtonsHeight / 1.5
    let buttonWidth = buttonHeight + titleWidth + viewsCount.titleEdgeInsets.left
    let buttonY = (contentView.bounds.height - buttonHeight) / 2
    let buttonX = contentView.bounds.maxX - buttonWidth - backgroundInsets.right - contentInsets.right
    
    let buttonSize = CGSize(width: ceil(buttonWidth), height: ceil(buttonHeight))
    let buttonOrigin = CGPoint(x: buttonX, y: buttonY)
    
    viewsCount.frame = CGRect(origin: buttonOrigin, size: buttonSize)
    
    viewsCount.setTitleColor(.darkGray, for: .normal)
    viewsCount.setImage(image, for: .normal)
    viewsCount.setTitle(title, for: .normal)
    viewsCount.titleLabel?.font = UIFont.systemFont(ofSize: 10)
    viewsCount.isUserInteractionEnabled = false
    
  }
}

// MARK: Add subviews
extension NewsFooterView {
  
  private func addSubviews() {
    
    let background = createBackground()
    let likeButton = createButton()
    let commentButton = createButton()
    let repostButton = createButton()
    let viewsCount = createButton()
    
    likeButton.addTarget(self, action: #selector(didTapOnLikeButton(sender:)), for: .touchUpInside)
    commentButton.addTarget(self, action: #selector(didTapOnCommentButton(sender:)), for: .touchUpInside)
    repostButton.addTarget(self, action: #selector(didTapOnRepostButton(sender:)), for: .touchUpInside)
    
    backgroundView = background
    contentView.addSubview(likeButton)
    contentView.addSubview(commentButton)
    contentView.addSubview(repostButton)
    contentView.addSubview(viewsCount)
  }
  
  private func createBackground() -> UIView {
    let background = UIView()
    background.backgroundColor = Constants.newsHeaderViewBackgroundcolor
    background.translatesAutoresizingMaskIntoConstraints = false
    return background
  }
  
  private func createButton() -> UIButton {
    let button = UIButton()
    button.backgroundColor = .none
    button.translatesAutoresizingMaskIntoConstraints = false
    button.contentVerticalAlignment = .center
    button.contentHorizontalAlignment = .leading
    button.titleEdgeInsets.left = 5
    return button
  }
}
