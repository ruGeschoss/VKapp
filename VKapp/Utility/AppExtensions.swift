//
//  AppExtensions.swift
//  VKapp
//
//  Created by Alexander Andrianov on 04.02.2021.
//

import UIKit

// MARK: - String
extension String {
  func height(withConstrainedWidth width: CGFloat,
              font: UIFont) -> CGFloat {
    let constraintRect = CGSize(
      width: width,
      height: .greatestFiniteMagnitude)
    
    let boundingBox = self.boundingRect(
      with: constraintRect,
      options: .usesLineFragmentOrigin,
      attributes: [NSAttributedString.Key.font: font],
      context: nil)
    
    return ceil(boundingBox.height)
  }
  
  func width(withConstrainedHeight height: CGFloat,
             font: UIFont) -> CGFloat {
    let constraintRect = CGSize(
      width: .greatestFiniteMagnitude,
      height: height)
    
    let boundingBox = self.boundingRect(
      with: constraintRect,
      options: .usesLineFragmentOrigin,
      attributes: [NSAttributedString.Key.font: font],
      context: nil)
    
    return ceil(boundingBox.width)
  }
}

// MARK: - UIView
extension UIView {
  func roundCorners(corners: UIRectCorner,
                    radius: CGFloat) {
    let path = UIBezierPath(
      roundedRect: bounds,
      byRoundingCorners: corners,
      cornerRadii: CGSize(
        width: radius,
        height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }
  
  func animatedTap() {
    UIView.animate(
      withDuration: 0.1, delay: 0,
      options: .curveLinear, animations: {
        self.transform =
          CGAffineTransform(scaleX: 0.8, y: 0.8)
      })
    UIView.animate(
      withDuration: 0.1, delay: 0.1,
      options: .curveLinear, animations: {
        self.transform =
          CGAffineTransform.identity
      })
  }
}

// MARK: - UIStackView
extension UIStackView {
  
  func removeFully(view: UIView) {
    removeArrangedSubview(view)
    view.removeFromSuperview()
  }
  
  func removeFullyAllArrangedSubviews() {
    arrangedSubviews.forEach { (view) in
      removeFully(view: view)
    }
  }
}
