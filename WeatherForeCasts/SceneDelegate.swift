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
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        /**
         Khởi tạo window từ windownScene
         */
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let actualWindow = UIWindow(windowScene: windowScene)
        self.window = actualWindow
        AppCoordinator.shared.configureWindow(actualWindow)

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


