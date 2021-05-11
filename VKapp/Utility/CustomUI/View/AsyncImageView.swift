//
//  AsyncImageView.swift
//  VKapp
//
//  Created by Alexander Andrianov on 08.05.2021.
//

// swiftlint:disable force_cast

import UIKit

class AsyncImageView: UIImageView {
  
  private var _image: UIImage?
 
  override var image: UIImage? {
    get {
      return _image
    }
    set {
      _image = newValue
      layer.contents = nil
      
      guard let image = newValue else { return }
      DispatchQueue.global(qos: .userInitiated).async {
        let decodedCGImage = self.decode(image)
        
        DispatchQueue.main.async {
          self.layer.contents = decodedCGImage
        }
      }
    }
  }
  
  private func decode(_ image: UIImage) -> CGImage? {
    guard let newImage = image.cgImage else { return nil }
    
    if let cachedImage = Self.cache.object(forKey: image) {
      return (cachedImage as! CGImage)
    }
    
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let context = CGContext(data: nil,
                            width: newImage.width,
                            height: newImage.height,
                            bitsPerComponent: 8,
                            bytesPerRow: newImage.width * 4,
                            space: colorSpace,
                            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
    
    let imageRect = CGRect(x: 0, y: 0, width: newImage.width, height: newImage.height)
    let maxDimension = CGFloat(max(newImage.width, newImage.height))
    let cornerRadiusPath = UIBezierPath(roundedRect: imageRect, cornerRadius: maxDimension / 2).cgPath
    
    context?.addPath(cornerRadiusPath)
    context?.clip()
    context?.draw(newImage, in: CGRect(x: 0, y: 0, width: newImage.width, height: newImage.height))
    
    guard let drawnImage = context?.makeImage() else { return nil }
    Self.cache.setObject(drawnImage, forKey: image)
    return drawnImage
  }
}

extension AsyncImageView {
  private struct Cache {
    static var instance = NSCache<AnyObject, AnyObject>()
  }
  
  class var cache: NSCache<AnyObject, AnyObject> {
    get { return Cache.instance }
    set { Cache.instance = newValue }
  }
}
