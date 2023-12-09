

import UIKit

class SetingViewController: UIViewController {
    @IBOutlet weak var darkBtn: UIButton!
    @IBOutlet weak var lightBtn: UIButton!
    @IBOutlet weak var systemBtn: UIButton!
    @IBOutlet weak var engBtn: UIButton!
    @IBOutlet weak var vnBtn: UIButton!
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        themeBtnColor()
        let selectedLanguage = UserDefaults.standard.string(forKey: "AppleLanguages") ?? Locale.current.languageCode
        languageBtnColor(selectedLanguage:selectedLanguage)
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
        // Lưu ngôn ngữ đã chọn
//        UserDefaults.standard.set(selectedLanguage, forKey: "AppleLanguages")
        UserDefaults.standard.set([selectedLanguage], forKey: "AppleLanguages")
        print("selectedLanguage: \(selectedLanguage)")

        UserDefaults.standard.synchronize()
        showAlert(title: "Warning", message: "Please reset app to apllied new language")
        // Khởi động lại ứng dụng để áp dụng ngay lập tức
//        exit(EXIT_SUCCESS)
    }
        func languageBtnColor(selectedLanguage:String?){
        engBtn.backgroundColor = (selectedLanguage == "en") ? .yellow : .white
        vnBtn.backgroundColor = (selectedLanguage == "vi") ? .yellow : .white
    }
    //123
    func themeBtnColor(){
        let theme = ThemeManager.shared.currentTheme
        darkBtn.backgroundColor = theme == .dark ? .yellow : .white
        lightBtn.backgroundColor = theme == .light ? .yellow : .white
        systemBtn.backgroundColor = theme == .system ? .yellow : .white
    }
    
}
