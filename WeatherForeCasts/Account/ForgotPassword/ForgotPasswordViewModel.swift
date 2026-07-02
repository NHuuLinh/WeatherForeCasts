//
//  ForgotPasswordViewModel.swift
//  WeatherForeCasts
//
//  Created by Huu Linh Nguyen on 27/6/26.
//

import Foundation
import Combine
import FirebaseAuth

class ForgotPasswordViewModel {
    @Published var errorMsg: FireBaseError?
    @Published var isLoading = false
    @Published var isSuccess = false
    private var cancellables = Set<AnyCancellable>()
    private let weatherAPIManager = WeatherAPIManager.shared
    
    
    func sendRequestToFirebase(email: String){
        isLoading = true
        errorMsg = nil
        isSuccess = false
        weatherAPIManager.forgetPassword(email: email)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.errorMsg = error
                case .finished:
                    break
                }
            } receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.isSuccess = true
            }
            .store(in: &cancellables)
        }
    func loginBySocialNW(){
        errorMsg = .loginBySocialNW
    }
    
}
