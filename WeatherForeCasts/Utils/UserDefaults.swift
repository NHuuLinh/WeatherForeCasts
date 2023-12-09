
import Foundation

extension UserDefaults {
    private enum UserDefaultsKeys: String {
        case hasOnboarded
        case hasLogout
    }
    var hasOnboarded : Bool {
        get {
            bool(forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
        set {
            setValue(newValue, forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
    }
    
    private enum ThemeKey: String {
            case selectedTheme
        }
        var selectedTheme: Theme? {
            get {
                if let rawValue = string(forKey: ThemeKey.selectedTheme.rawValue) {
                    return Theme(rawValue: rawValue)
                }
                return nil
            }
            set {
                set(newValue?.rawValue, forKey: ThemeKey.selectedTheme.rawValue)
            }
        }
}


