//
//  AppExtensions.swift
//  VKapp
//
//  Created by Alexander Andrianov on 04.02.2021.
//

import UIKit

// MARK: NewsOwner
protocol NewsOwner: AnyObject {
  var ownerName: String { get }
  var ownerAvatarURL: String { get }
  var ownerId: String { get }
}

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

// MARK: - Double
extension Double {
  func convertToDate() -> String {
    let date = Date(timeIntervalSinceReferenceDate: self)
    let dateformatter = DateFormatter()
    dateformatter.locale = Locale(identifier: "ru")
    dateformatter.dateFormat = "d MMMM yyyy HH:mm"
    dateformatter.timeZone = .current
    return dateformatter.string(from: date)
  }
}

// MARK: - Int
extension Int {
  func convertToDate() -> String {
    let date = Date(timeIntervalSince1970: Double(self))
    let dateformatter = DateFormatter()
    dateformatter.locale = Locale(identifier: "ru")
    dateformatter.dateFormat = "d MMMM yyyy HH:mm"
    dateformatter.timeZone = .current
    return dateformatter.string(from: date)
  }
  
  var shortStringVersion: String {
    guard !Double(self).isNaN, !Double(self).isInfinite else { return "" }
    if self == 0 { return "0" }
    
    let units = ["", "k", "M"]
    var interval = Double(self)
    var unitIndex = 0
    while unitIndex < units.count - 1 {
      if abs(interval) < 1000.0 {
        break
      }
      unitIndex += 1
      interval /= 1000.0
    }
    // 2 for 1 digit, 3 for 2 digits, etc
    let numberOfDigits = interval > 9 ? 2 : 3
    let stringValue = String(format: "%0.*g", Int(log10(abs(interval))) + numberOfDigits, interval)
    return "\(stringValue)\(units[unitIndex])"
  }
}

// MARK: - TableViewCell
extension UITableViewCell: ReusableCell {}

protocol ReusableCell {}

extension ReusableCell where Self: UITableViewCell {
  static var reuseID: String {
    String(describing: self)
  }
}

// MARK: - TableView Header/Footer
extension UITableViewHeaderFooterView: ReusableHeaderFooter {}

protocol ReusableHeaderFooter {}

extension ReusableHeaderFooter where Self: UITableViewHeaderFooterView {
  static var reuseID: String {
    String(describing: self)
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
  
  func animatedSpin() {
    UIView.animate(
      withDuration: 0.1,
      delay: 0,
      options: .curveLinear,
      animations: {
        self.transform =
          CGAffineTransform(rotationAngle: -60)
      })
    UIView.animate(
      withDuration: 0.1,
      delay: 0.1,
      options: .curveLinear,
      animations: {
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
