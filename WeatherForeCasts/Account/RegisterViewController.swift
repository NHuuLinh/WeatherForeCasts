
import UIKit
import FirebaseAuth

protocol RegisterDisplay {
    func loading(isLoading: Bool)
    func registerFailure(message: String)
    func registerSuccess()
}

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    private var registerPresenter: RegisterPresenter!
    
    override func viewDidLoad() {
        registerPresenter = RegisterPresenterImpl(registerVC: self)
        super.viewDidLoad()
    }


    @IBAction func checkTextFieldChanged(_ sender: UITextField) {
        print("value: \(sender.text ?? "")")
    }
    @IBAction func RegisterBtn(_ sender: UITextField) {
        switch sender {
        case registerBtn:
            let email = emailTF.text ?? ""
            let password = passwordTF.text ?? ""
            if password.count < 6 {
                let alert = UIAlertController(title: "Lỗi", message: "Password phải từ 6 kí tự trở lên", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true)
                return
            }
            registerPresenter.register(by: email, with: password)
        default:
            break
        }
        
    }
    private func handleRegister() {
        let email = emailTF.text ?? ""
        let password = passwordTF.text ?? ""
        
        if password.count < 6 {
            let alert = UIAlertController(title: "Lỗi", message: "Password phải từ 6 kí tự trở lên", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
            return
        }
        registerBtn.isEnabled = false
        registerBtn.setTitle("Loading...", for: .normal)
        Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] authResult, err in
            guard let self = self else { return }
        })
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, err in
            guard let self = self else { return }
            self.registerBtn.isEnabled = true
            self.registerBtn.setTitle("Register", for: .normal)
            guard err == nil else {
                var message = ""
                switch AuthErrorCode.Code(rawValue: err!._code) {
                case .emailAlreadyInUse:
                    message = "Email đã tồn tại"
                case .invalidEmail:
                    message = "Email không hợp lệ"
                default:
                    message = err?.localizedDescription ?? ""
                }
                let alert = UIAlertController(title: "Lỗi", message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true)
                return
            }
            self.routeToMain()
        }
    }
    @IBAction func goToLoginVC(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    private func routeToMain() {
        if let uwWindow = (UIApplication.shared.delegate as? AppDelegate)?.window {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "MainViewController")
            
            let loginNavigation = UINavigationController(rootViewController: loginVC)
            
            uwWindow.rootViewController = loginNavigation// Đưa cho windown 1 viewcontroller
            /// Make visible keywindown
            uwWindow.makeKeyAndVisible()
        } else {
            print("LỖI")
        }
    }
}
extension RegisterViewController: RegisterDisplay {
    func loading(isLoading: Bool) {
        if isLoading {
            registerBtn.isEnabled = false
            registerBtn.setTitle("Loading...", for: .normal)
        } else {
            self.registerBtn.isEnabled = true
            self.registerBtn.setTitle("Register", for: .normal)
        }
    }
    func registerFailure(message: String) {
        let alert = UIAlertController(title: "Lỗi", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func registerSuccess() {
        self.routeToMain()
    }
}
