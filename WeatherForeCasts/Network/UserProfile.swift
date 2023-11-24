import Foundation
import UIKit

struct UserProfile: Codable {
    var id: String?
    var name: String?
    var gender: String?
    var dateOfBirth: String?
    var email: String
    var phoneNumber: String?
    var avatar: String?
    var favorited: [String]?
    var searchHistory: [String]?
}
