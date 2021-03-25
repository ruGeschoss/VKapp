//
//  CustomNavigationController.swift
//  VKapp
//
//  Created by Alexander Andrianov on 02.02.2021.
//

import UIKit

final class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {
  
  let interactiveTransition = InteractiveTransition()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
  }
  
  func navigationController(
    _ navigationController: UINavigationController,
    animationControllerFor operation: UINavigationController.Operation,
    from fromVC: UIViewController,
    to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    switch operation {
    case .push:
      interactiveTransition.viewController = toVC
      return PushCustomNC()
    case .pop:
      if navigationController.viewControllers.first != toVC {
        interactiveTransition.viewController = toVC
      }
      return PopCustomNC()
    default:
      return nil
    }
  }
}
