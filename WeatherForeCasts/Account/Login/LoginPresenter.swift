//
//  LoginPresenter.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 17/10/2023.
//

import Foundation
import FirebaseAuth
import KeychainSwift

protocol LoginPresenter {
    func login(email: String, password: String)
    func loginBySocialNW()
}

class LoginPresenterImpl: LoginPresenter {
    let keychain = KeychainSwift()
    var loginVC: LoginViewControllerDisplay
    
    init(loginVC: LoginViewControllerDisplay) {
        self.loginVC = loginVC
    }

    func login(email: String, password: String) {
        self.loginVC.showLoading(isShow: true)
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            guard error == nil else {
                var message = ""
                switch AuthErrorCode.Code(rawValue: error!._code) {
                case .userDisabled:
                    message = "Account is disabled"
                case .wrongPassword:
                    message = "Wrong password"
                case .userNotFound:
                    message = "Email not found"
                default:
                    message = error?.localizedDescription ?? "Unknow error"
                }
                self.loginVC.showLoading(isShow: false)
                self.loginVC.showAlert(title: "Warning", message: message)
                print("\(message)")
                return
            }
            guard let user = Auth.auth().currentUser else {
                // Đối tượng user không tồn tại
                return
            }
            
            if user.isEmailVerified {
                // Cho phép đăng nhập
                // Điều hành đến màn hình chính hoặc thực hiện các bước khác sau khi đăng nhập
                AppDelegate.scene?.goToMain()
                keychain.set(email, forKey: "email")
                keychain.set(password, forKey: "password")
                print("Đăng nhập thành công")
            } else {
                // Hiển thị thông báo cho người dùng rằng họ cần xác thực email trước khi đăng nhập
                self.loginVC.showLoading(isShow: false)
                self.loginVC.showAlert(title: "Error", message: "Vui lòng xác thực email trước khi đăng nhập.")
                // Gửi lại email xác thực (nếu cần)
                user.sendEmailVerification { (sendEmailError) in
                    if let error = sendEmailError {
                        print("Lỗi khi gửi lại email xác thực: \(error.localizedDescription)")
                    }
                }
                
            }
        }
    }
        func routeToMain() {
            if let uwWindow = (UIApplication.shared.delegate as? AppDelegate)?.window {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController")
                let mainNavigation = UINavigationController(rootViewController: mainVC)
                uwWindow.rootViewController = mainNavigation// Đưa cho windown 1 viewcontroller
                /// Make visible keywindown
                uwWindow.makeKeyAndVisible()
            } else {
                print("LỖI")
            }
        }
        func loginBySocialNW(){
            let title = NSLocalizedString("The feature is under development", comment: "")
            let message = NSLocalizedString("The feature is under development, please try again later.", comment: "")
            self.loginVC.showAlert(title: title, message: message)
        }
    }
    
