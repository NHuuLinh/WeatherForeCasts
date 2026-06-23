//
//  AppCoordinator.swift
//  WeatherForeCasts
//
//  Created by Huu Linh Nguyen on 23/6/26.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseCore

class AppCoordinator {
    private let window: UIWindow
    private let viewModel = AppViewModel()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    private func checkTheme(){
        if let selectedTheme = UserDefaults.standard.selectedTheme {
            print("Selected Theme:", selectedTheme.rawValue)
            ThemeManager.shared.applyTheme(selectedTheme, to: window)
        } else {
            print("No theme saved. Using default theme.")
            ThemeManager.shared.applyTheme(.system, to: window)
        }
    }
    func routeWindow(){
            // kiểm tra xem có người dùng đã chọn theme chưa, nếu chưa load theme theo hệ thống
        checkTheme()
        let destination = viewModel.checkLaunchDestination()
        switch destination {
        case .noInternet:
            routeToScene(.noInternet)
        case .onboard:
            routeToScene(.onboard)
        case .login:
            routeToScene(.login)
        case .main:
            routeToScene(.main)
        }
    }
    
    // điều hứng sang onBoard
    func routeToScene(_ scene:AppScene) {
        print("Cho vào man :\(scene.identifier)")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: scene.identifier)
        if scene.needsNavigation {
            let navigationVC = UINavigationController(rootViewController: vc)
            window.rootViewController = navigationVC
        } else {
            window.rootViewController = vc
        }
        window.makeKeyAndVisible()
    }

    
}
extension AppCoordinator {
    
    // điều hứng sang màn hình mất mạng
    func routeToNoInternetAccess() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let noInernetVC = storyboard.instantiateViewController(withIdentifier: "NoInternetAccessViewController")
        let noInternetNavigation = UINavigationController(rootViewController: noInernetVC)
        window.rootViewController = noInternetNavigation
        window.makeKeyAndVisible()
    }
    
    // điều hứng sang onBoard
    func routeToOnboard() {
        print("Đã login rồi. Cho vào main")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let onboardVC = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController")
        window.rootViewController = onboardVC
        window.makeKeyAndVisible()
    }

    // điều hứng sang Login
    func routeToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        let loginNavigation = UINavigationController(rootViewController: loginVC)
        window.rootViewController = loginNavigation
        window.makeKeyAndVisible()
    }

    // điều hứng sang MainVC
    func routeToMain() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController")
            let mainNavigation = UINavigationController(rootViewController: mainVC)
            window.rootViewController = mainNavigation
        
            window.makeKeyAndVisible()
    }
}

