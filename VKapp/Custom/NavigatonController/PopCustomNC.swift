//
//  PopCustomNC.swift
//  VKapp
//
//  Created by Alexander Andrianov on 02.02.2021.
//

import UIKit

final class PopCustomNC: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from),
              let destination = transitionContext.viewController(forKey: .to)
        else { return }
    
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
        destination.view.frame = source.view.frame
        source.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        source.view.layer.position = CGPoint(x: destination.view.frame.maxX, y: destination.view.frame.minY)
        
        
        
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext),
                                delay: 0,
                                options: [],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                                        source.view.transform = CGAffineTransform(rotationAngle: -90 * CGFloat.pi / 180)
                                    })
                                }, completion: { (isFinished) in
                                    let finished = isFinished && !transitionContext.transitionWasCancelled
                                    if finished {
                                        source.view.layer.anchorPoint = destination.view.layer.anchorPoint
                                        source.view.transform = .identity
                                        source.removeFromParent()
                                    }
                                    transitionContext.completeTransition(finished)
                                })
    }
    
 
}
