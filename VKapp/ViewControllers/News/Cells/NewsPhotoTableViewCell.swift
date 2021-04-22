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
    self.cellImageView.image = nil
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
  }
  
  func configure(image: UIImage?) {
    guard let image = image else { return }
    cellImageView.image = image
    layoutCellBackgroundView()
    layoutCellImageView()
  }
  
  private func setupUI() {
    self.cellBackgroundView.backgroundColor =
      Constants.newsPhotoCellBackgroundcolor
  }
  
  private func layoutCellImageView() {
    print(
      """
      /n
      *******STARTED LAYING OUT CELLIMAGEVIEW******
      superView.frame = \(frame)
      superview.bounds = \(bounds)
      cellBackgroundView.frame = \(cellBackgroundView.frame)
      cellBackgroundView.bounds = \(cellBackgroundView.bounds)
      cellImageView.frame = \(cellImageView.frame)
      cellImageView.bounds = \(cellImageView.bounds)
      *********************************************
      /n
      """)
    guard let image = cellImageView.image else {
      cellBackgroundView.frame = bounds
      cellImageView.frame = CGRect(
        x: bounds.minX + inset, y: bounds.minY,
        width: ceil(bounds.width - inset * 2), height: ceil(bounds.height))
      print(
        """
        /n
        *******QUIT BY GUARD FROM LAYING OUT CELLIMAGEVIEW******
        superView.frame = \(frame)
        superview.bounds = \(bounds)
        cellBackgroundView.frame = \(cellBackgroundView.frame)
        cellBackgroundView.bounds = \(cellBackgroundView.bounds)
        cellImageView.frame = \(cellImageView.frame)
        cellImageView.bounds = \(cellImageView.bounds)
        *********************************************
        /n
        """)
      return
    }
    
    let aspect = image.size.width / image.size.height
    let width = bounds.width - inset * 2
    
    let imageHeight = aspect < 1 ? width : width / aspect
    let imageWidth = imageHeight * aspect
    let imageX = (width - imageWidth) / 2
    let imageOrigin = CGPoint(x: ceil(imageX), y: 0)
    let imageSize = CGSize(width: ceil(imageWidth), height: ceil(imageHeight))
    self.cellImageView.frame = CGRect(origin: imageOrigin, size: imageSize)
    cellImageView.layoutSubviews()
    print(
      """
      /n
      *******FINISHED LAYING OUT CELLIMAGEVIEW******
      superView.frame = \(frame)
      superview.bounds = \(bounds)
      cellBackgroundView.frame = \(cellBackgroundView.frame)
      cellBackgroundView.bounds = \(cellBackgroundView.bounds)
      cellImageView.frame = \(cellImageView.frame)
      cellImageView.bounds = \(cellImageView.bounds)
      *********************************************
      /n
      """)
  }
  
  private func layoutCellBackgroundView() {
    print(
      """
      /n
      *******STARTED LAYING OUT CELLBACKGROUNDVIEW******
      superView.frame = \(frame)
      superview.bounds = \(bounds)
      cellBackgroundView.frame = \(cellBackgroundView.frame)
      cellBackgroundView.bounds = \(cellBackgroundView.bounds)
      cellImageView.frame = \(cellImageView.frame)
      cellImageView.bounds = \(cellImageView.bounds)
      *********************************************
      /n
      """)
    let width = bounds.width - inset * 2
    let height = bounds.height
    let backgroundOrigin = CGPoint(x: bounds.minX + inset, y: bounds.minY)
    let backgroundSize = CGSize(width: ceil(width), height: ceil(height))
    self.cellBackgroundView.frame = CGRect(
      origin: backgroundOrigin, size: backgroundSize)
    cellBackgroundView.layoutSubviews()
    print(
      """
      /n
      *******FINISHED LAYING OUT CELLBACKGROUNDVIEW******
      superView.frame = \(frame)
      superview.bounds = \(bounds)
      cellBackgroundView.frame = \(cellBackgroundView.frame)
      cellBackgroundView.bounds = \(cellBackgroundView.bounds)
      cellImageView.frame = \(cellImageView.frame)
      cellImageView.bounds = \(cellImageView.bounds)
      *********************************************
      /n
      """)
  }
}
