//
//  NewsFooterView.swift
//  VKapp
//
//  Created by Alexander Andrianov on 23.03.2021.
//

import UIKit

final class NewsFooterView: UITableViewHeaderFooterView {
  @IBOutlet private weak var footerBackgroundView: UIView!
  @IBOutlet private weak var likeStackView: UIView!
  @IBOutlet private weak var commentStackView: UIView!
  @IBOutlet private weak var shareStackView: UIView!
  @IBOutlet private weak var likeImage: UIImageView!
  @IBOutlet private weak var likeCount: UILabel!
  @IBOutlet private weak var commentImage: UIImageView!
  @IBOutlet private weak var commentCount: UILabel!
  @IBOutlet private weak var shareImage: UIImageView!
  @IBOutlet private weak var shareCount: UILabel!
  @IBOutlet private weak var viewsImage: UIImageView!
  @IBOutlet private weak var viewsCount: UILabel!
  
  private var alreadyLiked = false
  private var alreadyCommented = false
  private var alreadyShared = false
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    addGestureRecogniser()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.frame = footerBackgroundView.frame
    contentView.roundCorners(
      corners: Constants.newsFooterCornersToRound,
      radius: Constants.newsFooterCornerRadius)
    contentView.backgroundColor = Constants
      .newsFooterViewBackgroundcolor
    self.backgroundView = self.contentView
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.likeImage.image =
      UIImage(systemName: "heart")
    self.likeCount.text = ""
    self.commentImage.image =
      UIImage(systemName: "message")
    self.commentCount.text = ""
    self.shareImage.image =
    UIImage(systemName: "arrowshape.turn.up.forward")
    self.shareCount.text = ""
    self.viewsCount.text = ""
  }
  
  // MARK: - Setup
  func configure(likes: Likes, comments: Comments, reposts: Reposts, views: Views) {
    #if DEBUG
    configureLikes(likes: likes)
    configureComments(comments: comments)
    configureReposts(reposts: reposts)
    configureViews(views: views)
    print("Footer configured")
    #endif
  }
}

extension NewsFooterView {
  
  // MARK: - Configure likes
  private func configureLikes(likes: Likes) {
    guard likes.canLike else {
      self.likeStackView.isHidden = true
      return
    }
    self.likeCount.text = "\(likes.count)"
    self.alreadyLiked = likes.userLikes
    if alreadyLiked {
      self.likeImage.image =
        UIImage(systemName: "heart.fill")
    }
  }
  
  // MARK: - Configure comments
  private func configureComments(comments: Comments) {
    guard comments.canPost else {
      self.commentStackView.isHidden = true
      return
    }
    self.commentCount.text = "\(comments.count)"
  }
  
  // MARK: - Configure reposts
  private func configureReposts(reposts: Reposts) {
    if reposts.userReposted {
      self.shareImage.image =
        UIImage(systemName: "arrowshape.turn.up.forward.fill")
    }
    self.shareCount.text = "\(reposts.count)"
  }
  
  // MARK: - Configure views
  private func configureViews(views: Views) {
    self.viewsCount.text = "\(views.count)"
  }
  
  // MARK: - Recognisers
  private func addGestureRecogniser() {
    let likeTap = UITapGestureRecognizer(
      target: self,
      action: #selector(tappedOnLike))
    likeStackView.addGestureRecognizer(likeTap)
    likeStackView.isUserInteractionEnabled = true
    
    let commentTap = UITapGestureRecognizer(
      target: self,
      action: #selector(tappedOnComment))
    commentStackView.addGestureRecognizer(commentTap)
    commentStackView.isUserInteractionEnabled = true
    
    let shareTap = UITapGestureRecognizer(
      target: self,
      action: #selector(tappedOnShare))
    shareStackView.addGestureRecognizer(shareTap)
    shareStackView.isUserInteractionEnabled = true
  }
  
  // MARK: - Actions
  @objc private func tappedOnLike() {
    likeStackView.animatedTap()
    
    if self.alreadyLiked {
      self.alreadyLiked = false
      let oldCount = Int(self.likeCount.text!)
      self.likeCount.text = "\(oldCount! - 1)"
      self.likeImage.image =
        UIImage(systemName: "heart")
    } else {
      self.alreadyLiked = true
      let oldCount = Int(self.likeCount.text!)
      self.likeCount.text = "\(oldCount! + 1)"
      self.likeImage.image =
        UIImage(systemName: "heart.fill")
    }
    
    #if DEBUG
    print("tappedOnLike")
    #endif
  }
  
  @objc private func tappedOnComment() {
    commentStackView.animatedTap()
    
    if alreadyCommented {
      print("Will add another comment")
    } else {
      alreadyCommented = true
      self.commentImage.image =
        UIImage(systemName: "message.fill")
      let oldCount = Int(self.commentCount.text!)
      self.commentCount.text = "\(oldCount! + 1)"
    }
    
    #if DEBUG
    print("tappedOnComment")
    #endif
  }
  
  @objc private func tappedOnShare() {
    shareStackView.animatedTap()
    
    if alreadyShared {
      print("Already shared")
    } else {
      alreadyShared = true
      let oldCount = Int(self.shareCount.text!)
      self.shareCount.text = "\(oldCount! + 1)"
      self.shareImage.image =
        UIImage(systemName: "arrowshape.turn.up.forward.fill")
    }
    
    #if DEBUG
    print("tappedOnShare")
    #endif
  }

}
