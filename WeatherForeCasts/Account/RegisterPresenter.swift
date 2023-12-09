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
    
    func register(email: String,password: String) {
        self.registerVC.showLoading(isShow: true)
        Auth.auth().createUser(withEmail: email, password: password) { [self] authResult, err in
            guard err == nil else {
                /// Cach xử lý custom error.
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
                self.registerVC.showAlert(title: "error", message: message)
                return
            }
            AppDelegate.scene?.goToMain()
            self.keychain.set(email, forKey: "email")
            self.keychain.set(password, forKey: "password")
        }
    }
    func loginBySocialNW(){
        self.registerVC.showAlert(title: "The feature is under development", message: "The feature is under development, please try again later.")
    }

}
