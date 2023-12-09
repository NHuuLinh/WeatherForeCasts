
import Foundation
import UIKit
// Để in thông tin về visibleViewController, bạn có thể sử dụng extension sau:
extension UIViewController {
    var visibleViewController: UIViewController? {
//        if let navigationController1 = self as? UINavigationController {
////            return navigationController1.visibleViewController
//        }
        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController
        }
        if let presentedViewController = presentedViewController {
            return presentedViewController.visibleViewController
        }
        return self
    }
}

