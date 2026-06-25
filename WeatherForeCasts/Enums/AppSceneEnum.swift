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
    case registerVC
    case forgotPasswordVC
    case profileVC
    case weatherLongDayVC
    case mapsVC
    case dailyForecastVC
    case setingVC
    
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
        case .registerVC:
            return "RegisterViewController"
        case .forgotPasswordVC:
            return "ForgotPasswordViewController"
        case .profileVC:
            return "ProfileViewController"
        case .weatherLongDayVC:
            return "WeatherLongDayViewController"
        case .mapsVC:
            return "MapsViewController"
        case .dailyForecastVC:
            return "DailyForecastViewController"
        case .setingVC:
            return "SetingViewController"
        }
    }
    
    var needsNavigation: Bool {
        switch self {
        case .onboard:
            return false
        default :
            return true
        }
    }
}
