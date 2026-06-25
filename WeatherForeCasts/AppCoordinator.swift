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
    
    static let shared = AppCoordinator()
    private weak var window: UIWindow?
    private let viewModel = AppViewModel()
    
    
    private init() {}
    
    func configureWindow(_ window: UIWindow) {
        self.window = window
        routeWindow()
    }
    
    private func checkTheme(){
        DispatchQueue.global(qos: .background).async {
            let selectedTheme = UserDefaults.standard.selectedTheme ?? .system
            DispatchQueue.main.async {
                ThemeManager.shared.applyTheme(selectedTheme, to: self.window)
            }
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
    func routeToScene(_ scene:(AppScene)) {
        print("Cho vào man :\(scene.identifier)")
        guard let window = window else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: scene.identifier)
//        switch scene {
//        case .onboard :
//            window.rootViewController = vc
//        default :
//            let navigationVC = UINavigationController(rootViewController: vc)
//            window.rootViewController = navigationVC
//            
//        }
        if scene.needsNavigation {
            let navigationVC = UINavigationController(rootViewController: vc)
            window.rootViewController = navigationVC
        } else {
            window.rootViewController = vc
        }
        window.makeKeyAndVisible()
    }
    
    func navigateToVC(from sourceVC: UIViewController, withIdentifier identifier: AppScene, setup: ((UIViewController) -> Void)? = nil) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: identifier.identifier) as? UIViewController {
            setup?(viewController)
            sourceVC.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    
}

