import UIKit
import FirebaseAuth
import FirebaseCore

class NoInternetAccessViewController: UIViewController {
    @IBOutlet weak var noInternetLb: UILabel!
    @IBOutlet weak var InternetMessageLb: UILabel!
    @IBOutlet weak var retryBtn: UIButton!
    private let appCoordinator = AppCoordinator.shared

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        translateLangue()
    }
    
    @IBAction func retryBtnTapped(_ sender: UIButton) {
        
        if NetworkMonitor.shared.isReachable {
            print("internet connected")
            //Kiểm tra xem người dùng đã hoàn thành Onboarding Screen và check đăng nhập
            if UserDefaults.standard.hasOnboarded {
                if Auth.auth().currentUser != nil {
                    appCoordinator.routeToScene(.main)
                    print("goToMain")
                } else {
                    appCoordinator.routeToScene(.login)
                    print("goToLogin")
                }
            } else {
                appCoordinator.routeToScene(.onboard)
                print("goToOnboard")
            }
        } else {
            showAlert(title: NSLocalizedString("No internet connection", comment: ""), message: NSLocalizedString("Please check internet connection and retry again", comment: ""))
            print("no internet")
            return
        }
    }
}
extension NoInternetAccessViewController {
    func translateLangue(){
        noInternetLb.text = NSLocalizedString("No internet connection", comment: "")
        InternetMessageLb.text = NSLocalizedString("Please check internet connection and retry again", comment: "")
        retryBtn.setTitle(NSLocalizedString("Retry", comment: ""), for: .normal)
    }
}

