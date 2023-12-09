
import Foundation
import UIKit
class AppRouter {
    static func showMainScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        let mainNavigation = UINavigationController(rootViewController: mainVC)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = mainNavigation
            window.makeKeyAndVisible()
        }
    }

    static func showOnboardingScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let onboardVC = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController")
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = onboardVC
            window.makeKeyAndVisible()
        }
    }

    static func showLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        let loginNavigation = UINavigationController(rootViewController: loginVC)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = loginNavigation
            window.makeKeyAndVisible()
        }
    }
}

