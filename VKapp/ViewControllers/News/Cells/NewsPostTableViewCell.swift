//
//  NewsPostTableViewCell.swift
//  VKapp
//
//  Created by Alexander Andrianov on 26.04.2021.
//

import UIKit

final class NewsPostTableViewCell: UITableViewCell {
  
  private let contentInsets = Constants.newsPostCellContentInsets
  private let cellInsets = Constants.newsPostCellInsets
  private var shouldShowFully: Bool = true
  private var shouldShowExpandButton: Bool = false
  var cellHeight: CGFloat = 0
  
  private var cellBackgroundView: UIView = {
    let background = UIView()
    background.backgroundColor = Constants.newsPostCellBackgroundcolor
    background.translatesAutoresizingMaskIntoConstraints = false
    background.autoresizesSubviews = false
    return background
  }()
  
  private var cellExpandButton: UIButton = {
    let expandButton = UIButton()
    expandButton.setTitle("Show more", for: .normal)
    expandButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
    expandButton.backgroundColor = Constants.newsPostCellBackgroundcolor
    expandButton.setTitleColor(.cyan, for: .normal)
    expandButton.translatesAutoresizingMaskIntoConstraints = false
    expandButton.addTarget(self, action: #selector(didTapOnExpandButton),
                           for: .touchUpInside)
    return expandButton
  }()
  
  private var cellTextLabel: UILabel = {
    let myTextLabel = UILabel()
    myTextLabel.translatesAutoresizingMaskIntoConstraints = false
    myTextLabel.backgroundColor = Constants.newsPostCellBackgroundcolor
    myTextLabel.numberOfLines = 0
    myTextLabel.font = UIFont.systemFont(ofSize: 13)
    return myTextLabel
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    contentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.autoresizesSubviews = false
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override var reuseIdentifier: String? {
    String(describing: NewsPostTableViewCell.self)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    renewSubviews()
//    print("""
//          TEST
//          contView bounds \(self.contentView.bounds)
//          backgView bounds \(self.contentView.subviews.first?.bounds)
//          backgrView frame \(self.contentView.subviews.first?.frame)
//          *************
//          text frame \(self.contentView.subviews[1].frame)
//          text bounds \(self.contentView.subviews[1].bounds)
//          button frame \(self.contentView.subviews[2].frame)
//          button bounds \(self.contentView.subviews[2].bounds)
//          """)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    contentView.subviews.forEach { $0.removeFromSuperview() }
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configure(text: String) {
    cellTextLabel.text = text
    renewSubviews()
  }
  
  @objc private func didTapOnExpandButton() {
    print("ContentView frame: \(self.contentView.frame)")
    print("BackgroundView frame: \(cellBackgroundView.frame)")
    print("TextLabel frame: \(cellTextLabel.frame)")
    print("ExpandButton frame: \(cellExpandButton.frame)")
    
    
//    self.contentView.subviews.first?.frame = CGRect(x: 0, y: 5, width: 150, height: 30)
//    self.contentView.subviews.first?.backgroundColor = .cyan
  }
}

extension NewsPostTableViewCell {
  
  private func getTextFrame(text: String, font: UIFont) -> CGSize {
    let insetsSumm = cellInsets.left + cellInsets.right + contentInsets.left + contentInsets.right
    let maxWidth = bounds.width - insetsSumm
    
    let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
    let textRect = text.boundingRect(
      with: textBlock, options: .usesLineFragmentOrigin,
      attributes: [.font: font], context: nil)
    
    let textWidth = Double(textRect.size.width)
    let textHeight = Double(textRect.size.height)
    let textSize = CGSize(width: ceil(textWidth), height: ceil(textHeight))
    return textSize
  }
  
  private func setupTextLabelFrame() {
    guard let text = cellTextLabel.text else { return }
    let textSize = getTextFrame(text: text, font: cellTextLabel.font)
    let textX = bounds.minX + cellInsets.left + contentInsets.left
    let textY = bounds.minY + cellInsets.top + contentInsets.top
    let textOrigin = CGPoint(x: textX, y: textY)
    
    shouldShowExpandButton = textSize.height > 100
    cellTextLabel.frame = CGRect(origin: textOrigin, size: textSize)
  }
  
  private func setupExpandButtonFrame() {
    guard shouldShowExpandButton else {
      cellExpandButton.frame = .zero
      cellExpandButton.isHidden = true
      return }
    let buttonWidth = bounds.width - cellInsets.left - cellInsets.right - contentInsets.left - contentInsets.right
    let buttonHeight = getTextFrame(text: cellExpandButton.titleLabel!.text!,
                                    font: cellExpandButton.titleLabel!.font!).height
    let buttonSize = CGSize(width: buttonWidth, height: buttonHeight)
    let buttonOrigin = CGPoint(x: cellTextLabel.frame.minX, y: cellTextLabel.frame.maxY)
    
    cellExpandButton.isHidden = false
    cellExpandButton.frame = CGRect(origin: buttonOrigin, size: buttonSize)
    
  }
  
  private func setupBackgroundFrame() {
    let backgroundHeight = shouldShowExpandButton ? cellExpandButton.frame.maxY : cellTextLabel.frame.maxY
    cellHeight = backgroundHeight
    let backgroundSize = CGSize(width: bounds.width - cellInsets.left - cellInsets.right, height: cellHeight)
    let backgroundOrigin = CGPoint(x: cellInsets.left, y: cellInsets.top)
    
    cellBackgroundView.frame = CGRect(origin: backgroundOrigin, size: backgroundSize)
    
  }
  
  private func calcFrames() {
    setupTextLabelFrame()
    setupExpandButtonFrame()
    setupBackgroundFrame()
  }
  
  private func renewSubviews() {
    calcFrames()
    contentView.subviews.forEach { $0.removeFromSuperview() }
    contentView.addSubview(cellBackgroundView)
    contentView.addSubview(cellTextLabel)
    contentView.addSubview(cellExpandButton)
  }
}
