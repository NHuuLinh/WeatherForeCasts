//
//  UIView+Extension.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 22/10/2023.
//

import Foundation
//import UIKit
//extension UIView {
//    @IBInspectable var cornerRadius : CGFloat {
//        get {
//            return cornerRadius
//        }
//        set {
//            self.layer.cornerRadius = newValue
//        }
//    }
//}
import UIKit

extension UIViewController {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: identifier) as! Self
    }
}
