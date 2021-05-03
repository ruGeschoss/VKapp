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
  static let newsPostCellInsets: UIEdgeInsets =
    UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
  static let newsPostCellContentInsets: UIEdgeInsets =
    UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
  static let newsPostCellContentHeightLimit: CGFloat = 100
  static let newsPostCellButtonMoreTitle: String = "Show more"
  static let newsPostCellButtonLessTitle: String = "Show less"
  
  // MARK: - News Photo Table ViewCell
  static let newsPhotoCellNib: UINib =
  UINib(nibName: "NewsPhotoTableViewCell", bundle: nil)
  static let newsPhotoCellId: String = "NewsPhotoTableViewCell"
  static let newsPhotoCellBackgroundcolor: UIColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.3)
  static let newsPhotoCellInsets: UIEdgeInsets =
    UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
  static let newsPhotoCellContentInsets: UIEdgeInsets =
    UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  
  // MARK: - News Header View
  static let newsHeaderViewNib: UINib =
    UINib(nibName: "NewsHeaderView", bundle: nil)
  static let newsHeaderViewId: String = "NewsHeaderView"
  static let newsHeaderCornersToRound: UIRectCorner =
    [.topLeft, .topRight]
  static let newsHeaderCornerRadius: CGFloat = 30
  static let newsHeaderBackgroundInsets: UIEdgeInsets =
    UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
  static let newsHeaderContentInsets: UIEdgeInsets =
    UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
  static let newsHeaderViewBackgroundcolor: UIColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.3)
  static let newsHeaderMenuButtonHeight: CGFloat = 30
  static let newsHeaderAvatarImageHeight: CGFloat = 30
  
  static var newsHeaderTotalHeight: CGFloat {
    let contentInsetsSumm = newsHeaderContentInsets.top + newsHeaderContentInsets.bottom
    let backgroundInsetsSumm = newsHeaderBackgroundInsets.top + newsHeaderBackgroundInsets.bottom
    let totalHeight = newsHeaderAvatarImageHeight + contentInsetsSumm + backgroundInsetsSumm
    return totalHeight
  }
  
  // MARK: - News Footer View
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
