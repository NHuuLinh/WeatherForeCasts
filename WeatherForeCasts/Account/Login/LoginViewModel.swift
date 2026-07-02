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
    private let appCoordinator = AppCoordinator.shared
    @Published var loginErrorMess : FireBaseError?
    @Published var isloading = false
    private let service = WeatherAPIManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
    }
    
    func loginBySocialNW(){
        loginErrorMess = .loginBySocialNW
    }
    func login(email: String, password: String) {
        loginErrorMess = nil
        isloading = true
        service.login(email: email, password: password)
        //1. check có lỗi gì không
            .flatMap { [weak self] _ -> AnyPublisher<Bool,FireBaseError> in
                guard let self = self else {
                    return Fail(error: .unknownError(message:"Unknown Error")).eraseToAnyPublisher()
                }
                return self.service.isEmailVerified()
            }
        //2. kiểm tra user hiện tại có đúng không và gửi email xác nhận nếu đúng
            .flatMap { [weak self] isVerified -> AnyPublisher<Void,FireBaseError> in
                guard let self = self else {
                    return Fail(error: .unknownError(message:"Unknown Error")).eraseToAnyPublisher()
                }
                if isVerified {
                    return Just(())
                        .setFailureType(to: FireBaseError.self)
                        .eraseToAnyPublisher()
                } else {
                    return self.service.sendEmailVerification()
                        .flatMap { _ -> AnyPublisher<Void, FireBaseError> in
                            Fail(error: FireBaseError.emailNotVerified).eraseToAnyPublisher()
                        }
                        .eraseToAnyPublisher()
                }
            }
        // xử lí kết quả trả về nếu đã ok hết
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isloading = false
                if case(.failure(let error)) = completion {
                    self.loginErrorMess = error
                }
            } receiveValue: {[weak self] _ in
                guard let self = self else { return }
                self.isloading = false
                self.appCoordinator.routeToScene(.main)
                keychain.set(email, forKey: "email")
                keychain.set(password, forKey: "password")
                print("Đăng nhập thành công")
            }
            .store(in: &cancellables)
    }
}



