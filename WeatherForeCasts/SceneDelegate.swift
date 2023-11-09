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
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        (UIApplication.shared.delegate as? AppDelegate)?.window = window
//        guard let _ = (scene as? UIWindowScene) else { return }
//        guard let scene = (scene as? UIWindowScene) else { return }
//        window = UIWindow(windowScene: scene)
    
        if UserDefaults.standard.hasOnboarded {
            if Auth.auth().currentUser != nil {
//                gotoHomeViewController()
                gotoLoginViewController()

            } else {
                gotoLoginViewController()
            }
        } else {
            gotoOnBroad()
        }
    }

    private func gotoLoginViewController() {
            let storybroad = UIStoryboard(name: "Main", bundle: nil)
            let LoginVC = storybroad.instantiateViewController(withIdentifier: "LoginViewController")
        let loginNavigation = UINavigationController(rootViewController: LoginVC)
            window!.rootViewController = loginNavigation
            window!.makeKeyAndVisible()
    }
    private func gotoHomeViewController() {
        let storybroad = UIStoryboard(name: "Main", bundle: nil)
        let MainVC = storybroad.instantiateViewController(withIdentifier: "MainViewController")
        let loginNavigation = UINavigationController(rootViewController: MainVC)
        window!.rootViewController = MainVC
        window!.makeKeyAndVisible()
    }
    private func gotoOnBroad() {
        let storybroad = UIStoryboard(name: "Main", bundle: nil)
        let OnbroadVC = storybroad.instantiateViewController(withIdentifier: "OnboardingViewController")
        let OnbroadNavigation = UINavigationController(rootViewController: OnbroadVC)
        window!.rootViewController = OnbroadVC
        window!.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

