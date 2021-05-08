//
//  Constants.swift
//  VKapp
//
//  Created by Alexander Andrianov on 21.03.2021.
//

import UIKit

enum Constants {
  
  enum News {
    
    static let backgroundColor: UIColor = .clear
    
    // MARK: News Header
    enum Header {
      static let backgroundInsets: UIEdgeInsets =
        UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
      static let contentInsets: UIEdgeInsets =
        UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
      static let cornersToRound: UIRectCorner = [.topLeft, .topRight]
      static let cornerRadius: CGFloat = 30
      static let backgroundColor: UIColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.3)
      static let menuButtonHeight: CGFloat = 30
      static let avatarImageHeight: CGFloat = 30
      
      static var totalHeight: CGFloat {
        let contentInsetsSumm = contentInsets.top + contentInsets.bottom
        let backgroundInsetsSumm = backgroundInsets.top + backgroundInsets.bottom
        let totalHeight = avatarImageHeight + contentInsetsSumm + backgroundInsetsSumm
        return totalHeight
      }
    }
    
    // MARK: News Footer
    enum Footer {
      static let backgroundInsets: UIEdgeInsets =
        UIEdgeInsets(top: 0, left: 10, bottom: 5, right: 10)
      static let contentInsets: UIEdgeInsets =
        UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
      static let cornersToRound: UIRectCorner = [.bottomLeft, .bottomRight]
      static let cornerRadius: CGFloat = 30
      static let backgroundColor: UIColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.3)
      static let buttonsHeight: CGFloat = 30
      
      static var totalHeight: CGFloat {
        let contentInsetsSumm = contentInsets.top + contentInsets.bottom
        let backgroundInsetsSumm = backgroundInsets.top + backgroundInsets.bottom
        let totalHeight = buttonsHeight + contentInsetsSumm + backgroundInsetsSumm
        return totalHeight
      }
    }
    
    // MARK: Post cell
    enum PostCell {
      static let cellInsets: UIEdgeInsets =
        UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
      static let cellContentInsets: UIEdgeInsets =
        UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
      static let backgroundColor: UIColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.3)
      static let contentHeightLimit: CGFloat = 100
      static let buttonMoreTitle: String = "Show more"
      static let buttonLessTitle: String = "Show less"
    }
    
    // MARK: Photo cell
    enum PhotoCell {
      static let backgroundColor: UIColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.3)
      static let cellInsets: UIEdgeInsets =
        UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
      static let cellContentInsets: UIEdgeInsets =
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
  }
  
  // MARK: Charpicker
  enum Charpicker {
    static let maxChars: Int = 15
  }
  
}
