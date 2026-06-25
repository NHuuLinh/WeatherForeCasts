import Foundation
import UIKit

protocol checkValid {
    func passwordValidator(password: String) -> (message: String, valid: Bool)
    func emailValidator(_ email: String) -> (message: String, valid: Bool)
    func isValidEmail(_ email: String) -> Bool
}
extension checkValid {
    // kiểm tra thông tin mật khẩu  User nhập , trả về message để gán vào eror text, giá trị bool để gán vào hàm xử lí UI phía dưới
    func passwordValidator(password: String) -> (message: String, valid: Bool) {
        // tạo biến để dịch thuật
        let emtyPassword = NSLocalizedString("Password can't be empty.", comment: "")
        let wrongFormatMessage = NSLocalizedString("Password must be more than 6 digits.", comment: "")
        
        switch password.count {
        case 0:
            return (emtyPassword, false)
        case 1...5:
            return (wrongFormatMessage, false)
        case 6...:
            return ("ok", true)
        default:
            return ("Invalid input.", false)
        }
    }
    // hàm check định dạng email
    func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
    // kiểm tra thông tin email  User nhập , trả về message để gán vào eror text, giá trị bool để gán vào hàm xử lí UI phía dưới
    
    func emailValidator(_ email: String) -> (message: String, valid: Bool) {
        let emptyMessage = NSLocalizedString("Email can't be empty.", comment: "")
        let wrongFormatMessage = NSLocalizedString("The email is in the wrong format.", comment: "")
        if email.isEmpty {
            return (emptyMessage, false)
        } else if !isValidEmail(email) {
            return (wrongFormatMessage, false)
        } else {
            return ("ok", true)
        }
    }
}
extension UIViewController {
    // hàm xử lí check valid khi người dùng nhập email,password
    // status là kết quả của các hàm check valid User nhập phía trên
    func handleInputTF(status: Bool,errorView: UIView, errorViewHeight: NSLayoutConstraint, textView: UIView) {
        if status {
            // nếu true, sẽ không hiển thị lỗi, màu mặc định check ở file Constants
            errorViewHeight.constant = 0
            errorView.isHidden = status
            errorView.layoutIfNeeded()
            textView.backgroundColor = Constants.defaultTextFieldBackgroundColor
        } else {
            // nếu false, sẽ hiển thị lỗi, màu mặc định check ở file Constants
            errorViewHeight.constant = 21
            errorView.isHidden = status
            errorView.layoutIfNeeded()
            textView.backgroundColor = Constants.errorTextFieldBackgroundColor
        }
    }
    // hàm để ẩn hiện mật khẩu
    func setupSecureButton(passwordTF: UITextField, button: UIButton){
        // tạo toggle để lấy true false
        passwordTF.isSecureTextEntry.toggle()
        let showImage = UIImage(systemName: "eye.circle")
        let hideImage = UIImage(systemName: "eye.slash.circle")
        let buttonImage = passwordTF.isSecureTextEntry ? hideImage : showImage
        button.setImage(buttonImage, for: .normal)
    }
    // hàm xử lí nút login,register,sendrequest, nếu email và mật khẩu check valid ok, nút sẽ có thể nhấn được
    func handleButton(button: UIButton , emailResult: Bool, passwordResult: Bool ){
        if emailResult && passwordResult{
            button.isEnabled = true
            button.layer.opacity = 1
        } else {
            // nếu 1 trong 2 điều kiện không đạt, nút sẽ bị vô hiệu háo và làm mở
            button.isEnabled = false
            button.layer.opacity = 0.7
        }
    }
    
}
// extension để đổi màu nhưng image không phải màu hệ thống, ví dụ muốn đổi một icon từ màu đen sang trắng
extension UIImageView {
    func setImageColor(color: UIColor) {

        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}

