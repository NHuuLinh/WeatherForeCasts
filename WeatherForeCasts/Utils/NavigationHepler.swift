
import Foundation
import UIKit

class NavigationHelper {
    static let shared = NavigationHelper()
    private init (){}
    
    func navigateToViewController(from sourceVC: UIViewController, withIdentifier identifier: String, setup: ((UIViewController) -> Void)? = nil) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? UIViewController {
            setup?(viewController)
            sourceVC.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
