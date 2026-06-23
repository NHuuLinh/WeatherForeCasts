//
//  AppSceneEnum.swift
//  WeatherForeCasts
//
//  Created by Huu Linh Nguyen on 23/6/26.
//

import Foundation

enum AppScene {
    case onboard
    case login
    case main
    case noInternet
    
    var identifier: String {
        switch self {
        case .noInternet:
            return "NoInternetAccessViewController"
        case .onboard:
            return "OnboardingViewController"
        case .login:
            return "LoginViewController"
        case .main:
            return "MainViewController"
        }
    }
    
    var needsNavigation: Bool {
        switch self {
        case .onboard:
            return false
        case .noInternet,.login, .main:
            return true
        }
    }
}
