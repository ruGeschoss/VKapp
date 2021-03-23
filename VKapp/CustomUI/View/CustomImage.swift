//
//  CustomImage.swift
//  VKapp
//
//  Created by Alexander Andrianov on 04.01.2021.
//

import UIKit

// MARK: - Round Image
class RoundImage: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
        clipsToBounds = true
    }
}

// MARK: - Shadow Image
class ShadowImage: UIImageView {
    
    @IBInspectable var shadowRadius: CGFloat = 5 {
        didSet {
            setNeedsDisplay()
        }
    }
  
    @IBInspectable var shadowOpacity: Float = 0.6 {
        didSet {
            setNeedsDisplay()
        }
    }
  
    @IBInspectable var shadowColor: UIColor = .red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = .zero
        layer.shadowOpacity = shadowOpacity
        layer.shadowColor = shadowColor.cgColor
        layer.cornerRadius = bounds.width / 2
        clipsToBounds = false
    }
}
