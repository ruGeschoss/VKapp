//
//  FullScreenPhotoVC.swift
//  VKapp
//
//  Created by Alexander Andrianov on 27.01.2021.
//

import UIKit

enum IndexChange {
  case plusOne
  case minusOne
}

class FullScreenPhotoVC: UIViewController {
  var fullAlbum: [String] = []
  var currentIndex:Int = 0
  
  var startingViewIsHidden:Bool = false
  var centerPosition = CGPoint()
  var leftXPosition = CGFloat()
  var rightXPosition = CGFloat()
  var frameWidth = CGFloat()
  
  @IBOutlet weak var fullScreenView: UIView!
  @IBOutlet weak var photoImage: UIImageView!
  @IBOutlet weak var extraPhotoImage: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    frameWidth = view.frame.width
    centerPosition = view.center
    rightXPosition = frameWidth + centerPosition.x
    leftXPosition = -centerPosition.x
    
    
    fullScreenView.backgroundColor = .clear
    photoImage.backgroundColor = .clear
    extraPhotoImage.backgroundColor = .clear
    
    NetworkManager.getPhotoDataFromUrl(url: fullAlbum[currentIndex] , completion: { [weak self] (data) in
      self?.photoImage.image = UIImage(data: data)
    })
    
    
    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(goForward))
    swipeLeft.direction = .left
    self.view.addGestureRecognizer(swipeLeft)
    
    let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goBackwards))
    swipeRight.direction = .right
    self.view.addGestureRecognizer(swipeRight)
    
    let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(backToAlbum))
    swipeDown.direction = .down
    self.view.addGestureRecognizer(swipeDown)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    switch leftXPosition {
    case photoImage.center.x:
      photoImage.layer.opacity = 0
    case extraPhotoImage.center.x:
      extraPhotoImage.layer.opacity = 0
    default:
      return
    }
  }
  
  @objc func backToAlbum() {
    navigationController?.popViewController(animated: true)
  }
  
  //MARK: -Backwards
  @objc func goBackwards() {
    guard currentIndex > .zero else { return }
    switch startingViewIsHidden {
    case true:
      animationBuilder(index: .minusOne, hiddenImg: photoImage, shownImg: extraPhotoImage, hiddenImgComesFromX: leftXPosition, showImgGoesToX: rightXPosition)
    case false:
      animationBuilder(index: .minusOne, hiddenImg: extraPhotoImage, shownImg: photoImage, hiddenImgComesFromX: leftXPosition, showImgGoesToX: rightXPosition)
    }
  }
  
  //MARK: -Forward
  @objc func goForward() {
    guard currentIndex < fullAlbum.count - 1 else { return }
    switch startingViewIsHidden {
    case true:  //photoImage is hidden
      animationBuilder(index: .plusOne, hiddenImg: photoImage, shownImg: extraPhotoImage, hiddenImgComesFromX: rightXPosition, showImgGoesToX: leftXPosition)
    case false: //photoImage is shown
      animationBuilder(index: .plusOne, hiddenImg: extraPhotoImage, shownImg: photoImage, hiddenImgComesFromX: rightXPosition, showImgGoesToX: leftXPosition)
    }
  }
  
  //MARK: - AnimationBuilder
  func animationBuilder(index:IndexChange, hiddenImg:UIImageView!, shownImg:UIImageView!, hiddenImgComesFromX:CGFloat, showImgGoesToX:CGFloat) {
    startingViewIsHidden = !startingViewIsHidden
    switch index {
    case .plusOne:
      currentIndex += 1
    case .minusOne:
      currentIndex -= 1
    }
    
    //        hiddenImg.image = UIImage(named: fullAlbum[currentIndex])
    NetworkManager.getPhotoDataFromUrl(url: fullAlbum[currentIndex] , completion: { (data) in
      hiddenImg.image = UIImage(data: data)
    })
    hiddenImg.center.x = hiddenImgComesFromX
    hiddenImg.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    hiddenImg.layer.opacity = 0
    
    UIView.animateKeyframes(withDuration: 1.1, delay: 0, options: [], animations: {
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.75, animations: {
        hiddenImg.center.x = self.centerPosition.x
        shownImg.center.x = showImgGoesToX
      })
      UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1, animations: {
        hiddenImg.layer.opacity = 1
        hiddenImg.transform = .identity
      })
    })
  }
  
}
