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
            return cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
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
extension UITableViewCell {
    func extractImageNameCell(url: String) -> String {
        let cleanedURL = url
            .replacingOccurrences(of: "//cdn.weatherapi.com/weather/64x64/", with: "")
            .replacingOccurrences(of: ".png", with: "")
            .replacingOccurrences(of: "/", with: "")
        return cleanedURL
    }
}
