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
  
  // MARK: - News Table View Cell
  
  // MARK: - Header View
  static let newsHeaderViewNib: UINib =
    UINib(nibName: "NewsHeaderView", bundle: nil)
  static let newsHeaderViewId: String = "NewsHeaderView"
  static let newsHeaderCornersToRound: UIRectCorner =
    [.topLeft, .topRight]
  static let newsHeaderCornerRadius: CGFloat = 30
  static let newsHeaderViewBackgroundcolor: UIColor = #colorLiteral(red: 0.3730416298, green: 1, blue: 0, alpha: 1)
  static let newsHeaderViewBackgroudAlpha: CGFloat = 0.3
  static let newsHeaderInsets: UIEdgeInsets =
    UIEdgeInsets(top: 10, left: 20,
                 bottom: 0, right: 20)
  
  // MARK: - Footer View
  static let newsFooterViewNib: UINib =
    UINib(nibName: "NewsFooterView", bundle: nil)
  static let newsFooterViewId: String = "NewsFooterView"
  static let newsFooterCornersToRound: UIRectCorner =
    [.bottomLeft, .bottomRight]
  static let newsFooterCornerRadius: CGFloat = 30
  static let newsFooterViewBackgroundcolor: UIColor = #colorLiteral(red: 0.3730416298, green: 1, blue: 0, alpha: 1)
  static let newsFooterViewBackgroudAlpha: CGFloat = 0.3
  static let newsFooterInsets: UIEdgeInsets =
    UIEdgeInsets(top: 0, left: 20,
                 bottom: 10, right: 20)
}
