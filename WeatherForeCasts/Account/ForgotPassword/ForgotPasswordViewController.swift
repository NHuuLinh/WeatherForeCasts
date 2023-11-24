

import UIKit
import Firebase
import FirebaseAuth

enum ForgotPasswordFormField {
    case email
}
class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var emailWarningLb: UITextField!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var emailWarningView: UIView!
    @IBOutlet weak var clearEmailBtn: UIButton!
    @IBOutlet weak var sendRequsetBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    var onSuccessResetPassword: ((String) -> Void)?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    func setupView() {
        emailWarningView.isHidden = true
        clearEmailBtn.isHidden = true
        sendRequsetBtn.isEnabled = false
        sendRequsetBtn.backgroundColor = .gray
    }
    func updateEmailWarningView(isValid: Bool) {
        emailWarningView.isHidden = isValid
        sendRequsetBtn.isEnabled = isValid
        sendRequsetBtn.backgroundColor = isValid ? .white : .gray
    }
    @IBAction func editEmail(_ textField: UITextField) {
        clearEmailBtn.isHidden = false
        let email = textField.text ?? ""
        let isValid = validateForm(email: email)
    }
    
    @IBAction func handleBtn(_ sender: UIButton) {
        switch sender {
        case clearEmailBtn:
            emailTF.text = ""
        case signUpBtn:
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
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("\(error)")
                self.showAlert(title: "error", message: "Sever busy please try again later")
            } else {
                self.showAlert(title: "Success", message: "New password has been sent to your email. Please check your email and log in again with your new password"){
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
    private func validateForm(email: String) -> Bool {
        var isValid = true
        updateEmailWarningView(isValid: true)
        if email.isEmpty {
            isValid = false
            updateEmailWarningView(isValid: false)
            forgotPasswordValidateFailure(message: "Please enter your email")
        } else {
            let emailValidator = EmailValidator(email: email)
            let isEmailValid = emailValidator.isValid()
            if !isEmailValid {
                isValid = false
                forgotPasswordValidateFailure(message: "The email is in the wrong format.")
                updateEmailWarningView(isValid: false)
            }
        }
        return isValid
    }
    func forgotPasswordValidateFailure(message: String?) {
        emailWarningLb.text = message
    }
}

