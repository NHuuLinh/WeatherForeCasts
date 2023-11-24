//
//  RegisterPresenter.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 15/10/2023.
//

import Foundation
import FirebaseAuth

protocol RegisterPresenter {
    func register(by email: String, with password: String)
}

class RegisterPresenterImpl: RegisterPresenter {
    let registerVC: RegisterDisplay
    
    init(registerVC: RegisterDisplay) {
        self.registerVC = registerVC
    }
    
    func register(by email: String, with password: String) {
        registerVC.loading(isLoading: true)
        Auth.auth().createUser(withEmail: email, password: password) { authResult, err in
            self.registerVC.loading(isLoading: false)
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
                self.registerVC.registerFailure(message: message)
                return
            }
            self.registerVC.registerSuccess()
        }
    }
}
