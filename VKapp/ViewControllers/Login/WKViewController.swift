//
//  WKViewController.swift
//  VKapp
//
//  Created by Alexander Andrianov on 11.02.2021.
//

import UIKit
import WebKit

class WKViewController: UIViewController {
  
  @IBOutlet private weak var webKitView: WKWebView! {
    didSet {
      webKitView.navigationDelegate = self
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadVKlogin()
  }
  
}

extension WKViewController: WKNavigationDelegate {
  
  func webView(
    _ webView: WKWebView,
    decidePolicyFor navigationResponse: WKNavigationResponse,
    decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
    guard let url = navigationResponse.response.url,
          url.path == "/blank.html",
          let fragment = url.fragment else {
      decisionHandler(.allow)
      return
    }
    
    let params = fragment
      .components(separatedBy: "&")
      .map { $0.components(separatedBy: "=") }
      .reduce([String: String]()) { result, param in
        var dict = result
        let key = param[0]
        let value = param[1]
        dict[key] = value
        
        return dict
      }
    #if DEBUG
    print(params)
    #endif
    guard let token = params["access_token"],
          let userIdString = params["user_id"],
          let expiresIn = params["expires_in"],
          Double(expiresIn) != nil,
          Int(userIdString) != nil else {
      decisionHandler(.allow)
      dismiss(animated: true)
      return
    }
    let currentTime = Date.timeIntervalSinceReferenceDate
    Session.shared.token = token
    Session.shared.userId = userIdString
    Session.shared.tokenExpires = currentTime
      .advanced(by: Double(expiresIn)!)
    NetworkManager.getProfileDataSJ()
    decisionHandler(.cancel)
    
    guard Session.shared.token != "" else { return }
    if let loginVC = self.presentingViewController as? LoginVC {
      dismiss(animated: true) {
        loginVC.nextScreenAnim()
      }
    }
  }
}

extension WKViewController {
  // MARK: - Load login page
  private func loadVKlogin() {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "oauth.vk.com"
    components.path = "/authorize"
    components.queryItems = [
      URLQueryItem(name: "client_id", value: "7758387"),
      URLQueryItem(name: "scope", value: "270342"),
      URLQueryItem(name: "display", value: "mobile"),
      URLQueryItem(name: "redirect_uri",
                   value: "https://oauth.vk.com/blank.html"),
      URLQueryItem(name: "response_type", value: "token"),
      URLQueryItem(name: "v", value: "5.92")
    ]
    
    let request = URLRequest(url: components.url!)
    webKitView.load(request)
  }
}
