//
//  LoginPresenter.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 17/10/2023.
//

import Foundation
import FirebaseAuth

protocol LoginPresenter {
    func login(email: String, password: String)
    func validateForm(email: String, password: String) -> Bool
}

class LoginPresenterImpl: LoginPresenter {
    var loginVC: LoginViewControllerDisplay // Liên kết đến LoginViewController

    init(loginVC: LoginViewControllerDisplay) {
        self.loginVC = loginVC
    }
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    /**
     Cần 1 trạng thái là pass validate hay không? -> Bool
     */
    func validateForm(email: String, password: String) -> Bool {
        var isEmailValid = false
//        var emailErrorMsg: String?
//        loginVC.loginValidateFailure(field: .email,
//                                     message: emailErrorMsg)
        if email.isEmpty {
//            emailErrorMsg = "Email can't empty"
            loginVC.loginValidateFailure(field: .email,
                                         message: "Email can't empty")
            loginVC.emailErrorColor()
        }
        else if (!isValidEmail(email)) {
//            emailErrorMsg = "Email invalid"
            loginVC.loginValidateFailure(field: .email,
                                         message: "Email invalid")
            loginVC.emailErrorColor()
        }
        else {
//            emailErrorMsg = nil
            isEmailValid = true
            loginVC.emailValid()
        }

        var isPasswordValid = false
        if password.isEmpty {
            loginVC.loginValidateFailure(field: .password,
                                         message: "Password can't empty")
            loginVC.passWordErrorColor()
        }
        else if password.count < 6 {
            loginVC.loginValidateFailure(field: .password,
                                         message: "Password must be at least 6 characters long.")
            loginVC.passWordErrorColor()
        }
        else {
            loginVC.loginValidateFailure(field: .password, message: nil)
            isPasswordValid = true
            loginVC.passwordValid()
        }
        let isValid = isEmailValid && isPasswordValid
        return isValid
    }
    /// Viết logic xử lý login ở đây
    func login(email: String, password: String) {
        // Validate trước khi call API
        let isValid = validateForm(email: email, password: password)
        guard isValid else {
            /// Không pass validate thì không làm gì cả.
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else {return}
//            loginVC.showLoading(isShow: true)
            guard error == nil else {
                var message = ""
                
                switch AuthErrorCode.Code(rawValue: error!._code) {
                case .userDisabled:
                    message = "Tài khoản đã bị vô hiệu hoá"
                case .wrongPassword:
                    message = "Sai mật khẩu! Vui lòng thử lại"
                case .userNotFound:
                    message = "Không tìm thấy tài khoản với email đã nhập"
                default:
                    message = error?.localizedDescription ?? "Lỗi không xác định"
                }
                loginVC.loginFailure(message: message)
                print("fail")
                return
            }
            loginVC.routeToMain()
            print("gotoMain")
        }
    }
}
