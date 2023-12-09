//
//  AppDelegate.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 14/10/2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth



@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var shared: AppDelegate?

    var window: UIWindow?
    static let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // đổi theme


//        if let selectedTheme = UserDefaults.standard.selectedTheme {
//            print("Selected Theme:", selectedTheme.rawValue)
//            applyTheme(selectedTheme)
//        } else {
//            // If no theme is saved, you can set a default theme here
//            print("No theme saved. Using default theme.")
//            applyTheme(.system)
//        }
        
        FirebaseApp.configure()
        NetworkMonitor.shared.startMonitoring()
            return true
    }
//    func applyTheme(_ theme: Theme) {
//        switch theme {
//        case .light:
//            window?.overrideUserInterfaceStyle = .light
//            window?.tintColor = UIColor.black
//            window?.backgroundColor = .white
//            print("Selected Theme:light")
//            // Customize other light theme colors if needed
//        case .dark:
//            window?.overrideUserInterfaceStyle = .dark
//            // Customize dark theme colors
//            window?.tintColor = UIColor.red
////            window?.backgroundColor = UIColor.systemBackground
//            window?.backgroundColor = .black
//            print("Selected Theme:dark")
//
//
//            // Set other dark theme colors as needed
//        case .system:
//            window?.overrideUserInterfaceStyle = .unspecified
//            print("Selected Theme:system")
//
//            // Customize other system theme colors if needed
//        }
//        // Save the theme to UserDefaults
//        UserDefaults.standard.selectedTheme = theme
//    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    


}

