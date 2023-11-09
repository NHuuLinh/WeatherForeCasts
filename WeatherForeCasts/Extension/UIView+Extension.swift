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
extension UIViewController {
    func extractImageNameVC(url: String) -> String {
        let cleanedURL = url
            .replacingOccurrences(of: "//cdn.weatherapi.com/weather/64x64/", with: "")
            .replacingOccurrences(of: ".png", with: "")
            .replacingOccurrences(of: "/", with: "")
        return cleanedURL
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
extension UICollectionViewCell {
    func extractImageNameCollect(url: String) -> String {
        let cleanedURL = url
            .replacingOccurrences(of: "//cdn.weatherapi.com/weather/64x64/", with: "")
            .replacingOccurrences(of: ".png", with: "")
            .replacingOccurrences(of: "/", with: "")
        return cleanedURL
    }
}
extension UIViewController {
    func airQlyData(numb: Int) -> String {
        switch numb {
        case 1 :
            return "(Good)"
        case 2 :
            return "(Moderate)"
        case 3 :
            return "(Unhealthy for sensitive group)"
        case 4 :
            return "(Unhealthy)"
        case 5 :
            return "(Very Unhealthy)"
        case 6 :
            return "(Hazardous)"
        default :
            return "(Unknow)"
        }
    }
}
extension UITableViewCell {
    func airQlyDataCell(numb: Int) -> String {
        switch numb {
        case 1 :
            return "(Good)"
        case 2 :
            return "(Moderate)"
        case 3 :
            return "(Unhealthy for sensitive group)"
        case 4 :
            return "(Unhealthy)"
        case 5 :
            return "(Very Unhealthy)"
        case 6 :
            return "(Hazardous)"
        default :
            return "(Unknow)"
        }
    }
}
extension UITableViewCell {
    func airQlyLevel(width: Int) -> CGFloat {
        let level :CGFloat = 50.0
        switch width {
        case 1 :
            return level
        case 2 :
            return level*2
        case 3 :
            return level*3
        case 4 :
            return level*4
        case 5 :
            return level*5
        case 6 :
            return level*6
        default :
            return 0.0
        }
    }
}
//extension UITableViewCell {
//    func willRain(()->String){
//        let
//    }
//}
extension UITableViewCell {
    func airQlyColor(numb: Int) -> UIColor {
        switch numb {
        case 1 :
            return .green
        case 2 :
            return .yellow
        case 3 :
            return .orange
        case 4 :
            return .red
        case 5 :
            return .brown
        case 6 :
            return .purple
        default :
            return .white
        }
    }
}

extension UIViewController {
    func gotoHomeViewController1() {
        if let uwWindow = (UIApplication.shared.delegate as? AppDelegate)?.window {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
            uwWindow.rootViewController = mainVC
            uwWindow.makeKeyAndVisible()
        } else {
            print("LỖI")
        }
    }
}

