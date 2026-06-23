//
//  AppViewModel.swift
//  WeatherForeCasts
//
//  Created by Huu Linh Nguyen on 23/6/26.
//

import Foundation
import FirebaseAuth
import FirebaseCore

enum AppLaunchDestination {
    case onboard
    case login
    case main
    case noInternet
}

class AppViewModel {
    func checkLaunchDestination() -> AppLaunchDestination {
            let isReachable = NetworkMonitor.shared.isReachable
            let hasOnboarded = UserDefaults.standard.hasOnboarded
            let isLoggedIn = Auth.auth().currentUser != nil
            
            if isReachable {
                if !hasOnboarded {
                    return .onboard
                } else {
                    return isLoggedIn ? .main : .login
                }
            } else {
                if hasOnboarded && isLoggedIn {
                    return .main
                } else {
                    return .noInternet
                }
            }
        }
}
