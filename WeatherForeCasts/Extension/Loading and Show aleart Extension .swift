import MBProgressHUD

extension UIViewController {
    func showLoading(isShow: Bool) {
        if isShow {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = "Loading"
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func showAlert(title: String, message: String, completionHandler: (()->Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler?()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
