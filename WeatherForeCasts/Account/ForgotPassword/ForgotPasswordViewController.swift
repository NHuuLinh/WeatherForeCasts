import UIKit
import Firebase
import FirebaseAuth
import KeychainSwift

enum ForgotPasswordFormField {
    case email
}
class ForgotPasswordViewController: UIViewController,checkValid {
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var emailErrorView: UIView!
    @IBOutlet weak var emailerrorTF: UITextField!
    @IBOutlet weak var emailTextView: UIView!
    @IBOutlet weak var errorViewHieght: NSLayoutConstraint!
    
    @IBOutlet weak var clearEmailBtn: UIButton!
    @IBOutlet weak var sendRequsetBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    
    @IBOutlet weak var forogtPasswordLb: UILabel!
    @IBOutlet weak var alreadyHaveAcountLb: UILabel!
    @IBOutlet weak var orContinueWithLb: UILabel!
    var onSuccessResetPassword: ((String) -> Void)?
    let keychain = KeychainSwift()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        translateLangue()
    }
    func setupView() {
        clearEmailBtn.isHidden = true
        navigationController?.isNavigationBarHidden = true
        emailTF.text = keychain.get("TemporaryEmail")
        checkValidInput()
    }
    @IBAction func editEmail(_ textField: UITextField) {
        clearEmailBtn.isHidden = textField.text?.isEmpty ?? true
        checkValidInput()
    }
    
    @IBAction func handleBtn(_ sender: UIButton) {
        switch sender {
        case clearEmailBtn:
            emailTF.text = ""
        case signInBtn:
            self.navigationController?.popToRootViewController(animated: true)
        case facebookBtn:
            loginBySocialNW()
        case googleBtn:
            loginBySocialNW()
        case sendRequsetBtn:
            sendRequestToFirebase()
        default:
            break
        }
    }
    func sendRequestToFirebase(){
        let email = emailTF.text ?? ""
        self.showLoading(isShow: true)
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            self.showLoading(isShow: false)
            if let error = error {
                print("\(error)")
                let title = NSLocalizedString("Error", comment: "")
                let message = NSLocalizedString("Sever busy please try again later", comment: "")
                self.showAlert(title: title, message: message)
            } else {
                let title = NSLocalizedString("Success", comment: "")
                let message = NSLocalizedString("New password has been sent to your email. Please check your email and log in again with your new password", comment: "")
                self.showAlert(title: title, message: message){
                    self.navigationController?.popToRootViewController(animated: true)
                    self.onSuccessResetPassword?(email)
                }
            }
        }
    }
    func loginBySocialNW(){
        self.showAlert(title: "The feature is under development", message: "The feature is under development, please try again later.")
    }
}
//MARK: - Validate Form
extension ForgotPasswordViewController {
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
        handleButton(button: sendRequsetBtn,
                                  emailResult: emailResult.valid,
                                  passwordResult: emailResult.valid)
    }
}
// MARK: - Dịch Thuật
extension ForgotPasswordViewController {
    func translateLangue(){
        forogtPasswordLb.text = NSLocalizedString("Forgot Password", comment: "")
        alreadyHaveAcountLb.text = NSLocalizedString("Already have an account ?", comment: "")
        signInBtn.setTitle(NSLocalizedString(signInBtn.currentTitle ?? "", comment: ""), for: .normal)
        orContinueWithLb.text = NSLocalizedString("or continue with", comment: "")
        sendRequsetBtn.setTitle(NSLocalizedString("Send request", comment: ""), for: .normal)
    }
}

