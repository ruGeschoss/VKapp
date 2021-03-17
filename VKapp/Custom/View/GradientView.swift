//
//  GradientView.swift
//  VKapp
//
//  Created by Alexander Andrianov on 04.01.2021.
//

import UIKit

class GradientView: UIView {
  
  @IBInspectable var startColor: UIColor = .white {
    didSet {
      self.updateColors()
    }
  }
  @IBInspectable var endColor: UIColor = .systemPink {
    didSet {
      self.updateColors()
    }
  }
  @IBInspectable var startLocation: CGFloat = 0 {
    didSet {
      self.updateLocations()
    }
  }
  @IBInspectable var endLocation: CGFloat = 1 {
    didSet {
      self.updateLocations()
    }
  }
  @IBInspectable var startPoint: CGPoint = CGPoint(x: 0, y: 1) {
    didSet {
      self.updateStartPoint()
    }
  }
  @IBInspectable var endPoint: CGPoint = CGPoint (x: 1, y: 0) {
    didSet {
      self.updateEndPoint()
    }
  }
  
  override static var layerClass: AnyClass {
    CAGradientLayer.self
  }
  var gradientLayer: CAGradientLayer {
    self.layer as! CAGradientLayer
  }
  
  func updateLocations() {
    self.gradientLayer.locations = [self.startLocation as NSNumber, self.endLocation as NSNumber]
  }
  
  func updateColors() {
    self.gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
  }
  
  func updateStartPoint() {
    self.gradientLayer.startPoint = startPoint
  }
  
  func updateEndPoint() {
    self.gradientLayer.endPoint = endPoint
  }
}
