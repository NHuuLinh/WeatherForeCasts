import UIKit
import Firebase
import FirebaseAuth
import KeychainSwift
import Combine

enum ForgotPasswordFormField {
    case email
}
class ForgotPasswordViewController: BaseViewController, CheckValid {
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
    private var cancellables = Set<AnyCancellable>()
    private let viewModel = ForgotPasswordViewModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        translateLangue()
        handleObser()
    }
    func setupView() {
        clearEmailBtn.isHidden = true
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
            viewModel.loginBySocialNW()
        case googleBtn:
            viewModel.loginBySocialNW()
        case sendRequsetBtn:
            viewModel.sendRequestToFirebase(email: emailTF.text ?? "")
        default:
            break
        }
    }
    
    func handleObser(){
        
        viewModel.$errorMsg
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let error = error, let self = self else {
                    return
                }
                self.showAlert(title: error.title, message: error.message)
            }
            .store(in: &cancellables)
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.showLoading(isShow: isLoading)
            }
            .store(in: &cancellables)
        viewModel.$isSuccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSuccess in
                guard let self = self else {return}
                if isSuccess {
                    self.navigationController?.popToRootViewController(animated: true)
                    self.onSuccessResetPassword?(self.emailTF.text ?? "")
                }
            }
            .store(in: &cancellables)
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

