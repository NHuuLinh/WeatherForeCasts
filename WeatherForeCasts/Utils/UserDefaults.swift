
import Foundation

extension UserDefaults {
    private enum UserDefaultsKeys: String {
        case hasOnboarded
        case hasLogout
        case didOnMain
        case didGetData

    }
    var hasOnboarded : Bool {
        get {
            bool(forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
        set {
            setValue(newValue, forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
    }
    var didOnMain: Bool {
        get {
            bool(forKey: UserDefaultsKeys.didOnMain.rawValue)
        }
        set {
            setValue(newValue, forKey: UserDefaultsKeys.didOnMain.rawValue)
        }
    }
    var didGetData: Bool {
        get {
            bool(forKey: UserDefaultsKeys.didGetData.rawValue)
        }
        set {
            setValue(newValue, forKey: UserDefaultsKeys.didGetData.rawValue)
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


