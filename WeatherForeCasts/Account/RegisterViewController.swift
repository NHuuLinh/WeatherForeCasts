
import UIKit
import FirebaseAuth
import KeychainSwift

protocol RegisterDisplay: UIViewController {
    
}

class RegisterViewController: UIViewController, RegisterDisplay,checkValid {
    
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
    
    @IBOutlet weak var rePassworđTF: UITextField!
    @IBOutlet weak var rePasswordErrrorTF: UITextField!
    @IBOutlet weak var rePasswordErorrView: UIView!
    @IBOutlet weak var rePasswordTextView: UIView!
    @IBOutlet weak var rePasswordErrorViewHieght: NSLayoutConstraint!
    
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var securePasswordBtn: UIButton!
    @IBOutlet weak var secureRePasswordBtn: UIButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var registerLB: UILabel!
    @IBOutlet weak var passwordLb: UILabel!
    @IBOutlet weak var repasswordLb: UILabel!
    @IBOutlet weak var dotHaveAcountLb: UILabel!
    @IBOutlet weak var orContinueWith: UILabel!
    
    private var registerPresenter: RegisterPresenter!
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        translateLangue()
    }
    private func setupView(){
        clearBtn.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        emailTF.text = keychain.get("TemporaryEmail")
        passwordTF.text = keychain.get("TemporaryPassword")
        rePassworđTF.text = keychain.get("TemporaryPassword")
        checkValidInput()
        registerPresenter = RegisterPresenterImpl(registerVC: self)
    }
    
    func goToForgotPassword() {
        let navigation = NavigationHelper.shared
        navigation.navigateToViewController(from: self, withIdentifier: "ForgotPasswordViewController")
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
        case securePasswordBtn:
            setupSecureButton(passwordTF: passwordTF, button: securePasswordBtn)
        case secureRePasswordBtn:
            setupSecureButton(passwordTF: rePassworđTF, button: secureRePasswordBtn)
        case forgotPasswordBtn:
            goToForgotPassword()
        case signInBtn:
            self.navigationController?.popToRootViewController(animated: true)
        case facebookBtn:
            registerPresenter.loginBySocialNW()
        case googleBtn:
            registerPresenter.loginBySocialNW()
        case registerBtn:
            registerPresenter.register(email: emailTF.text ?? "", password: passwordTF.text ?? "")
        default:
            break
        }
    }
}

extension RegisterViewController {
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
        
        let ReEnterpasswordResult : Bool
        if rePassworđTF.text == passwordTF.text {
            rePasswordErrrorTF.text = "ok"
            ReEnterpasswordResult = true
            handleButton(button: registerBtn,
                         emailResult: emailResult.valid,
                         passwordResult: passwordResult.valid)
        } else {
            rePasswordErrrorTF.text = NSLocalizedString("Password don't match", comment: "")
            ReEnterpasswordResult = false
            handleButton(button: registerBtn,
                         emailResult: emailResult.valid,
                         passwordResult: ReEnterpasswordResult)
        }
        handleInputTF(status: ReEnterpasswordResult,
                      errorView: rePasswordErorrView,
                      errorViewHeight: rePasswordErrorViewHieght,
                      textView: rePasswordTextView)
    }
}
// MARK: - Dịch Thuật
extension RegisterViewController {
    func translateLangue(){
        registerLB.text = NSLocalizedString(registerLB.text ?? "", comment: "")
        passwordLb.text = NSLocalizedString(passwordLb.text ?? "", comment: "")
        repasswordLb.text = NSLocalizedString(repasswordLb.text ?? "", comment: "")
        forgotPasswordBtn.setTitle(NSLocalizedString(forgotPasswordBtn.currentTitle ?? "", comment: ""), for: .normal)
        dotHaveAcountLb.text = NSLocalizedString(dotHaveAcountLb.text ?? "", comment: "")
        signInBtn.setTitle(NSLocalizedString(signInBtn.currentTitle ?? "", comment: ""), for: .normal)
        orContinueWith.text = NSLocalizedString(orContinueWith.text ?? "", comment: "")
        registerBtn.setTitle(NSLocalizedString(registerBtn.currentTitle ?? "", comment: ""), for: .normal)
    }
}
