//
//  NewsPostTableViewCell.swift
//  VKapp
//
//  Created by Alexander Andrianov on 26.04.2021.
//

import UIKit

protocol ForcedCellUpdateDelegate: AnyObject {
  func updateCellHeight(newConfig: CellConfiguration)
}

final class NewsPostTableViewCell: UITableViewCell {
  
  typealias K = Constants.News.PostCell
  private let contentInsets = K.cellContentInsets
  private let cellInsets = K.cellInsets
  private let heightLimit = K.contentHeightLimit
  
  private let cellInsetsSumm = K.cellInsets.left + K.cellInsets.right
  private let contentInsetsSumm =
    K.cellContentInsets.left + K.cellContentInsets.right
  private var insetsSumm: CGFloat { cellInsetsSumm + contentInsetsSumm }
  
  private var shouldShowExpandButton: Bool = false
  private var contentText: String?
  weak var delegate: ForcedCellUpdateDelegate?
  var cellConfig: CellConfiguration?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    
    let background = createBackgroundView()
    let content = createTextLabel()
    let button = createExpandButton()
    
    contentView.addSubview(background)
    contentView.addSubview(content)
    contentView.addSubview(button)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupSubviews()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    shouldShowExpandButton = false
    contentText = nil
    delegate = nil
    cellConfig = nil
  }
  
  // MARK: Configure
  func configure(news: NewsPostModel) {
    contentText = news.text
    setupSubviews()
  }
  
  // MARK: Button Action
  @objc private func didTapOnExpandButton(sender: UIButton!) {
    guard
      let delegate = delegate,
      cellConfig != nil,
      let isExpanded = cellConfig?.isExpanded
    else { return }
    
    cellConfig?.isExpanded = !isExpanded
    setupSubviews()
    delegate.updateCellHeight(newConfig: cellConfig!)
  }
}

// MARK: - Update frames
extension NewsPostTableViewCell {
  
  private func setupSubviews() {
    guard cellConfig != nil else { return }
    setupTextLabelFrame()
    setupExpandButtonFrame()
    setupBackgroundFrame()
  }
  
  // MARK: Get Text Frame
  private func getTextFrame(text: String, font: UIFont,
                            heightLimit: CGFloat?) -> CGSize {
    let maxWidth = cellConfig!.superviewWidth - insetsSumm
    let textBlock = CGSize(width: maxWidth, height: heightLimit ?? CGFloat.greatestFiniteMagnitude)
    let textRect = text.boundingRect(
      with: textBlock, options: .usesLineFragmentOrigin,
      attributes: [.font: font], context: nil)
    
    let textWidth = Double(maxWidth)
    let textHeight = Double(textRect.size.height)
    let textSize = CGSize(width: ceil(textWidth), height: ceil(textHeight))
    return textSize
  }
  
  // MARK: Set Text Frame
  private func setupTextLabelFrame() {
    guard
      let text = contentText,
      let textLabel = contentView.subviews[1] as? UILabel,
      let isExpanded = cellConfig?.isExpanded
    else { return }
    
    var textSize = getTextFrame(text: text, font: textLabel.font,
                                heightLimit: nil)
    let textX = bounds.minX + cellInsets.left + contentInsets.left
    let textY = bounds.minY + cellInsets.top + contentInsets.top
    let textOrigin = CGPoint(x: textX, y: textY)
    
    shouldShowExpandButton = textSize.height >= heightLimit
    if !isExpanded, shouldShowExpandButton {
      textSize = getTextFrame(text: text, font: textLabel.font,
                              heightLimit: heightLimit)
    }
    textLabel.text = text
    textLabel.frame = CGRect(origin: textOrigin, size: textSize)
  }
  
  // MARK: Set Button Frame
  private func setupExpandButtonFrame() {
    guard let textLabel = contentView.subviews[1] as? UILabel,
          let expandButton = contentView.subviews[2] as? UIButton,
          let isExpanded = cellConfig?.isExpanded
    else { return }
    
    guard shouldShowExpandButton else {
      expandButton.frame = .zero
      expandButton.isHidden = true
      expandButton.isUserInteractionEnabled = false
      return
    }
    
    let moreTitle = K.buttonMoreTitle
    let lessTitle = K.buttonLessTitle
    let buttonTitle = isExpanded ? lessTitle : moreTitle
    expandButton.setTitle(buttonTitle, for: .normal)
    
    let buttonWidth = cellConfig!.superviewWidth - insetsSumm
    let buttonHeight = getTextFrame(text: expandButton.titleLabel!.text!,
                                    font: expandButton.titleLabel!.font!,
                                    heightLimit: nil).height
    let buttonSize = CGSize(width: buttonWidth, height: buttonHeight)
    let buttonOrigin = CGPoint(x: textLabel.frame.minX, y: textLabel.frame.maxY)
    
    expandButton.isHidden = false
    expandButton.isUserInteractionEnabled = true
    expandButton.frame = CGRect(origin: buttonOrigin, size: buttonSize)
    
  }
  
  // MARK: Set Background Frame
  private func setupBackgroundFrame() {
    guard
      let background = contentView.subviews.first,
      let textLabel = contentView.subviews[1] as? UILabel,
      let expandButton = contentView.subviews[2] as? UIButton
    else { return }
    
    let backgroundHeight = shouldShowExpandButton ?
      expandButton.frame.maxY : textLabel.frame.maxY
    
    cellConfig?.height = backgroundHeight + contentInsets.bottom
    
    let backgroundOrigin = CGPoint(x: cellInsets.left, y: cellInsets.top)
    let backgroundSize = CGSize(width: cellConfig!.superviewWidth - cellInsetsSumm,
                                height: cellConfig!.height)
    
    background.frame = CGRect(origin: backgroundOrigin, size: backgroundSize)
  }
}

// MARK: - Create Subviews
extension NewsPostTableViewCell {
  
  private func createBackgroundView() -> UIView {
    let background = UIView()
    background.backgroundColor = K.backgroundColor
    background.translatesAutoresizingMaskIntoConstraints = false
    return background
  }
  
  private func createExpandButton() -> UIButton {
    let expandButton = UIButton()
    expandButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
    expandButton.backgroundColor = .clear
    expandButton.setTitleColor(.cyan, for: .normal)
    expandButton.translatesAutoresizingMaskIntoConstraints = false
    expandButton.addTarget(self, action: #selector(didTapOnExpandButton),
                                 for: .touchUpInside)
    return expandButton
  }
  
  private func createTextLabel() -> UILabel {
    let myTextLabel = UILabel()
    myTextLabel.translatesAutoresizingMaskIntoConstraints = false
    myTextLabel.backgroundColor = .clear
    myTextLabel.numberOfLines = 0
    myTextLabel.font = UIFont.systemFont(ofSize: 13)
    return myTextLabel
  }
}
