//
//  NewsPhotoTableViewCell.swift
//  VKapp
//
//  Created by Alexander Andrianov on 24.03.2021.
//

import UIKit

final class NewsPhotoTableViewCell: UITableViewCell {
  @IBOutlet private weak var cellBackgroundView: UIView!
  @IBOutlet private weak var cellImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupUI()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.cellImageView.image = nil
    self.backgroundView?.backgroundColor = .clear
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    // Don't wanna set selected
  }
  
  func configure(url: String) {
    NetworkManager.getPhotoDataFromUrl(url: url) { data in
      DispatchQueue.main.async {
        self.cellImageView.image = UIImage(data: data)
      }
    }
  }
  
  private func setupUI() {
    self.cellBackgroundView.backgroundColor =
      Constants.newsPhotoCellBackgroundcolor
  }
  
}
