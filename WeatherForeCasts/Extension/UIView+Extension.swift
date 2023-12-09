//
//  UIView+Extension.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 22/10/2023.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadius : CGFloat {
        get {
            return self.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
   @IBInspectable var borderColor: UIColor {
       get {
           if let color = layer.borderColor {
               return UIColor(cgColor: color)
           } else {
               return UIColor.clear
           }
       }
       set {
           layer.borderColor = newValue.cgColor
       }
   }

   @IBInspectable var borderWidth: CGFloat {
       get {
           return layer.borderWidth
       }
       set {
           layer.borderWidth = newValue
       }
   }
}
extension UIView {
    @IBInspectable var bottomBorderColor: UIColor {
        set {
            addBottomBorderWithColor(color: newValue, width: bottomBorderWidth)
        }
        get {
            return UIColor.clear
        }
    }

    @IBInspectable var bottomBorderWidth: CGFloat {
        set {
            addBottomBorderWithColor(color: bottomBorderColor, width: newValue)
        }
        get {
            return 0.0
        }
    }
    private func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        bottomBorder.backgroundColor = color.cgColor
        self.layer.addSublayer(bottomBorder)
    }
}
extension UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: identifier) as! Self
    }
}


//extension UIViewController {
//     func gotoHomeViewController1() {
//        if let uwWindow = (UIApplication.shared.delegate as? AppDelegate)?.window {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let mainVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
//            uwWindow.rootViewController = mainVC
//            uwWindow.makeKeyAndVisible()
//        } else {
//            print("LỖI")
//        }
//    }
//}

