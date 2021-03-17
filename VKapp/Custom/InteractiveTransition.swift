//
//  InteractiveTransition.swift
//  VKapp
//
//  Created by Alexander Andrianov on 02.02.2021.
//

import UIKit

final class InteractiveTransition: UIPercentDrivenInteractiveTransition {
  
  var viewController: UIViewController? {
    didSet {
      let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgePan))
      recognizer.edges = .left
      viewController?.view.addGestureRecognizer(recognizer)
    }
  }
  
  var panStarted = false
  var shouldFinish = false
  
  @objc func screenEdgePan(_ recognizer:UIScreenEdgePanGestureRecognizer) {
    switch recognizer.state {
    case .began:
      panStarted = true
      viewController?.navigationController?.popViewController(animated: true)
    case .changed:
      let translation = recognizer.translation(in: recognizer.view)
      let relativeTranslationByX = translation.x / (recognizer.view?.bounds.width ?? 1)
      let progress = max(0, min(1, relativeTranslationByX))
      shouldFinish = progress > 0.33
      update(progress)
    case .ended:
      panStarted = false
      shouldFinish ? finish() : cancel()
    case .cancelled:
      panStarted = false
      cancel()
    default:
      return
    }
  }
}
