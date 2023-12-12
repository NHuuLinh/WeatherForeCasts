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
        
        FirebaseApp.configure()
        NetworkMonitor.shared.startMonitoring()
            return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    


}

