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
    private var loginPresenter: LoginPresenter!

    
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
        case .password:
            passwordErrrorTF.isHidden = false
            passwordErrrorTF.text = message
            passWordErrorColor()
        }
    }

    func routeToMain() {
        if let uwWindow = (UIApplication.shared.delegate as? AppDelegate)?.window {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "MainViewController")
            let loginNavigation = UINavigationController(rootViewController: loginVC)
            uwWindow.rootViewController = loginNavigation// Đưa cho windown 1 viewcontroller
            /// Make visible keywindown
            uwWindow.makeKeyAndVisible()
        } else {
            print("LỖI")
        }
    }
    @IBAction func forgotPWBtn(_ sender: Any) {
        goToForgotPassword()
    }
    @IBAction func LoginButton(_ sender: Any) {
        loginPresenter.login(email: emailTF.text ?? "", password: passwordTF.text ?? "")
    }
    @IBAction func signUpBtn(_ sender: Any) {
        goToResgister()
    }
    func goToResgister() {
        /**
         Step 1: Lấy được instance của class RegisterController từ storyboard Main
         Step 2: Gọi navigation controller từ màn login để thực hiện push register controller
         Step 3: Nếu muốn back lại thì sử dụng pop
         */
        
        /// Step 1: Lấy được instance của class RegisterController từ storyboard Main
        /**
         Step 1.1: Khởi tạo đối tượng của storyboard Main
         name: "Main" => Tên file storyboard
         */
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        /**
         Step 1.2: Gọi ra instance của 1 viewcontroller bất kỳ dựa vào StoryboardID
         */
        
        let registerViewController: RegisterViewController = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        
        
//        registerViewController.bienNhanDuLieuTuLogin = "Data tu login"
        
        /// Có thể ép kiểu từ UIViewController => RegisterViewController
        /// as? => Optional
        /// as! => NẾu mà không ép kiểu được thì sẽ bị crash
        
        /// Step 2: Gọi navigation controller từ màn login để thực hiện push register controller
        navigationController?.pushViewController(registerViewController, animated: true )
    }
    func goToForgotPassword() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let forgotVC: ForgotPasswordViewController = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        //gán giá trị email sau khi reset mật khẩu
        forgotVC.onSuccessResetPassword = { [weak self] email in
            self?.emailTF.text = email
            self?.passwordTF.text = ""
        }
        navigationController?.pushViewController(forgotVC, animated: true )
    }
}
        
