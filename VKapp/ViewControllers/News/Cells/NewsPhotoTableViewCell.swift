//
//  NewsPhotoTableViewCell.swift
//  VKapp
//
//  Created by Alexander Andrianov on 24.03.2021.
//

import UIKit

final class NewsPhotoTableViewCell: UITableViewCell {
  
  private var contentImage: UIImage?
  private var aspectRatio: CGFloat?
  private var superBounds: CGRect?
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if superBounds == nil {
      superBounds = bounds
      layoutContent()
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    superBounds = nil
    contentView
      .subviews
      .forEach { $0.removeFromSuperview() }
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
  }
  
  func configure(image: UIImage?, aspectRatio: CGFloat?) {
    guard
      let image = image,
      let aspect = aspectRatio
    else { return }
    self.contentImage = image
    self.aspectRatio = aspect
    layoutContent()
  }
  
  private func layoutContent() {
    guard
      let image = contentImage,
      let aspect = aspectRatio
    else { return }
    
    DispatchQueue.global().async { [weak self] in
      guard let self = self,
            let superBounds = self.superBounds else { return }
      let insets = Constants.newsPhotoCellInsets
      let contentInsets = Constants.newsPhotoCellContentInsets
      
      let insetsWidthSum = insets.left + insets.right
      let contentInsetsWidthSum = contentInsets.left + contentInsets.right
      let contentInsetsHeightSum = contentInsets.top + contentInsets.bottom
      
      let cellWidth = superBounds.width - insetsWidthSum
      let maxCellContentWitdh = cellWidth - contentInsetsWidthSum
      let cellContentHeight =
        aspect < 1 ? maxCellContentWitdh : maxCellContentWitdh / aspect
      let cellContentWidth =
        aspect > 1 ? maxCellContentWitdh : maxCellContentWitdh * aspect
      let cellHeight = cellContentHeight + contentInsetsHeightSum
      
      let cellOrigin =
        CGPoint(x: superBounds.minX + insets.left, y: insets.top)
      let cellSize = CGSize(width: ceil(cellWidth), height: ceil(cellHeight))
      
      let contentX = (cellWidth - cellContentWidth) / 2
      let contentOrigin = CGPoint(x: ceil(contentX), y: contentInsets.top)
      let contentSize =
        CGSize(width: ceil(cellContentWidth), height: ceil(cellContentHeight))
      
      DispatchQueue.main.async {
        
        self.contentView
          .subviews
          .forEach { $0.removeFromSuperview() }
        
        let myBackgroundView = UIView()
        myBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        myBackgroundView.frame = CGRect(origin: cellOrigin, size: cellSize)
        myBackgroundView.backgroundColor = Constants.newsPhotoCellBackgroundcolor
        
        let myContentView = UIImageView()
        myContentView.translatesAutoresizingMaskIntoConstraints = false
        myContentView.frame = CGRect(origin: contentOrigin, size: contentSize)
        myContentView.image = image
        myBackgroundView.addSubview(myContentView)
        self.contentView.addSubview(myBackgroundView)
      }
    }
  }
  
}
