//
//  Constants.swift
//  VKapp
//
//  Created by Alexander Andrianov on 21.03.2021.
//

import UIKit

final class Constants {
  
  // MARK: - News Table View
  static let newsTableViewBackgroundColor: UIColor = UIColor.clear
  
  // MARK: - News Table View Cell
  static let newsCellBackgroundColor: UIColor = UIColor.clear
  static let newsPostCellNib: UINib = UINib(nibName: "NewsPostTableViewCell",
                                            bundle: nil)
  static let newsPostCellId: String = "NewsPostTableViewCell"
  
  // MARK: - Header View
  static let headerViewNib: UINib = UINib(nibName: "HeaderView",
                                          bundle: nil)
  static let headerViewId: String = "HeaderView"
  static let headerBackgroundColor: UIColor = UIColor.clear
  
  // MARK: - Footer View
  static let footerViewNib: UINib = UINib(nibName: "FooterView",
                                          bundle: nil)
  static let footerViewId: String = "FooterView"
  static let footerBackgroundColor: UIColor = UIColor.clear
}
