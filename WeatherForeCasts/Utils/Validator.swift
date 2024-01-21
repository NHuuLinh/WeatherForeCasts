import Foundation

protocol Validator {
    func isValid() -> Bool
}
private extension String {
    func isMatching(regex: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let res = regex.matches(in: self, options: NSRegularExpression.MatchingOptions.anchored,
                                    range: NSRange(location: 0, length: self.count))
            return res.count > 0
        } catch {
            return false
        }
    }
}

class EmailValidator: Validator {
    static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    var email: String!

    init(email: String) {
        self.email = email
    }

    func isValid() -> Bool {
        return email.isMatching(regex: EmailValidator.emailRegex)
    }
}

class PasswordValidator: Validator {
    static let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])[A-Za-z0-9@$!%*?&]{6,}$"

    var password: String!

    init(password: String) {
        self.password = password
    }

    func isValid() -> Bool {
        return password.isMatching(regex: PasswordValidator.passwordRegex)
    }
}
class PasswordValidater {
//    static func passwordValid(password: String) -> Bool {
//            switch password.count {
//            case 0:
//                return false
//            case 1...5:
//                return false
//            case 6...:
//                return true
//            default:
//                return false
//            }
//        }
//
//    static func passwordValidText(password: String) -> String {
//            switch password.count {
//            case 0:
//                return "Password can't be empty"
//            case 1...5:
//                return "Password must be more than 6 digits"
//            case 6...:
//                return "ok"
//            default:
//                return "Invalid input"
//            }
//        }
    static func passwordValidator(password: String) -> (message: String, valid: Bool) {
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
    }

class EmailValidater {
    static func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
    static func emailValidator(_ email: String) -> (message: String, valid: Bool) {
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


