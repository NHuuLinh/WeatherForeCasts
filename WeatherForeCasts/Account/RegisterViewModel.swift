//
//  RegisterViewModel.swift
//  WeatherForeCasts
//
//  Created by Huu Linh Nguyen on 26/6/26.
//

import Foundation
import FirebaseAuth
import KeychainSwift
import Combine

class RegisterViewModel {
    @Published var isLoading = false
    @Published var errorMess: FireBaseError?
    @Published var isRegisterSuccess = false

    let keychain = KeychainSwift()
    private let weatherAPIManager = WeatherAPIManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init(isLoading: Bool = false, errorMess: FireBaseError? = nil) {
        self.isLoading = isLoading
        self.errorMess = errorMess
    }
    
    func register(email: String, password: String){
        isLoading = true
        weatherAPIManager.register(email: email, password: password)
        // đăng kí thành công, gửi email xác nhận
            .flatMap { [weak self] _ -> AnyPublisher<Void, FireBaseError> in
                guard let self = self else {
                    return Fail(error: .unknownError(message: nil)).eraseToAnyPublisher()
                }
                return self.weatherAPIManager.sendEmailVerification()
            }
        // đăng xuất tài khoản
            .flatMap { [weak self] _ -> AnyPublisher<Void, FireBaseError> in
                guard let self = self else {
                    return Fail(error: .unknownError(message: nil)).eraseToAnyPublisher()
                }
                return self.weatherAPIManager.signOut()
            }
        // completion có 2 trường hợp:
        // .finished → tất cả 3 bước thành công
        // .failure  → 1 trong 3 bước thất bại → nhảy thẳng vào đây, bỏ qua các bước còn lại
            .sink { [weak self] completion in
                guard let self = self else {return}
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMess = error
                }
                
            } receiveValue: { [weak self] _ in
                guard let self = self else {return}
                self.isLoading = false
                self.keychain.set(email, forKey: "email")
                self.keychain.set(password, forKey: "password")
                self.isRegisterSuccess = true
            }
            .store(in: &cancellables)
    }
    
    
    func loginBySocialNW() {
        errorMess = .loginBySocialNW
    }
}
