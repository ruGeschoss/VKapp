//
//  Constants.swift
//  VKapp
//
//  Created by Alexander Andrianov on 21.03.2021.
//

import UIKit

final class Constants {
  
  // MARK: - News Table View
  static let newsTableViewBackgroundColor: UIColor =
    UIColor.clear
  
  // MARK: - News Post Table View Cell
  static let newsPostCellNib: UINib =
  UINib(nibName: "NewsPostTableViewCell", bundle: nil)
  static let newsPostCellId: String = "NewsPostTableViewCell"
  static let newsPostCellBackgroundcolor: UIColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.3)
  
  // MARK: - News Photo Table ViewCell
  static let newsPhotoCellNib: UINib =
  UINib(nibName: "NewsPhotoTableViewCell", bundle: nil)
  static let newsPhotoCellId: String = "NewsPhotoTableViewCell"
  static let newsPhotoCellBackgroundcolor: UIColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.3)
  
  // MARK: - Header View
  static let newsHeaderViewNib: UINib =
    UINib(nibName: "NewsHeaderView", bundle: nil)
  static let newsHeaderViewId: String = "NewsHeaderView"
  static let newsHeaderCornersToRound: UIRectCorner =
    [.topLeft, .topRight]
  static let newsHeaderCornerRadius: CGFloat = 30
  static let newsHeaderViewBackgroundcolor: UIColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.3)
  
  // MARK: - Footer View
  static let newsFooterViewNib: UINib =
    UINib(nibName: "NewsFooterView", bundle: nil)
  static let newsFooterViewId: String = "NewsFooterView"
  static let newsFooterCornersToRound: UIRectCorner =
    [.bottomLeft, .bottomRight]
  static let newsFooterCornerRadius: CGFloat = 30
  static let newsFooterViewBackgroundcolor: UIColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.3)
  
  // MARK: - Charpicker
  static let maximumCharpickerChars: Int = 15
}
