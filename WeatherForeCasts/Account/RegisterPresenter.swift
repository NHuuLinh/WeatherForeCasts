//
//  RegisterPresenter.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 15/10/2023.
//

import Foundation
import FirebaseAuth
import KeychainSwift

protocol RegisterPresenter {
    func register(email: String, password: String)
    func loginBySocialNW()
}

class RegisterPresenterImpl: RegisterPresenter {
    let keychain = KeychainSwift()
    let registerVC: RegisterDisplay
    
    init(registerVC: RegisterDisplay) {
        self.registerVC = registerVC
    }
    func register(email: String, password: String) {
        self.registerVC.showLoading(isShow: true)
        Auth.auth().createUser(withEmail: email, password: password) { [self] authResult, err in
            guard err == nil else {
                // Xử lý lỗi khi đăng ký tài khoản
                var message = ""
                switch AuthErrorCode.Code(rawValue: err!._code) {
                case .emailAlreadyInUse:
                    message = "Email đã tồn tại"
                case .invalidEmail:
                    message = "Email không hợp lệ"
                default:
                    message = err?.localizedDescription ?? ""
                }
                self.registerVC.showLoading(isShow: false)
                self.registerVC.showAlert(title: "Error", message: message)
                return
            }
            
            // Gửi email xác thực
            if let user = Auth.auth().currentUser {
                user.sendEmailVerification { (error) in
                    if let error = error {
                        print("Lỗi khi gửi email xác thực: \(error.localizedDescription)")
                    }
                }
            }
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                if firebaseAuth.currentUser == nil {
                }  else {
                    print("Error: User is still signed in")
                }
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
            // Ẩn loading indicator
            self.registerVC.showLoading(isShow: false)
            // Lưu email và password vào Keychain
            self.keychain.set(email, forKey: "email")
            self.keychain.set(password, forKey: "password")
            // Hiển thị thông báo cho người dùng về việc kiểm tra email để xác thực
            self.registerVC.showAlert(title: "Success", message: "Đăng ký thành công. Vui lòng kiểm tra email để xác thực tài khoản.") {
                self.registerVC.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    func loginBySocialNW(){
        let title = NSLocalizedString("The feature is under development", comment: "")
        let message = NSLocalizedString("The feature is under development, please try again later.", comment: "")
        self.registerVC.showAlert(title: title, message: message)
    }
}
