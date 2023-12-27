import UIKit

// Set tag for buttons


class SetingViewController: UIViewController {
    @IBOutlet weak var darkBtn: UIButton!
    @IBOutlet weak var lightBtn: UIButton!
    @IBOutlet weak var systemBtn: UIButton!
    @IBOutlet weak var engBtn: UIButton!
    @IBOutlet weak var vnBtn: UIButton!
    
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var selectThemeTitle: UILabel!
    @IBOutlet weak var slectLanguage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        themeBtnColor()
        let selectedLanguage = UserDefaults.standard.string(forKey: "AppleLanguages") ?? Locale.current.languageCode
        languageBtnColor(selectedLanguage:selectedLanguage)
        translateLangue()
        
    }

    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func handleThemeBtn(_ sender: UIButton) {
        switch sender {
        case darkBtn:
            ThemeManager.shared.applyTheme(.dark, to: self.view.window)
            print("darkBtn")
        case lightBtn:
            ThemeManager.shared.applyTheme(.light, to: self.view.window)
            print("lightBtn")
        case systemBtn:
            ThemeManager.shared.applyTheme(.system, to: self.view.window)
            print("systemBtn")
        default:
            break
        }
        themeBtnColor()
    }
    @IBAction func langBtnHandle(_ sender: UIButton) {

        var selectedLanguage: String
        switch sender {
        case engBtn:
            selectedLanguage = "en"
            print("engBtn")
        case vnBtn:
            selectedLanguage = "vi"
            print("vnBtn")
        default:
            return
        }
        
        languageBtnColor(selectedLanguage:selectedLanguage)

        UserDefaults.standard.set([selectedLanguage], forKey: "AppleLanguages")
        print("selectedLanguage: \(selectedLanguage)")
        UserDefaults.standard.synchronize()

        let aleartTitle = NSLocalizedString("Warning", comment: "")
        let aleartMessage = NSLocalizedString("Please reset app to apllied new language", comment: "")
        let alert = UIAlertController(title: aleartTitle, message: aleartMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("Restart now", comment: ""), style: .destructive) { name in
//            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            // Khởi động lại ứng dụng để áp dụng ngay lập tức
            exit(EXIT_SUCCESS)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Restart later", comment: ""), style: .cancel) {_ in
            print("cancel")
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)

        self.present(alert, animated: true)

    }
        func languageBtnColor(selectedLanguage:String?){
        engBtn.backgroundColor = (selectedLanguage == "en") ? .yellow : .white
        vnBtn.backgroundColor = (selectedLanguage == "vi") ? .yellow : .white
    }
    func themeBtnColor(){
        let theme = ThemeManager.shared.currentTheme
        darkBtn.backgroundColor = theme == .dark ? .yellow : .white
        lightBtn.backgroundColor = theme == .light ? .yellow : .white
        systemBtn.backgroundColor = theme == .system ? .yellow : .white
    }
    func translateLangue(){
        mainTitle.text = NSLocalizedString(mainTitle.text ?? "", comment: "")
        selectThemeTitle.text = NSLocalizedString(selectThemeTitle.text ?? "", comment: "")
        slectLanguage.text = NSLocalizedString(slectLanguage.text ?? "", comment: "")
        darkBtn.setTitle(NSLocalizedString(darkBtn.currentTitle ?? "", comment: ""), for: .normal)
        lightBtn.setTitle(NSLocalizedString(lightBtn.currentTitle ?? "", comment: ""), for: .normal)
        systemBtn.setTitle(NSLocalizedString(systemBtn.currentTitle ?? "", comment: ""), for: .normal)
        engBtn.setTitle(NSLocalizedString(engBtn.currentTitle ?? "", comment: ""), for: .normal)
        vnBtn.setTitle(NSLocalizedString(vnBtn.currentTitle ?? "", comment: ""), for: .normal)
    }
    
}
