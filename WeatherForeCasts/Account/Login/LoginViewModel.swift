//
//  LoginViewModel.swift
//  WeatherForeCasts
//
//  Created by Huu Linh Nguyen on 25/6/26.
//
import Foundation
import FirebaseAuth
import KeychainSwift
import Combine


class LoginViewModel {
    let keychain = KeychainSwift()
    private weak var appCoordinator : AppCoordinator?
    @Published var loginErrorMess : LoginError?
    @Published var isloading = false

    
    init(appCoordinator: AppCoordinator? = nil) {
        self.appCoordinator = appCoordinator
    }

    func login(email: String, password: String) {
        isloading = true
        Auth.auth().signIn(withEmail: email, password: password) {
            [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                isloading = false
                loginErrorMess = .unknownError(message: error.localizedDescription)
                return
            } else {
                switch AuthErrorCode.Code(rawValue: error!._code) {
                case .userDisabled:
                    loginErrorMess = .userDisabled
                case .wrongPassword:
                    loginErrorMess = .wrongPassword
                case .userNotFound:
                    loginErrorMess = .userNotFound
                default:
                    loginErrorMess = .unknownError(message: error?.localizedDescription ?? "Unknow error")
                    isloading = false
                    return
                }
                guard let user = Auth.auth().currentUser else {
                    // Đối tượng user không tồn tại
                    loginErrorMess = .userNotFound
                    isloading = false
                    return
                }
                
                if user.isEmailVerified {
                    // Cho phép đăng nhập
                    // Điều hành đến màn hình chính hoặc thực hiện các bước khác sau khi đăng nhập
                    isloading = false
                    appCoordinator?.routeToScene(.main)
                    keychain.set(email, forKey: "email")
                    keychain.set(password, forKey: "password")
                    print("Đăng nhập thành công")
                } else {
                    isloading = false
                    // Hiển thị thông báo cho người dùng rằng họ cần xác thực email trước khi đăng nhập
                    //                self.loginVC.showLoading(isShow: false)
                    //                self.loginVC.showAlert(title: "Error", message: "Vui lòng xác thực email trước khi đăng nhập.")
                    // Gửi lại email xác thực (nếu cần)
                    loginErrorMess = .userNotFound
                    user.sendEmailVerification { (sendEmailError) in
                        if let error = sendEmailError {
                            print("Lỗi khi gửi lại email xác thực: \(error.localizedDescription)")
                        }
                    }
                    
                }
            }
        }
    }
        func loginBySocialNW(){
            let title = NSLocalizedString("The feature is under development", comment: "")
            let message = NSLocalizedString("The feature is under development, please try again later.", comment: "")
            loginErrorMess = .loginBySocialNW
        }
    }
    


