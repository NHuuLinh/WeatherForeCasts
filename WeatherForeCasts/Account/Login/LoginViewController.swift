
import UIKit
import FirebaseAuth
import MBProgressHUD
import KeychainSwift
import Combine


enum LoginFormField {
    case email
    case password
}

class LoginViewController: UIViewController,checkValid {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var emailErrorView: UIView!
    @IBOutlet weak var emailerrorTF: UITextField!
    @IBOutlet weak var emailTextView: UIView!
    @IBOutlet weak var errorViewHieght: NSLayoutConstraint!
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordErrrorTF: UITextField!
    @IBOutlet weak var passwordErorrView: UIView!
    @IBOutlet weak var passwordTextView: UIView!
    @IBOutlet weak var passwordErrorViewHieght: NSLayoutConstraint!
    
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var secureBtn: UIButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var SignInLb: UILabel!
    @IBOutlet weak var emailLb: UILabel!
    @IBOutlet weak var passwordLb: UILabel!
    @IBOutlet weak var dontHaveAcountLb: UILabel!
    @IBOutlet weak var orContinueWith: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let keychain = KeychainSwift()
    private let viewModel = LoginViewModel()
    private var cancelable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        translateLangue()
    }
    private func setupView(){
        clearBtn.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        //loading email,password người dùng đã đăng nhập thành công
        emailTF.text = keychain.get("email")
        passwordTF.text = keychain.get("password")
        scrollView.keyboardDismissMode = .interactiveWithAccessory
        checkValidInput()
        handleObserver()
    }
    
    func goToResgister() {
        AppCoordinator.shared.navigateToVC(from: self, withIdentifier: .registerVC)
        keychain.set(emailTF.text ?? "", forKey: "TemporaryEmail")
        keychain.set(passwordTF.text ?? "", forKey: "TemporaryPassword")
    }
    
    func goToForgotPassword() {
        AppCoordinator.shared.navigateToVC(from: self, withIdentifier: .forgotPasswordVC) { viewController in
            if let forgotVC = viewController as? ForgotPasswordViewController {
                forgotVC.onSuccessResetPassword = { [weak self] email in
                    self?.emailTF.text = email
                    self?.checkValidInput()
                }
            }
        }
        keychain.set(emailTF.text ?? "", forKey: "TemporaryEmail")
    }
    
    @IBAction func textDidChange(_ sender: UITextField) {
        clearBtn.isHidden = emailTF.text?.isEmpty ?? true
        checkValidInput()
    }
    
    @IBAction func handleBtn(_ button: UIButton) {
        switch button {
        case clearBtn :
            emailTF.text = ""
        case secureBtn:
            setupSecureButton(passwordTF: passwordTF, button: secureBtn)
        case forgotPasswordBtn:
            goToForgotPassword()
        case signUpBtn:
            goToResgister()
        case facebookBtn:
            viewModel.loginBySocialNW()
        case googleBtn:
            viewModel.loginBySocialNW()
        case loginBtn:
            viewModel.login(email: emailTF.text ?? "", password: passwordTF.text ?? "")
        default:
            break
        }
    }
    
    func handleObserver(){
        viewModel.$loginErrorMess
            .compactMap { $0}
            .sink { [weak self] errorMes in
                self?.showAlert(title: errorMes.title, message: errorMes.message)
            }
            .store(in: &cancelable)
        viewModel.$isloading
            .compactMap {$0}
            .sink { [weak self] isShow in
                self?.showLoading(isShow: isShow)
            }
            .store(in: &cancelable)
    }
    
}

extension LoginViewController {
    // các hàm passwordValidator,emailValidator xem ở extension Validator
    // các hàm handleInputTF, handleButton xem ở extension StandardForm
    func checkValidInput(){
        let email = emailTF.text ?? ""
        let emailResult = emailValidator(email)
        emailerrorTF.text = emailResult.message
        handleInputTF(status: emailResult.valid,
                      errorView: emailErrorView,
                      errorViewHeight: errorViewHieght,
                      textView: emailTextView)
        
        let password = passwordTF.text ?? ""
        let passwordResult = passwordValidator(password: password)
        passwordErrrorTF.text = passwordResult.message
        handleInputTF(status: passwordResult.valid,
                      errorView: passwordErorrView,
                      errorViewHeight: passwordErrorViewHieght,
                      textView: passwordTextView)
        
        handleButton(button: loginBtn,
                     emailResult: emailResult.valid,
                     passwordResult: passwordResult.valid)
    }
}
// MARK: - Dịch thuật
extension LoginViewController {
    func translateLangue(){
        SignInLb.text = NSLocalizedString(SignInLb.text ?? "", comment: "")
        emailLb.text = NSLocalizedString(emailLb.text ?? "", comment: "")
        passwordLb.text = NSLocalizedString(passwordLb.text ?? "", comment: "")
        forgotPasswordBtn.setTitle(NSLocalizedString(forgotPasswordBtn.currentTitle ?? "", comment: ""), for: .normal)
        dontHaveAcountLb.text = NSLocalizedString(dontHaveAcountLb.text ?? "", comment: "")
        signUpBtn.setTitle(NSLocalizedString(signUpBtn.currentTitle ?? "", comment: ""), for: .normal)
        orContinueWith.text = NSLocalizedString(orContinueWith.text ?? "", comment: "")
        loginBtn.setTitle(NSLocalizedString(loginBtn.currentTitle ?? "", comment: ""), for: .normal)
    }
}
