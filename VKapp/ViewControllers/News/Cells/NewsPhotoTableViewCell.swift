//
//  NewsPhotoTableViewCell.swift
//  VKapp
//
//  Created by Alexander Andrianov on 24.03.2021.
//

import UIKit

final class NewsPhotoTableViewCell: UITableViewCell {
  
  typealias Constant = Constants.News.PhotoCell
  private let cellInsets = Constant.cellInsets
  private let contentInsets = Constant.cellContentInsets
  private var cellInsetsSumm: CGFloat {
    cellInsets.left + cellInsets.right
  }
  private var contentInsetsSumm: CGFloat {
    contentInsets.left + contentInsets.right
  }
  private var insetsSumm: CGFloat {
    cellInsetsSumm + contentInsetsSumm
  }
  
  private var contentNews: NewsPostModel?
  private var contentImage: UIImage?
  var cellConfig: CellConfiguration?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    
    let background = createBackgroundView()
    let contentImage = createContentImageView()
    
    contentView.addSubview(background)
    contentView.addSubview(contentImage)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupFrames()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    cellConfig = nil
    contentNews = nil
    if let content = contentView.subviews[1] as? UIImageView {
      content.image = nil
    }
  }
  
  // MARK: Configure
  func configure(news: NewsPostModel, image: UIImage) {
    contentNews = news
    contentImage = image
    setupFrames()
  }
}

// MARK: - Setup frames
extension NewsPhotoTableViewCell {
  
  private func setupFrames() {
    guard cellConfig != nil else { return }
    setupContentImageView()
    setupBackgroundView()
  }
  
  // MARK: Set Content frame
  private func setupContentImageView() {
    guard
      let news = contentNews,
      news.photoAttachments.count > 0,
      let contentImageView = contentView.subviews[1] as? UIImageView
    else { return }
    
    let maxWidth = cellConfig!.superviewWidth - cellInsetsSumm
    let maxContentWitdh = maxWidth - contentInsetsSumm
    let aspect = CGFloat(news.photoAttachments.first!.aspectRatio)
    let cellContentHeight =
      aspect > 1 ? maxContentWitdh / aspect : maxContentWitdh
    let cellContentWidth =
      aspect < 1 ? maxContentWitdh * aspect : maxContentWitdh 
    let contentSize =
      CGSize(width: ceil(cellContentWidth), height: ceil(cellContentHeight))
    
    let contentX = (cellConfig!.superviewWidth - cellContentWidth) / 2
    let contentOrigin = CGPoint(x: ceil(contentX), y: contentInsets.top)
    
    contentImageView.frame = CGRect(origin: contentOrigin, size: contentSize)
    contentImageView.image = contentImage
  }
  
  // MARK: Set Background Frame
  private func setupBackgroundView() {
    guard
      let backgroundView = contentView.subviews.first,
      let contentImageView = contentView.subviews[1] as? UIImageView
    else { return }
    
    let maxWidth = cellConfig!.superviewWidth - cellInsetsSumm
    let heightInsetsSumm = contentInsets.top + contentInsets.bottom
    let cellHeight = contentImageView.frame.height + heightInsetsSumm
    let cellOrigin =
      CGPoint(x: bounds.minX + cellInsets.left, y: cellInsets.top)
    let cellSize = CGSize(width: ceil(maxWidth), height: ceil(cellHeight))
    cellConfig?.height = cellSize.height + cellInsets.bottom
    backgroundView.frame = CGRect(origin: cellOrigin, size: cellSize)
  }
}

// MARK: - Create Subviews
extension NewsPhotoTableViewCell {
  
  private func createBackgroundView() -> UIView {
    let background = UIView()
    background.translatesAutoresizingMaskIntoConstraints = false
    background.backgroundColor = Constant.backgroundColor
    return background
  }
  
  private func createContentImageView() -> UIImageView {
    let contentImage = UIImageView()
    contentImage.translatesAutoresizingMaskIntoConstraints = false
    contentImage.backgroundColor = Constant.backgroundColor
    contentImage.contentMode = .scaleToFill
    return contentImage
  }
}
