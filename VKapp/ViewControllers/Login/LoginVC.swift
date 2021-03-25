//
//  LoginVC.swift
//  VKapp
//
//  Created by Alexander Andrianov on 22.12.2020.
//

import UIKit
import SwiftKeychainWrapper
import RealmSwift
import WebKit

final class LoginVC: UIViewController {
  
  @IBOutlet private weak var scrollView: UIScrollView!
  @IBOutlet private weak var loginTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
  @IBOutlet private weak var signInButton: UIButton!
  @IBOutlet private weak var stackView: UIStackView!
  @IBOutlet private weak var loginWithVKButton: UIButton!
  @IBOutlet private weak var signUpButton: UIButton!
  
  private lazy var keychain = KeychainWrapper.standard
  private lazy var realm = RealmManager.shared
  private var shouldAutoLogin = true
  private var tokenIsExpired = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    createGestureRecognizer()
    addKeyboardObservers()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    checkIfTokenExpired()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    tokenIsExpired ? (showTokenExpiredAlert()) : ()
    if shouldAutoLogin {
      guard Session.shared.token != "" else { return }
      nextScreenAnim()
    }
    
  }
  
  @objc private func keyboardWillShow (notification: Notification) {
    guard let kbSize = notification
            .userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
            as? CGRect else { return }
    let insets = UIEdgeInsets(
      top: 0, left: 0,
      bottom: kbSize.size.height, right: 0)
    scrollView.contentInset = insets
  }
  
  @objc private func keyboardWillHide (notification: Notification) {
    let insets = UIEdgeInsets.zero
    scrollView.contentInset = insets
  }
  
  @objc private func didTapOnScroll () {
    view.endEditing(true)
  }
  
  /// Show animation, load data and perform segue
  func nextScreenAnim() {
    let anim = createAnimatedCatFace()
    
    // Load and store data
    NetworkManager.loadFriendsSJ(forUser: nil) {}
    NetworkManager.loadGroupsSJ(forUserId: nil) {}
    
    performAnimation(anim)
  }
  
  // MARK: - Actions
  @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
    shouldAutoLogin = false
    keychain.remove(forKey: "userToken")
    keychain.remove(forKey: "userId")
    keychain.remove(forKey: "userName")
    
    removeVkCookies()
  }
  
  @IBAction private func signInButton(_ sender: UIButton) {
    didTapOnScroll()
    guard let name = loginTextField.text, name.count > 2 else {
      showLoginError()
      return
    }
    nextScreenAnim()
  }
  
  @IBAction private func loginWithVK(_ sender: UIButton) {
    guard let webkit = storyboard?
            .instantiateViewController(identifier: "WKViewController")
            as? WKViewController else { return }
    webkit.modalPresentationStyle = .fullScreen
    present(webkit, animated: true, completion: nil)
  }
  
  @IBAction func signUpButton(_ sender: UIButton) {}
}

extension LoginVC {
  // MARK: - Check token
  private func checkIfTokenExpired() {
    let currentTime = Date.timeIntervalSinceReferenceDate
    let tokenExpires = Session.shared.tokenExpires
    let dateExpires = Date(timeIntervalSinceReferenceDate: tokenExpires)
    #if DEBUG
    print("Текущее время: \(Date())")
    print("Токен действует до \(dateExpires)")
    print("\(Session.shared.token)")
    #endif
    
    switch tokenExpires < currentTime && tokenExpires != 0 {
    case true:
      shouldAutoLogin = false
      tokenIsExpired = true
    case false:
      tokenIsExpired = false
      if tokenExpires == 0 {
        removeVkCookies()
        loginWithVK(loginWithVKButton)
      }
    }
  }
  
