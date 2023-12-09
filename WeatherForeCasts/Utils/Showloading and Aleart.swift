import MBProgressHUD
import Foundation
import UIKit

class LoadingAndAlert {

    static func showLoading(in viewController: UIViewController, isShow: Bool) {
        if isShow {
            let hud = MBProgressHUD.showAdded(to: viewController.view, animated: true)
            hud.label.text = "Loading"
        } else {
            MBProgressHUD.hide(for: viewController.view, animated: true)
        }
    }
    
    static func showAlert(in viewController: UIViewController, title: String, message: String, completionHandler: (()->Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler?()
        }
        alert.addAction(action)
        viewController.present(alert, animated: true)
    }
}
