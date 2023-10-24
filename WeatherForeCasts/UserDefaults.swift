//
//  UserDefaults.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 21/10/2023.
//

import Foundation
//class UserDefaults {
//    static var shared = UserDefaults()
//}
extension UserDefaults {
    private enum UserDefaultsKeys: String {
        case hasOnboarded
    }
    var hasOnboarded : Bool {
        get {
            bool(forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
        set {
            setValue(newValue, forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
    }
}

