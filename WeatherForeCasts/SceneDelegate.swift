//
//  SceneDelegate.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 14/10/2023.
//

import UIKit
import FirebaseAuth
import FirebaseCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    static let shared = SceneDelegate()
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        /**
         Khởi tạo window từ windownScene
         */
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        // kiểm tra xem có người dùng đã chọn theme chưa, nếu chưa load theme theo hệ thống
        if let selectedTheme = UserDefaults.standard.selectedTheme {
            print("Selected Theme:", selectedTheme.rawValue)
            ThemeManager.shared.applyTheme(selectedTheme, to: window)
        } else {
            print("No theme saved. Using default theme.")
            ThemeManager.shared.applyTheme(.system, to: window)
        }
        
        /// Vứt cho appDelegate nó giữ để sau mình lấy ra cho dễ
        (UIApplication.shared.delegate as? AppDelegate)?.window = window
        
        let isReachableConnection = NetworkMonitor.shared.isReachable
        
        if isReachableConnection {
            // có mạng
            if UserDefaults.standard.hasOnboarded {
                if Auth.auth().currentUser != nil {
                    goToMain()
                    print("goToMain")
                } else {
                    goToLogin()
                    print("goToLogin")
                }
            } else {
                goToOnboard()
                print("goToOnboard")
            }
        } else {
            // mất mạng
            if UserDefaults.standard.hasOnboarded {
                if Auth.auth().currentUser != nil {
                    goToMain()
                } else {
                    routeToNoInternetAccess()
                }
            } else {
                routeToNoInternetAccess()
            }
            
        }
    }
    
    func goToMain() {
        print("Đã login rồi. Cho vào main")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        let mainNavigation = UINavigationController(rootViewController: mainVC)
        window!.rootViewController = mainNavigation
        window!.makeKeyAndVisible()
    }
    func goToOnboard() {
        print("Đã login rồi. Cho vào main")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let onboardVC = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController")
        window!.rootViewController = onboardVC
        window!.makeKeyAndVisible()
    }
    func goToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        let loginNavigation = UINavigationController(rootViewController: loginVC)
        window!.rootViewController = loginNavigation
        window!.makeKeyAndVisible()
    }
    func routeToNoInternetAccess() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let noInernetVC = storyboard.instantiateViewController(withIdentifier: "NoInternetAccessViewController")
        let noInternetNavigation = UINavigationController(rootViewController: noInernetVC)
        window!.rootViewController = noInternetNavigation
        window!.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
    
    
}


