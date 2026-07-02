//
//  ProfileViewModel.swift
//  WeatherForeCasts
//
//  Created by Huu Linh Nguyen on 1/7/26.
//

import Foundation
import Combine
import UIKit
class ProfileViewModel {
    @Published var isLoading = false
    @Published var errorMsg : FireBaseError?
    @Published var userProfile : UserProfile?
    @Published var isUpdateSuccess = false
    @Published var avatarImage: UIImage?

    private var cancellables = Set<AnyCancellable>()
    private let weatherAPIManager = WeatherAPIManager.shared
    
    
    func loadProfile() {
        isLoading = true
        errorMsg = nil

        if UserDefaults.standard.didUpdateProfile {
            loadProfileFromCoreData()
        } else {
            loadProfileFromFirebase()
        }
    }
    
    func loadProfileFromFirebase() {
        var isLoading = true
        weatherAPIManager.loadDataFromFirebase()
            .sink { [weak self] completion in
                guard let self = self else {return}
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.errorMsg = error
                case .finished:
                    break
                }

            } receiveValue: { [weak self] data in
                guard let self = self else {return}
                self.isLoading = false
                self.userProfile = data
            }
            .store(in: &cancellables)
    }
    
    func updateProfile(profile: UserProfile,avatarImage: UIImage?) {
        isLoading = true
        errorMsg = nil
        isUpdateSuccess = false

        var avatarUploadPublisher: AnyPublisher<Void, FireBaseError> = Just(())
            .setFailureType(to: FireBaseError.self)
            .eraseToAnyPublisher()
        if let image = avatarImage, let imageData = image.pngData() {
            avatarUploadPublisher = weatherAPIManager.uploadAvatar(imageData: imageData)
                .map { _ in () }
                .eraseToAnyPublisher()
        }

        avatarUploadPublisher
            .flatMap { [weak self] _ -> AnyPublisher<Void, FireBaseError> in
                guard let self = self else {
                    return Fail(error: .unknownError(message: "Unknown Error")).eraseToAnyPublisher()
                }
                return self.weatherAPIManager.updateDataToFireBase(data: profile)
            }
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMsg = error
                }
            } receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.userProfile = profile

                let defaultImage = UIImage(named: "warning") ?? UIImage()
                CoreDataHelper.share.saveProfileValueToCoreData(
                    avatar: avatarImage ?? defaultImage,
                    name: profile.name ?? "",
                    dateOfBirth: profile.dateOfBirth ?? "",
                    phoneNumber: profile.phoneNumber ?? "",
                    gender: profile.gender ?? ""
                )
                UserDefaults.standard.didUpdateProfile = true
                self.isUpdateSuccess = true
            }
            .store(in: &cancellables)
    }
    private func loadProfileFromCoreData() {
        let data = CoreDataHelper.share.getProfileValuesFromCoreData()
        var loadedProfile = UserProfile(
            id: nil,
            name: data.name,
            gender: data.gender,
            dateOfBirth: data.dateOfBirth,
            email: "",
            phoneNumber: data.phoneNumber,
            avatar: nil,
            favorited: nil,
            searchHistory: nil
        )
        self.avatarImage = data.avatar
        self.userProfile = loadedProfile
        self.isLoading = false
    }

}