  // MARK: - Gesture Recognizer
  private func createGestureRecognizer() {
    let tapGesture = UITapGestureRecognizer(
      target: self, action: #selector(didTapOnScroll))
    view.addGestureRecognizer(tapGesture)
    view.isUserInteractionEnabled = true
  }
  
  // MARK: - Keyboard observers
  private func addKeyboardObservers() {
    NotificationCenter.default.addObserver(
      self, selector: #selector(keyboardWillShow (notification:)),
      name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(
      self, selector: #selector(keyboardWillHide (notification:)),
      name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  // MARK: - Remove cookies
  private func removeVkCookies() {
    WKWebsiteDataStore.default()
      .fetchDataRecords(ofTypes: WKWebsiteDataStore
                          .allWebsiteDataTypes()) { records in
      records.forEach { record in
        guard record.displayName == "vk.com" ||
                record.displayName == "mail.ru" else { return }
        WKWebsiteDataStore.default()
          .removeData(ofTypes: record.dataTypes,
                      for: [record], completionHandler: {
          print("Finished removing data for \(record.displayName)")
        })
      }
    }
  }
  
  // MARK: - Perform animation
  private func performAnimation(_ anim: CatLoadingView) {
    // Show animation
    UIView.animateKeyframes(
      withDuration: 4, delay: 0, options: [], animations: {
        UIView.addKeyframe(withRelativeStartTime: 0,
                           relativeDuration: 0.05, animations: {
                            // duration 0.2 sec
                            self.scrollView.alpha = 0
                           })
        UIView.addKeyframe(withRelativeStartTime: 0.05,
                           relativeDuration: 0.1, animations: {
                            // duration 0.4 sec
                            anim.alpha = 1
                           })
      }, completion: { _ in
        self.scrollView.alpha = 1
        anim.removeFromSuperview()
        self.performSegue(withIdentifier: "login_success",
                          sender: self)
      })
  }
  
  // MARK: - Animation layer
  private func addAnimations() -> CAAnimationGroup {
    let strokeStartAnimation =
      CABasicAnimation(keyPath: "strokeStart")
    strokeStartAnimation.fromValue = 0
    strokeStartAnimation.toValue = 1
    let strokeEndAnimation =
      CABasicAnimation(keyPath: "strokeEnd")
    strokeEndAnimation.fromValue = 0
    strokeEndAnimation.toValue = 1.2
    let animationGroup = CAAnimationGroup()
    animationGroup.duration = 4
    animationGroup.repeatCount = .infinity
    animationGroup.speed = 1.1
    animationGroup.animations = [strokeStartAnimation,
                                 strokeEndAnimation]
    return animationGroup
  }
  
  // MARK: - Cat's face
  private func createAnimatedCatFace() -> CatLoadingView {
    // adding cat's face
    let anim = CatLoadingView()
    anim.backgroundColor = .clear
    anim.frame = CGRect(x: 0, y: 0,
                        width: 77*3, height: 55*3)
    anim.center = CGPoint(x: view.bounds.midX,
                          y: view.bounds.midY)
    view.addSubview(anim)
    // adding animated layer
    let customLayer = CAShapeLayer()
    customLayer.path = anim.addFace().cgPath
    customLayer.backgroundColor = UIColor.clear.cgColor
    customLayer.fillColor = .none
    customLayer.strokeColor = UIColor.white.cgColor
    customLayer.lineCap = .round
    customLayer.lineWidth = 10
    customLayer.add(addAnimations(), forKey: nil)
    anim.layer.addSublayer(customLayer)
    
    anim.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    anim.alpha = 0
    
    return anim
  }
  
  // MARK: - Alerts
  private func showLoginError() {
    let alert = UIAlertController(
      title: "Ошибка",
      message: "Введите имя, пароль можно не вводить",
      preferredStyle: .alert)
    let action = UIAlertAction(
      title: "ОК", style: .cancel, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  private func showTokenExpiredAlert() {
    let tokenExpires = Session.shared.tokenExpires
    let dateExpires = Date(
      timeIntervalSinceReferenceDate: tokenExpires)
    let alert = UIAlertController(
      title: "Внимание",
      message: "Токен устарел \(dateExpires)",
      preferredStyle: .alert)
    let action = UIAlertAction(
      title: "ОК", style: .cancel) { [weak self] _ in
      self?.removeVkCookies()
      self?.loginWithVK(self!.loginWithVKButton)
    }
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
}
