import Foundation
import UIKit

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




