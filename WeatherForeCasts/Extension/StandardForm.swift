import Foundation
import UIKit

extension UIViewController {
    func handleInputTF(status: Bool,errorView: UIView, errorViewHeight: NSLayoutConstraint, textView: UIView) {
        
        if status {
            errorViewHeight.constant = 0
            errorView.isHidden = status
            errorView.layoutIfNeeded()
            textView.backgroundColor = Constants.defaultTextFieldBackgroundColor
        } else {
            errorViewHeight.constant = 21
            errorView.isHidden = status
            errorView.layoutIfNeeded()
            textView.backgroundColor = Constants.errorTextFieldBackgroundColor
        }
    }
    
    func setupSecureButton(textFied: UITextField, button: UIButton){
        
        textFied.isSecureTextEntry.toggle()
        let showImage = UIImage(systemName: "eye.circle")
        let hideImage = UIImage(systemName: "eye.slash.circle")
        let buttonImage = textFied.isSecureTextEntry ? hideImage : showImage
        button.setImage(buttonImage, for: .normal)
    }
    
    func handleButton(button: UIButton , emailResult: Bool, passwordResult: Bool ){
        if emailResult && passwordResult{
            
            button.isEnabled = true
            button.layer.opacity = 1
        } else {
            button.isEnabled = false
            button.layer.opacity = 0.7
        }
    }

}
extension UIImageView {
  func setImageColor(color: UIColor) {
      
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}

