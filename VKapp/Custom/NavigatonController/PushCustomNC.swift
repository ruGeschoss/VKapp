//
//  PushCustomNC.swift
//  VKapp
//
//  Created by Alexander Andrianov on 02.02.2021.
//

import UIKit

final class PushCustomNC: NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    0.7
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let source = transitionContext.viewController(forKey: .from),
          let destination = transitionContext.viewController(forKey: .to)
    else { return }
    
    transitionContext.containerView.addSubview(destination.view)
    destination.view.frame = source.view.frame
    destination.view.layer.anchorPoint = CGPoint(x: 1, y: 1)
    destination.view.layer.position = CGPoint(x: source.view.frame.maxX, y: source.view.frame.maxY)
    destination.view.transform = CGAffineTransform(rotationAngle: 90 * CGFloat.pi / 180)
    
    UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext),
                            delay: 0,
                            options: [],
                            animations: {
                              UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                                destination.view.transform = .identity
                              })
                            }, completion: { (isFinished) in
                              let finished = isFinished && !transitionContext.transitionWasCancelled
                              destination.view.layer.anchorPoint = source.view.layer.anchorPoint
                              transitionContext.completeTransition(finished)
                            })
  }
  
  
}
