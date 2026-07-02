//
//  FireBaseEnum.swift
//  WeatherForeCasts
//
//  Created by Huu Linh Nguyen on 24/6/26.
//

import Foundation

enum FireBaseError: Error {
    case userDisabled
    case wrongPassword
    case userNotFound
    case emailNotVerified
    case unknownError(message: String?)
    case loginBySocialNW
    case emailAlreadyInUse
    case invalidEmail
    case sendEmailVerification(message: String?)
    case registerSuccess
    case invalidCredential
    case forgetPWOk
    case forgetPWError

    var title: String {
        switch self {
        case .userDisabled:
            return "Tài khoản bị khóa"
        case .wrongPassword:
            return "Sai mật khẩu"
        case .userNotFound:
            return "Không tìm thấy tài khoản"
        case .emailNotVerified:
            return "Email chưa xác thực"
        case .unknownError:
            return "Lỗi không xác định"
        case .loginBySocialNW:
            return "The feature is under development"
        case .emailAlreadyInUse:
            return "Email đã tồn tại"
        case .invalidEmail:
            return "Email không hợp lệ"
        case .sendEmailVerification:
            return "Lỗi gửi email"
        case .registerSuccess:
            return "Success"
        case .invalidCredential:
            return "Lỗi"
        case .forgetPWError:
            return NSLocalizedString("Error", comment: "")
        case .forgetPWOk:
            return NSLocalizedString("Success", comment: "")
        }
    }

    var message: String {
        switch self {
        case .userDisabled:
            return "Tài khoản của bạn đã bị vô hiệu hóa."
        case .wrongPassword:
            return "Mật khẩu không đúng."
        case .userNotFound:
            return "Email chưa được đăng ký."
        case .emailNotVerified:
            return "Vui lòng xác thực email trước khi đăng nhập."
        case .unknownError(let msg):
            return msg ?? "Đã xảy ra lỗi không xác định."
        case .loginBySocialNW:
            return NSLocalizedString("The feature is under development, please try again later.", comment: "")
        case .emailAlreadyInUse:
            return "Email đã tồn tại, vui lòng dùng email khác."
        case .invalidEmail:
            return "Email không hợp lệ, vui lòng kiểm tra lại."
        case .sendEmailVerification(let msg):
            return "Lỗi khi gửi email xác thực: \(msg ?? "Unknown error")"
        case .registerSuccess:
            return "Đăng ký thành công. Vui lòng kiểm tra email để xác thực tài khoản."
        case .invalidCredential:
            return "Xin vui lòng kiểm tra lại email và mật khẩu đăng nhập"
        case .forgetPWError:
            return NSLocalizedString("Sever busy please try again later", comment: "")
        case .forgetPWOk:
            return NSLocalizedString("New password has been sent to your email. Please check your email and log in again with your new password", comment: "")
        }
    }
}

