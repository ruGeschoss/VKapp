//
//  SingleAlbumCollectionViewLayout.swift
//  VKapp
//
//  Created by Alexander Andrianov on 18.03.2021.
//

import UIKit

class SingleAlbumCollectionViewLayout: UICollectionViewLayout {
  
  private var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
  private var contentHeight: CGFloat = 0
  private var contentWidth: CGFloat {
    guard let collectionView = collectionView else { return 0 }
    let insets = collectionView.contentInset
    return collectionView.bounds.width - insets.left - insets.right
  }
  
  override func prepare() {
    self.cacheAttributes = [:]
    guard let collectionview = self.collectionView else { return }
    let itemsCount = collectionview.numberOfItems(inSection: 0)
    let firstRow = Int.random(in: 2...4)
    let secondRow = Int.random(in: 2...4)
    var cellHeight: CGFloat = 0
    var lastX: CGFloat = 0
    var lastY: CGFloat = 0
    
    let firstRowCellsWidth = contentWidth / CGFloat(firstRow)
    let secondCellsWidth = contentWidth / CGFloat(secondRow)
    var isFirstRow = true
    cellHeight = isFirstRow ? (firstRowCellsWidth) : (secondCellsWidth)

    for index in 0..<itemsCount {
      let indexPath = IndexPath(item: index, section: 0)
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      switch isFirstRow {
      case true:
        attributes.frame = CGRect(x: lastX, y: lastY, width: firstRowCellsWidth, height: cellHeight)
        lastX += firstRowCellsWidth
      case false:
        attributes.frame = CGRect(x: lastX, y: lastY, width: secondCellsWidth, height: cellHeight)
        lastX += secondCellsWidth
      }
      // Switch to next row, if next item exists
      if lastX == contentWidth && (index + 1) < itemsCount {
        lastY += cellHeight
        lastX = 0
        isFirstRow = !isFirstRow
      }
      cacheAttributes[indexPath] = attributes
    }
    contentHeight = lastY + cellHeight
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return cacheAttributes.values.filter { attributes in
      return rect.intersects(attributes.frame)
    }
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    cacheAttributes[indexPath]
  }
  
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth,
                  height: contentHeight)
  }
}
