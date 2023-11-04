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

