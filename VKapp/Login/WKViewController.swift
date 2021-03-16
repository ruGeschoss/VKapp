//
//  WKViewController.swift
//  VKapp
//
//  Created by Alexander Andrianov on 11.02.2021.
//

import UIKit
import WebKit

class WKViewController: UIViewController {
    
    @IBOutlet weak var webKitView: WKWebView! {
        didSet {
            webKitView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "oauth.vk.com"
        components.path = "/authorize"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: "7758387"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.92")
        ]
        
        let request = URLRequest(url: components.url!)
        webKitView.load(request)
    }
    
}

extension WKViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
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
        
        print(params)
        
        guard let token = params["access_token"],
              let userIdString = params["user_id"],
              let _ = Int(userIdString) else {
            decisionHandler(.allow)
            dismiss(animated: true)
            return
        }
        
        Session.shared.token = token
        Session.shared.userId = userIdString
    
        NetworkManager.getProfileDataSJ()
        
        decisionHandler(.cancel)
        
        guard Session.shared.token != "" else { return }
        
        if let vc = self.presentingViewController as? LoginVC {
            dismiss(animated: true) {
                vc.nextScreenAnim()
            }
        }
    }
}
