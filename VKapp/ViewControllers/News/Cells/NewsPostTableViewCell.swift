//
//  NewsPostTableViewCell.swift
//  VKapp
//
//  Created by Alexander Andrianov on 24.03.2021.
//

import UIKit

final class NewsPostTableViewCell: UITableViewCell {
  @IBOutlet private weak var newsPostBackgroundView: UIView! {
    didSet {
      newsPostBackgroundView
        .translatesAutoresizingMaskIntoConstraints = false
      newsPostBackgroundView.backgroundColor =
        Constants.newsPostCellBackgroundcolor
    }
  }
  @IBOutlet private weak var newsPostText: UILabel! {
    didSet {
      newsPostText
        .translatesAutoresizingMaskIntoConstraints = false
      newsPostText.numberOfLines = 0
    }
  }
  @IBOutlet private weak var newsPostExpandButton: UIButton! {
    didSet {
      newsPostExpandButton.isHidden = true
      newsPostExpandButton.isUserInteractionEnabled = false
      newsPostExpandButton
        .translatesAutoresizingMaskIntoConstraints = false
    }
  }
  
  private var contentBounds: CGRect?
  private var shouldShowFullText: Bool = false
  var totalHeight: CGFloat {
    newsPostBackgroundView.frame.height
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    print("POST CELL LAYOUT")
    if contentBounds == nil {
      contentBounds = bounds
    }
    newsPostBackgroundView.contentMode = .redraw
    newsPostBackgroundView.frame = CGRect(x: 10, y: 0, width: 370, height: 40)
    newsPostBackgroundView.backgroundColor = .green
    newsPostBackgroundView.layoutSubviews()
    newsPostText.contentMode = .redraw
    newsPostText.frame = CGRect(x: 20, y: 5, width: 330, height: 30)
    newsPostText.backgroundColor = .red
    newsPostText.layoutSubviews()
    
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    newsPostText.text = ""
    contentBounds = nil
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    // Don't wanna set selected
  }
  
  func configure(text: String) {
    newsPostText.text = "За столом сидели \nмужики и ели \nмясом конюх угощал своих гостей \nвсе расхваливали ужин \nи хозяин весел был \nо жене своей все время говорил "
  }
  
  @IBAction func didTapOnExpandButton(_ sender: UIButton) {
    print("Should Expand or Collapse textLabel ATM")
  }
}

extension NewsPostTableViewCell {
  
  private func getLabelSize(text: String, font: UIFont) -> CGSize {
    guard let contentBounds = contentBounds else { return CGSize.zero }
    
    let textMarginsSum =
      Constants.newsPostCellContentInsets.left + Constants.newsPostCellContentInsets.right
    let backgrMarginsSum =
      Constants.newsPostCellInsets.left + Constants.newsPostCellInsets.right
    let maxWidth = contentBounds.width - textMarginsSum - backgrMarginsSum
    
    let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
    let textRect = text.boundingRect(
      with: textBlock, options: .usesLineFragmentOrigin,
      attributes: [.font: font], context: nil)
    let textWidth = Double(textRect.size.width)
    let textHeight = Double(textRect.size.height)
    let textSize = CGSize(width: ceil(textWidth), height: ceil(textHeight))
    return textSize
  }
  
  private func setTextFrame(text: String) {
    let textSize = getLabelSize(text: text, font: UIFont.systemFont(ofSize: 13))
    let textlabelX = newsPostBackgroundView.bounds.minX + newsPostText.layoutMargins.left
    let textLabelOrigin = CGPoint(x: textlabelX, y: newsPostText.layoutMargins.top)
    
    newsPostText.frame = CGRect(origin: textLabelOrigin, size: textSize)
  }
  
  private func setBackgroundFrame() {
    guard let contentBounds = contentBounds else { return }
    let backgroundX = CGPoint(x: contentBounds.minX + Constants.newsPostCellInsets.left, y: contentBounds.minY)
    let backgroundSize = CGSize(width: contentBounds.width - Constants.newsPostCellInsets.left - Constants.newsPostCellInsets.right, height: newsPostText.frame.height)
    newsPostBackgroundView.frame = CGRect(origin: backgroundX, size: backgroundSize)
  }
}
