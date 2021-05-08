//
//  NewsPostTableViewCell.swift
//  VKapp
//
//  Created by Alexander Andrianov on 24.03.2021.
//

import UIKit

final class NewsPostTableViewCell: UITableViewCell {
  @IBOutlet private weak var newsPostBackgroundView: UIView!
  @IBOutlet private weak var newsPostText: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupUI()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.newsPostText.text = ""
    self.backgroundView?.backgroundColor = .clear
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    // Don't wanna set selected
  }
  
  func configure(text: String) {
      self.newsPostText.text = text
  }
  
  private func setupUI() {
    self.newsPostBackgroundView.backgroundColor =
      Constants.newsPostCellBackgroundcolor
  }
}
