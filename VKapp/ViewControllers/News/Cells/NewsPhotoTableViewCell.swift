//
//  NewsPhotoTableViewCell.swift
//  VKapp
//
//  Created by Alexander Andrianov on 24.03.2021.
//

import UIKit

final class NewsPhotoTableViewCell: UITableViewCell {
  @IBOutlet private weak var cellBackgroundView: UIView! {
    didSet {
      self.cellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    }
  }
  
  @IBOutlet private weak var cellImageView: UIImageView! {
    didSet {
      self.cellImageView.translatesAutoresizingMaskIntoConstraints = false
      cellImageView.contentMode = .scaleAspectFit
    }
  }
  
  private let inset: CGFloat = 10
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupUI()
    layoutCellBackgroundView()
    layoutCellImageView()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
  }
  
  func configure(image: UIImage?) {
    cellImageView.image = image ?? UIImage(named: "No_Image")!
    layoutCellBackgroundView()
    layoutCellImageView()
  }
  
  private func setupUI() {
    self.cellBackgroundView.backgroundColor =
      Constants.newsPhotoCellBackgroundcolor
  }
  
  private func layoutCellImageView() {
    guard let image = cellImageView.image else {
      cellBackgroundView.frame = bounds
      cellImageView.frame = CGRect(
        x: bounds.minX + inset, y: bounds.minY,
        width: bounds.width - inset * 2, height: bounds.height)
      return
    }
    
    let aspect = image.size.width / image.size.height
    let width = bounds.width - inset * 2
    
    let imageHeight = aspect < 1 ? width : width / aspect
    let imageWidth = imageHeight * aspect
    let imageX = (width - imageWidth) / 2
    let imageOrigin = CGPoint(x: imageX, y: 0)
    let imageSize = CGSize(width: ceil(imageWidth), height: ceil(imageHeight))
    self.cellImageView.frame = CGRect(origin: imageOrigin, size: imageSize)
    cellImageView.layoutSubviews()
  }
  
  private func layoutCellBackgroundView() {
    let width = bounds.width - inset * 2
    let height = bounds.height
    let backgroundOrigin = CGPoint(x: bounds.minX + inset, y: bounds.minY)
    let backgroundSize = CGSize(width: ceil(width), height: ceil(height))
    self.cellBackgroundView.frame = CGRect(
      origin: backgroundOrigin, size: backgroundSize)
    cellBackgroundView.layoutSubviews()
  }
}
