//
//  LoginViewController.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 15/10/2023.
//

import UIKit
import FirebaseAuth
import MBProgressHUD



protocol LoginViewControllerDisplay {
    func loginValidateFailure(field: LoginFormField, message: String?)
    func loginFailure(message: String)
    func showLoading(isShow: Bool)
    func routeToMain()
    func emailErrorColor()
    func passWordErrorColor()
    func passwordValid()
    func emailValid()
}
enum LoginFormField {
    case email
    case password
}
private var loginPresenter: LoginPresenter!


class LoginViewController: UIViewController, LoginViewControllerDisplay {

    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var emailErrorView: UIView!
    @IBOutlet weak var emailerrorTF: UITextField!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var emailTextView: UIView!
    @IBOutlet weak var errorViewHieght: NSLayoutConstraint!
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordErrrorTF: UITextField!
    @IBOutlet weak var passwordErorrView: UIView!
    @IBOutlet weak var passwordTextView: UIView!
    @IBOutlet weak var passwordErrorViewHieght: NSLayoutConstraint!
    
    override func viewDidLoad() {
        loginPresenter = LoginPresenterImpl(loginVC: self)
//        loginSocialPresenter = LoginSocialPresenterImpl(viewcontroller: self)
        super.viewDidLoad()
        /// Ẩn navigation bar
        navigationController?.setNavigationBarHidden(true, animated: true)
        setupView()
        emailTF.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)
    }
    struct RegistrationParameters: Encodable {
        let email: String
        let password: String
    }
    private func setupView(){
        clearBtn.isHidden = true
        emailTextView.layer.borderWidth = 2
        emailTextView.layer.cornerRadius = 6
        emailTextView.layer.borderColor = UIColor(red: 0.31, green: 0.29, blue: 0.4, alpha: 1).cgColor
        emailValid()
        //        passwordErorrView.isHidden = true
        //        passwordErrorViewHieght.constant = 0
        //        passwordErorrView.layoutIfNeeded()
        passwordTextView.layer.borderWidth = 2
        passwordTextView.layer.cornerRadius = 6
        passwordTextView.layer.borderColor = UIColor(red: 0.31, green: 0.29, blue: 0.4, alpha: 1).cgColor
        passwordValid()
    }
    @objc private func emailTextFieldDidChange() {
        if let emailText = emailTF.text, !emailText.isEmpty {
            clearBtn.isHidden = false
        } else {
            clearBtn.isHidden = true
        }
    }
    
    @IBAction func onClearButton(_ sender: Any) {
        emailTF.text = ""
        clearBtn.isHidden = true
    }
    
    func loginFailure(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    func emailErrorColor() {
        emailErrorView.isHidden = false
        emailTextView.backgroundColor = UIColor(red: 1, green: 0.95, blue: 0.97, alpha: 1)
        errorViewHieght.constant = 21
        emailTextView.layoutIfNeeded()
    }
    func passWordErrorColor(){
        passwordErorrView.isHidden = false
        passwordErorrView.layoutIfNeeded()
        passwordTextView.backgroundColor = UIColor(red: 1, green: 0.95, blue: 0.97, alpha: 1)
        passwordErrorViewHieght.constant = 21
    }
    func passwordValid(){
        passwordErorrView.isHidden = true
        passwordErorrView.layoutIfNeeded()
        passwordTextView.backgroundColor = .clear
        passwordErrorViewHieght.constant = 0
    }
    func emailValid(){
        emailErrorView.isHidden = true
        emailTextView.backgroundColor = .clear
        errorViewHieght.constant = 0
        emailTextView.layoutIfNeeded()
    }
    func loginValidateFailure(field: LoginFormField, message: String?) {
        switch field {
        case .email:
            emailerrorTF.isHidden = false
            emailerrorTF.text = message
            emailErrorColor()
            //            printContent(message)
        case .password:
            passwordErrrorTF.isHidden = false
            passwordErrrorTF.text = message
            passWordErrorColor()
            
        }
    }
    func routeToMain() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homePageVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        keyWindow?.rootViewController = homePageVC
    }
    func showLoading(isShow: Bool) {
        if isShow {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    @IBAction func LoginButton(_ sender: Any) {
        loginPresenter.login(email: emailTF.text ?? "", password: passwordTF.text ?? "")
        print("1123")
//        routeToMain()

    }
    func goToResgister() {
        let storybroad = UIStoryboard(name: "Main", bundle: nil)
        let RegisterVC = storybroad.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        navigationController?.pushViewController(RegisterVC, animated: true)
//        UserDefaults.standard.hasOnbroaded = true
    }
}
        
