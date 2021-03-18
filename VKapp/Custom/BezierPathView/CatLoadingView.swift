//
//  CatLoadingView.swift
//  VKapp
//
//  Created by Alexander Andrianov on 07.02.2021.
//

import UIKit

class CatLoadingView: UIView {
  
  let shape = UIBezierPath()
  let lineWidth: CGFloat = 10
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    guard let context = UIGraphicsGetCurrentContext() else { return }
    context.setStrokeColor(UIColor.red.cgColor)
    context.setLineWidth(lineWidth)
    context.setLineCap(.round)
    let must = addMustache()
    let bow = addBow()
    let bowTwo = addBowTwo()
    let face = addFace()
    context.addPath(shape.cgPath)
    context.addPath(must.cgPath)
    context.addPath(bow.cgPath)
    context.addPath(bowTwo.cgPath)
    context.addPath(face.cgPath)
    context.strokePath()
  }
  
  // MARK: - Draw Mustache
  func addMustache() -> UIBezierPath {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 38.5, y: 97.5))
    path.addCurve(to: CGPoint(x: 1.5, y: 99.5),
                  controlPoint1: CGPoint(x: 23.48, y: 95.99),
                  controlPoint2: CGPoint(x: 15.34, y: 96.28))
    path.move(to: CGPoint(x: 38.5, y: 116.5))
    path.addCurve(to: CGPoint(x: 13, y: 121.5),
                  controlPoint1: CGPoint(x: 29.5, y: 117.03),
                  controlPoint2: CGPoint(x: 24.34, y: 117.51))
    path.move(to: CGPoint(x: 50.5, y: 130))
    path.addCurve(to: CGPoint(x: 19.5, y: 146),
                  controlPoint1: CGPoint(x: 40.15, y: 133.86),
                  controlPoint2: CGPoint(x: 33.89, y: 136.65))
    path.move(to: CGPoint(x: 191.5, y: 130))
    path.addCurve(to: CGPoint(x: 219, y: 141),
                  controlPoint1: CGPoint(x: 200.73, y: 131.58),
                  controlPoint2: CGPoint(x: 206.94, y: 134.33))
    path.move(to: CGPoint(x: 191.5, y: 94.5))
    path.addCurve(to: CGPoint(x: 232, y: 92.5),
                  controlPoint1: CGPoint(x: 205.77, y: 92.42),
                  controlPoint2: CGPoint(x: 214.3, y: 91.71))
    path.move(to: CGPoint(x: 226.5, y: 116.5))
    path.addCurve(to: CGPoint(x: 197, y: 110.5),
                  controlPoint1: CGPoint(x: 213.63, y: 112.56),
                  controlPoint2: CGPoint(x: 207.21, y: 111.29))
    
    return path
  }
  // MARK: - Draw Bows
  func addBow() -> UIBezierPath {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 150, y: 50.2))
    path.addCurve(to: CGPoint(x: 117.5, y: 39),
                  controlPoint1: CGPoint(x: 130.5, y: 63),
                  controlPoint2: CGPoint(x: 117.34, y: 53.76))
    path.addCurve(to: CGPoint(x: 143.5, y: 3.5),
                  controlPoint1: CGPoint(x: 117.67, y: 24.24),
                  controlPoint2: CGPoint(x: 130.06, y: 0.56))
    path.addCurve(to: CGPoint(x: 163, y: 28),
                  controlPoint1: CGPoint(x: 152.5, y: 3.5),
                  controlPoint2: CGPoint(x: 159.1, y: 12.22))
    path.move(to: CGPoint(x: 150, y: 50.2))
    path.addCurve(to: CGPoint(x: 172, y: 60.5),
                  controlPoint1: CGPoint(x: 155.22, y: 60.94),
                  controlPoint2: CGPoint(x: 160.46, y: 62.36))
    path.move(to: CGPoint(x: 150, y: 50.2))
    path.addCurve(to: CGPoint(x: 149.19, y: 44.5),
                  controlPoint1: CGPoint(x: 149.4, y: 48.45),
                  controlPoint2: CGPoint(x: 149.14, y: 46.5))
    path.move(to: CGPoint(x: 172, y: 60.5))
    path.addCurve(to: CGPoint(x: 188.5, y: 76),
                  controlPoint1: CGPoint(x: 174, y: 69.5),
                  controlPoint2: CGPoint(x: 178.45, y: 73.57))
    path.addCurve(to: CGPoint(x: 212, y: 39),
                  controlPoint1: CGPoint(x: 198.55, y: 78.43),
                  controlPoint2: CGPoint(x: 216, y: 56))
    path.addCurve(to: CGPoint(x: 180.5, y: 37),
                  controlPoint1: CGPoint(x: 212, y: 32),
                  controlPoint2: CGPoint(x: 183.5, y: 29))
    path.move(to: CGPoint(x: 172, y: 60.5))
    path.addCurve(to: CGPoint(x: 177.7, y: 56.5),
                  controlPoint1: CGPoint(x: 174.33, y: 59.44),
                  controlPoint2: CGPoint(x: 176.21, y: 58.07))
    return path
  }
  
  func addBowTwo() -> UIBezierPath {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 180.5, y: 37))
    path.addCurve(to: CGPoint(x: 163, y: 28),
                  controlPoint1: CGPoint(x: 175.53, y: 30.85),
                  controlPoint2: CGPoint(x: 171.65, y: 28.95))
    path.move(to: CGPoint(x: 180.5, y: 37))
    path.addCurve(to: CGPoint(x: 182.3, y: 44.5),
                  controlPoint1: CGPoint(x: 181.62, y: 39.07),
                  controlPoint2: CGPoint(x: 182.28, y: 41.71))
    path.move(to: CGPoint(x: 163, y: 28))
    path.addCurve(to: CGPoint(x: 155, y: 31.15),
                  controlPoint1: CGPoint(x: 159.85, y: 28),
                  controlPoint2: CGPoint(x: 157.16, y: 29.21))
    path.move(to: CGPoint(x: 177.7, y: 56.5))
    path.addCurve(to: CGPoint(x: 191.5, y: 56.5),
                  controlPoint1: CGPoint(x: 183.09, y: 61.93),
                  controlPoint2: CGPoint(x: 189.65, y: 60.5))
    path.addCurve(to: CGPoint(x: 182.3, y: 44.5),
                  controlPoint1: CGPoint(x: 194.5, y: 50),
                  controlPoint2: CGPoint(x: 190.39, y: 45.19))
    path.move(to: CGPoint(x: 177.7, y: 56.5))
    path.addCurve(to: CGPoint(x: 182.3, y: 44.5),
                  controlPoint1: CGPoint(x: 180.98, y: 53.03),
                  controlPoint2: CGPoint(x: 182.33, y: 48.6))
    path.move(to: CGPoint(x: 155, y: 31.15))
    path.addCurve(to: CGPoint(x: 140.5, y: 31.15),
                  controlPoint1: CGPoint(x: 150, y: 25),
                  controlPoint2: CGPoint(x: 144, y: 24.52))
    path.addCurve(to: CGPoint(x: 149.19, y: 44.5),
                  controlPoint1: CGPoint(x: 137, y: 37.77),
                  controlPoint2: CGPoint(x: 140.5, y: 42))
    path.move(to: CGPoint(x: 155, y: 31.15))
    path.addCurve(to: CGPoint(x: 149.19, y: 44.5),
                  controlPoint1: CGPoint(x: 151.42, y: 34.36),
                  controlPoint2: CGPoint(x: 149.34, y: 39.57))
    return path
  }
  
  // MARK: - Draw Face
  func addFace() -> UIBezierPath {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 41.19, y: 9.7))
    path.addCurve(to: CGPoint(x: 79.5, y: 21),
                  controlPoint1: CGPoint(x: 56.87, y: 8.27),
                  controlPoint2: CGPoint(x: 65.05, y: 12.45))
    path.addCurve(to: CGPoint(x: 152.5, y: 18),
                  controlPoint1: CGPoint(x: 106.14, y: 15.46),
                  controlPoint2: CGPoint(x: 122.39, y: 15.42))
    path.addCurve(to: CGPoint(x: 191.5, y: 3.5),
                  controlPoint1: CGPoint(x: 166.15, y: 9.62),
                  controlPoint2: CGPoint(x: 174.34, y: 5.86))
    path.addCurve(to: CGPoint(x: 197, y: 50),
                  controlPoint1: CGPoint(x: 203.22, y: 17.78),
                  controlPoint2: CGPoint(x: 203.57, y: 32.56))
    path.addCurve(to: CGPoint(x: 207.5, y: 110.5),
                  controlPoint1: CGPoint(x: 208.11, y: 75.66),
                  controlPoint2: CGPoint(x: 209.98, y: 88.78))
    path.addCurve(to: CGPoint(x: 160, y: 155.5),
                  controlPoint1: CGPoint(x: 196.19, y: 140.52),
                  controlPoint2: CGPoint(x: 184.49, y: 148.34))
    path.addCurve(to: CGPoint(x: 85.5, y: 155.5),
                  controlPoint1: CGPoint(x: 126.56, y: 159.85),
                  controlPoint2: CGPoint(x: 112.26, y: 160.69))
    path.addCurve(to: CGPoint(x: 28, y: 116.5),
                  controlPoint1: CGPoint(x: 54.7, y: 149.5),
                  controlPoint2: CGPoint(x: 41.94, y: 141.15))
    path.addCurve(to: CGPoint(x: 36.19, y: 50.2),
                  controlPoint1: CGPoint(x: 21.96, y: 96.81),
                  controlPoint2: CGPoint(x: 19.25, y: 85.31))
    path.addCurve(to: CGPoint(x: 41.19, y: 9.7),
                  controlPoint1: CGPoint(x: 30.91, y: 34.72),
                  controlPoint2: CGPoint(x: 28.34, y: 26.27))
    return path
  }
}
