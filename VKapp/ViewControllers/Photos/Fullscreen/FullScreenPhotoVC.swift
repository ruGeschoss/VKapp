//
//  FullScreenPhotoVC.swift
//  VKapp
//
//  Created by Alexander Andrianov on 27.01.2021.
//

import UIKit

private enum IndexChange {
  case plusOne
  case minusOne
}

final class FullScreenPhotoVC: UIViewController {
  @IBOutlet private weak var fullScreenView: UIView!
  @IBOutlet private weak var photoImage: UIImageView!
  @IBOutlet private weak var extraPhotoImage: UIImageView!
  
  private var startingViewIsHidden: Bool = false
  private var centerPosition = CGPoint()
  private var leftXPosition = CGFloat()
  private var rightXPosition = CGFloat()
  private var frameWidth = CGFloat()
  
  var fullAlbum: [String] = []
  var currentIndex: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    loadImage()
    addGestureRecognizers()
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
}

// MARK: - Objc functions
extension FullScreenPhotoVC {
  
  @objc private func backToAlbum() {
    navigationController?
      .popViewController(animated: true)
  }
  
  // To previous image
  @objc private func goBackwards() {
    guard currentIndex > .zero else { return }
    switch startingViewIsHidden {
    case true:
      animationBuilder(
        index: .minusOne, hiddenImg: photoImage,
        shownImg: extraPhotoImage,
        hiddenImgComesFromX: leftXPosition,
        showImgGoesToX: rightXPosition)
    case false:
      animationBuilder(
        index: .minusOne,
        hiddenImg: extraPhotoImage,
        shownImg: photoImage,
        hiddenImgComesFromX: leftXPosition,
        showImgGoesToX: rightXPosition)
    }
  }
  
  // To next image
  @objc private func goForward() {
    guard currentIndex < fullAlbum.count - 1 else { return }
    switch startingViewIsHidden {
    case true:
      animationBuilder(
        index: .plusOne,
        hiddenImg: photoImage,
        shownImg: extraPhotoImage,
        hiddenImgComesFromX: rightXPosition,
        showImgGoesToX: leftXPosition)
    case false:
      animationBuilder(
        index: .plusOne,
        hiddenImg: extraPhotoImage,
        shownImg: photoImage,
        hiddenImgComesFromX: rightXPosition,
        showImgGoesToX: leftXPosition)
    }
  }
}

// MARK: - Functions
extension FullScreenPhotoVC {
  
  // Add swipe recognizers
  private func addGestureRecognizers() {
    let swipeLeft =
      UISwipeGestureRecognizer(target: self,
                               action: #selector(goForward))
    let swipeRight =
      UISwipeGestureRecognizer(target: self,
                               action: #selector(goBackwards))
    let swipeDown =
      UISwipeGestureRecognizer(target: self,
                               action: #selector(backToAlbum))
    swipeRight.direction = .right
    swipeLeft.direction = .left
    swipeDown.direction = .down
    self.view.addGestureRecognizer(swipeLeft)
    self.view.addGestureRecognizer(swipeRight)
    self.view.addGestureRecognizer(swipeDown)
  }
  
  // Load Image
  private func loadImage() {
    NetworkManager
      .getPhotoDataFromUrl(
        url: fullAlbum[currentIndex]) { [weak self] (data) in
        DispatchQueue.main.async {
          self?.photoImage.image = UIImage(data: data)
        }
      }
  }
  
  // Setup both views
  private func setupViews() {
    frameWidth = view.frame.width
    centerPosition = view.center
    rightXPosition = frameWidth + centerPosition.x
    leftXPosition = -centerPosition.x
    
    fullScreenView.backgroundColor = .clear
    photoImage.backgroundColor = .clear
    extraPhotoImage.backgroundColor = .clear
  }
  
  // MARK: - AnimationBuilder
  private func animationBuilder(
    index: IndexChange, hiddenImg: UIImageView!,
    shownImg: UIImageView!, hiddenImgComesFromX: CGFloat,
    showImgGoesToX: CGFloat) {
    
    startingViewIsHidden = !startingViewIsHidden
    switch index {
    case .plusOne:
      currentIndex += 1
    case .minusOne:
      currentIndex -= 1
    }
    
    NetworkManager
      .getPhotoDataFromUrl(
        url: fullAlbum[currentIndex], completion: { (data) in
          DispatchQueue.main.async {
            hiddenImg.image = UIImage(data: data)
          }
        })
    
    hiddenImg.center.x = hiddenImgComesFromX
    hiddenImg.layer.opacity = 0
    hiddenImg.transform =
      CGAffineTransform(scaleX: 0.7, y: 0.7)
    
    UIView.animateKeyframes(
      withDuration: 1.1, delay: 0, options: [], animations: {
        UIView.addKeyframe(
          withRelativeStartTime: 0, relativeDuration: 0.75,
          animations: {
            hiddenImg.center.x = self.centerPosition.x
            shownImg.center.x = showImgGoesToX
          })
        UIView.addKeyframe(
          withRelativeStartTime: 0.5, relativeDuration: 1,
          animations: {
            hiddenImg.layer.opacity = 1
            hiddenImg.transform = .identity
          })
        })
  }
}
