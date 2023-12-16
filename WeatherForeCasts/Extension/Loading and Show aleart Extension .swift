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
    
    func showAlertAndAction(title: String, message: String, completionHandler: (() -> Void)? = nil, cancelHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // Thêm nút "OK" và hành động khi nhấn vào
        let okTitle = NSLocalizedString("Restart now", comment: "")
        let okAction = UIAlertAction(title: okTitle, style: .default) { _ in
            completionHandler?()
        }
        alert.addAction(okAction)

        // Thêm nút "Cancel" và hành động khi nhấn vào
        let cancelTitle = NSLocalizedString("Restart later", comment: "")
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            cancelHandler?()
        }
        alert.addAction(cancelAction)

        // Hiển thị hộp thoại
        self.present(alert, animated: true)
    }

}
