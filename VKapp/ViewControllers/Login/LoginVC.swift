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

class LoginVC: UIViewController {
  // MARK: - Outlets
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var loginTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var signInButton: UIButton!
  @IBOutlet weak var loadingStatus: UIView!
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var loginWithVKButton: UIButton!
  @IBOutlet weak var signUpButton: UIButton!
  
  var shouldAutoLogin = true
  
  // MARK: - Functions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnScroll))
    view.addGestureRecognizer(tapGesture)
    view.isUserInteractionEnabled = true
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow (notification:)),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillHide (notification:)),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if shouldAutoLogin {
      guard Session.shared.token != "" else { return }
      nextScreenAnim()
    }
  }
  
  @objc func keyboardWillShow (notification: Notification) {
    guard let kbSize = notification
            .userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
    let insets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.size.height, right: 0)
    scrollView.contentInset = insets
  }
  
  @objc func keyboardWillHide (notification: Notification) {
    let insets = UIEdgeInsets.zero
    scrollView.contentInset = insets
  }
  
  @objc func didTapOnScroll () {
    view.endEditing(true)
  }
  
  //    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
  //        switch identifier {
  //        case "login_success":
  //            let checkResult = checkUserData()
  //            if !checkResult {
  //                showLoginError()
  //            }
  //            return checkResult
  //        default:
  //            return true
  //        }
  //    }
  
  func checkUserData () -> Bool {
    guard let login = loginTextField.text,
          let password = passwordTextField.text else { return false }
    if login == "admin" && password == "admin" {
      return true
    } else {
      return false
    }
  }
  
  func showLoginError() {
    let alert = UIAlertController(title: "Ошибка",
                                  message: "Введите имя, пароль можно не вводить",
                                  preferredStyle: .alert)
    let action = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  func addAnimations() -> CAAnimationGroup {
    let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
    strokeStartAnimation.fromValue = 0
    strokeStartAnimation.toValue = 1
    let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
    strokeEndAnimation.fromValue = 0
    strokeEndAnimation.toValue = 1.2
    let animationGroup = CAAnimationGroup()
    animationGroup.duration = 4
    animationGroup.repeatCount = .infinity
    animationGroup.speed = 1.1
    animationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
    return animationGroup
  }
  
  func nextScreenAnim() {
    let anim = CatLoadingView() // adding cat's face
    anim.backgroundColor = .clear
    anim.frame = CGRect(x: 0, y: 0, width: 77*3, height: 55*3)
    anim.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    view.addSubview(anim)
    
    let customLayer = CAShapeLayer() // adding animated layer
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
    
    // MARK: Loading data to storage
    let realm = try? Realm()
    if realm!.objects(UserSJ.self).isEmpty || realm!.objects(Group.self).isEmpty {
      print("Started loading")
      NetworkManager.loadFriendsSJ(forUser: nil) {}
      NetworkManager.loadGroupsSJ(forUserId: nil) {}
    }
    
    // MARK: Show animation
    UIView.animateKeyframes(withDuration: 4, delay: 0, options: [], animations: {
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.05, animations: {
        // duration 0.2 sec
        self.stackView.alpha = 0
        self.signUpButton.alpha = 0
        self.loginWithVKButton.alpha = 0
      })
      UIView.addKeyframe(withRelativeStartTime: 0.05, relativeDuration: 0.1, animations: {
        // duration 0.4 sec
        anim.alpha = 1
      })
    }, completion: { _ in
      self.stackView.alpha = 1
      self.signUpButton.alpha = 1
      self.loginWithVKButton.alpha = 1
      anim.removeFromSuperview()
      self.performSegue(withIdentifier: "login_success", sender: self)
    })
  }
  private func removeCookie() {
    //        URLCache.shared.removeAllCachedResponses()
    //        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
    //        print("[WebCacheCleaner] All cookies deleted")
    
    WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
      records.forEach { record in
        guard record.displayName == "vk.com" || record.displayName == "mail.ru" else { return }
        WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {
          print("Finished removing data for \(record.displayName)")
        })
      }
    }
  }
  
  // MARK: - Actions
  
  @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
    shouldAutoLogin = false
    KeychainWrapper.standard.remove(forKey: "userToken")
    KeychainWrapper.standard.remove(forKey: "userId")
    KeychainWrapper.standard.remove(forKey: "userName")
    
    removeCookie()
  }
  
  @IBAction func signInButton(_ sender: UIButton) {
    didTapOnScroll()
    
    print(Session.shared.token)
    
    guard let name = loginTextField.text else { return }
    if name.count < 2 {
      showLoginError()
      return
    }
    
    nextScreenAnim()
    
  }
  
  @IBAction func loginWithVK(_ sender: UIButton) {
    guard let webkit = storyboard?
            .instantiateViewController(identifier: "WKViewController") as? WKViewController else { return }
    webkit.modalPresentationStyle = .fullScreen
    present(webkit, animated: true, completion: nil)
  }
  
  @IBAction func signUpButton(_ sender: UIButton) {}
  
}
