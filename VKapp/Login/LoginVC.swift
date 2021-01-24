//
//  LoginVC.swift
//  VKapp
//
//  Created by Alexander Andrianov on 22.12.2020.
//

import UIKit

class LoginVC: UIViewController {
//    MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var loadingStatus: UIView!
    
//    MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loadingAnim = Bundle.main.loadNibNamed("LoadingProcess", owner: nil, options: nil)?.first as! LoadingProcessView
        loadingAnim.frame = CGRect(x: 0, y: 0, width: 120, height: 40)
        self.loadingStatus.addSubview(loadingAnim)
        loadingAnim.animate()
        

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnScroll))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow (notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide (notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow (notification: Notification) {
        guard let kbSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
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
        guard let login = loginTextField.text, let password = passwordTextField.text else { return false }
        if login == "admin" && password == "admin" {
            return true
        } else {
            return false
        }
    }
    func showLoginError() {
        let alert = UIAlertController(title: "Ошибка", message: "Введите admin в оба поля", preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
//    MARK: - Actions
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {}
    @IBAction func signInButton(_ sender: UIButton) {
        performSegue(withIdentifier: "login_success", sender: self)
    }
    @IBAction func signUpButton(_ sender: UIButton) {}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
