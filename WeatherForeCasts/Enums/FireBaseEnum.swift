//
//  FireBaseEnum.swift
//  WeatherForeCasts
//
//  Created by Huu Linh Nguyen on 24/6/26.
//

import Foundation

enum LoginError: Error {
    case userDisabled
    case wrongPassword
    case userNotFound
    case emailNotVerified
    case unknownError(message: String)
    case loginBySocialNW
    
    var title: String {
        return "Warning"
    }
    
    var message: String {
        switch self {
        case .userDisabled:
            return "Account is disabled"
        case .wrongPassword:
            return "Wrong password"
        case .userNotFound:
            return "Email not found"
        case .emailNotVerified:
            return "Vui lòng xác thực email trước khi đăng nhập."
        case .unknownError(let msg):
            return msg
        case .loginBySocialNW:
            return NSLocalizedString("The feature is under development, please try again later.", comment: "")
        }
    }
}
