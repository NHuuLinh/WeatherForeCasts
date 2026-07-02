
import Foundation
import Alamofire
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Combine
import CoreLocation

// Tạo một lớp mới để quản lý việc gọi API
class WeatherAPIManager {
    static let shared = WeatherAPIManager()
    //    var apiKey = "40b3c28ec1264e0f9fe125143242601"
    
    private init() {}
    // lưu apikey trên server tránh update app mỗi lần đổi apikey
    func getWeatherApiKey(completion: @escaping (String) -> Void) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("Constant").observeSingleEvent(of: .value, with: { snapshot in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let apiKey = value?["apiKey"] as? String ?? ""
            completion(apiKey)
            print("apiKey: \(apiKey)")
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    func fetchWeatherData(latitude: Double, longitude: Double, completion: @escaping (WeatherData24h?) -> Void) {
        let apiKey = UserDefaults.standard.string(forKey: "WeatherAPIKey") ?? "40b3c28ec1264e0f9fe125143242601"
        let selectedLanguage = UserDefaults.standard.string(forKey: "AppleLanguages") ?? Locale.current.language.languageCode?.identifier
        let url = Constants.baseUrl
        let parameters: [String: Any] = [
            "key": apiKey,
            "q": "\(latitude),\(longitude)",
            "days": 14,
            "aqi": "yes",
            "lang": selectedLanguage ?? "en"
        ]
        AF.request(url,method: .get, parameters: parameters)
            .validate(statusCode: 200...299)
            .responseDecodable(of: WeatherData24h.self) { data in
                switch data.result {
                case .success(let data):
                    let weatherData = data.self
                    completion(weatherData)
                case .failure(let error):
                    completion(nil)
                    print("\(error)")
                }
            }
    }
}
extension WeatherAPIManager {
    func fetchWeatherData(latitude: Double, longitude: Double) -> AnyPublisher<WeatherData24h, Error> {
        let apiKey = UserDefaults.standard.string(forKey: "WeatherAPIKey") ?? "40b3c28ec1264e0f9fe125143242601"
        let selectedLanguage = UserDefaults.standard.string(forKey: "AppleLanguages")
            ?? Locale.current.language.languageCode?.identifier
            ?? "en"
        let parameters: [String: Any] = [
            "key": apiKey,
            "q": "\(latitude),\(longitude)",
            "days": 14,
            "aqi": "yes",
            "lang": selectedLanguage
        ]
        return Future { promise in
            AF.request(Constants.baseUrl, method: .get, parameters: parameters)
                .validate(statusCode: 200...299)
                .responseDecodable(of: WeatherData24h.self) { response in
                    switch response.result {
                    case .success(let data):
                        promise(.success(data))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }

    func fetchLocation(latitude: Double, longitude: Double) -> AnyPublisher<(WeatherData24h, String), Error> {
        Future<(Double, Double, String), Error> { promise in  // ✅ thêm type rõ ràng
            let location = CLLocation(latitude: latitude, longitude: longitude)
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                let placemark = placemarks?.first
                let province = placemark?.administrativeArea ?? ""
                let country = placemark?.country ?? ""
                let address = "\(province), \(country)"
                promise(.success((latitude, longitude, address)))
            }
        }
        .flatMap { [weak self] (lat, lon, address) -> AnyPublisher<(WeatherData24h, String), Error> in
            guard let self = self else {
                return Fail(error: URLError(.cancelled)).eraseToAnyPublisher()
            }
            return self.fetchWeatherData(latitude: lat, longitude: lon)
                .map { ($0, address) }
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
extension WeatherAPIManager {
    func login(email: String, password: String) -> AnyPublisher<Void,FireBaseError> {
        Future { promise in
            Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
                if let error = error {
                    let nsError = error as NSError
                    print("🔴 Error code: \(nsError.code)")
                    print("🔴 Error domain: \(nsError.domain)")
                    print("🔴 Error userInfo: \(nsError.userInfo)")
                    let code = AuthErrorCode.Code(rawValue: error._code)
                    switch code {
                    case .userDisabled:
                        promise(.failure(.userDisabled))
                    case .wrongPassword:
                        promise(.failure(.wrongPassword))
                    case .userNotFound:
                        promise(.failure(.userNotFound))
                    case .internalError:
                        print("🔴 Error internalError: \(String(describing: code))")
                        
                        promise(.failure(.invalidCredential))
                    default:
                        print("Error login default: \(error.localizedDescription)")
                        promise(.failure(.unknownError(message: error.localizedDescription)))
                    }
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func isEmailVerified()-> AnyPublisher<Bool,FireBaseError>{
        Future { promise in
            guard let user = Auth.auth().currentUser else {
                promise(.failure(.unknownError(message: "No current user")))
                return
            }
            if user.isEmailVerified {
                // Cho phép đăng nhập
                // Điều hành đến màn hình chính hoặc thực hiện các bước khác sau khi đăng nhập
                promise(.success(true))
            } else {
                // Hiển thị thông báo cho người dùng rằng họ cần xác thực email trước khi đăng nhập
                // Gửi lại email xác thực (nếu cần)
                promise(.failure(.userNotFound))
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    func register(email: String, password: String) -> AnyPublisher<Void, FireBaseError> {
        Future { promise in
            Auth.auth().createUser(withEmail: email, password: password) { _, error in
                if let error = error {
                    let code = AuthErrorCode.Code(rawValue: error._code)
                    switch code {
                    case .emailAlreadyInUse: promise(.failure(.emailAlreadyInUse))
                    case .invalidEmail:      promise(.failure(.invalidEmail))
                    default:                 promise(.failure(.unknownError(message: error.localizedDescription)))
                    }
                    return
                }
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
    func sendEmailVerification() -> AnyPublisher<Void, FireBaseError> {
        Future { promise in
            guard let user = Auth.auth().currentUser else {
                promise(.failure(.unknownError(message: "No current user")))
                return
            }
            user.sendEmailVerification { error in
                if let error = error {
                    promise(.failure(.sendEmailVerification(message: error.localizedDescription)))
                    return
                }
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
    func signOut() -> AnyPublisher<Void, FireBaseError> {
        Future { promise in
            do {
                try Auth.auth().signOut()
                promise(.success(()))
            } catch {
                promise(.failure(.unknownError(message: error.localizedDescription)))
            }
        }
        .eraseToAnyPublisher()
    }
    
    //Quên mật khẩu
    func forgetPassword(email: String) -> AnyPublisher<(),FireBaseError>{
        Future{ promise in
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    let code = AuthErrorCode.Code(rawValue: (error as NSError).code)
                    switch code {
                    case .userNotFound:
                        promise(.failure(.userNotFound))
                    default:
                        promise(.failure(.forgetPWError))
                    }
                } else {
                    promise(.success(()))
                }
            }
        } .eraseToAnyPublisher()
    }
    
}

// MARK: - ProfileVC
extension WeatherAPIManager {
    
    func loadDataFromFirebase() -> AnyPublisher<UserProfile,FireBaseError> {
        Future{ promise in
            guard let currentUserID = Auth.auth().currentUser?.uid else {
                promise(.failure(.unknownError(message: "No current user")))
                return
            }
            let userRef = Database.database().reference().child("users").child(currentUserID)
            userRef.observeSingleEvent(of: .value) { (snapshot , error)  in
                if let userData = snapshot.value as? [String: Any] {
                    let userName = userData["name"] as? String
                    let dateOfBirth = userData["dateOfBirth"] as? String
                    let phoneNumber = userData["phoneNumber"] as? String
                    // Lấy giá trị giới tính từ userData và gán cho userGender
                    let genderString = userData["gender"] as? String
                    // Load image URL from Firebase Realtime Database
                    let imageURLString = userData["avatar"] as? String
                    let userProfile = UserProfile(id: currentUserID, name: userName, gender: genderString, dateOfBirth: dateOfBirth, email: "", phoneNumber: phoneNumber, avatar: imageURLString, favorited: nil, searchHistory: nil)
                    promise(.success(userProfile))
                } else {
                    promise(.failure(.unknownError(message: "Can't get user info")))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateDataToFireBase(data: UserProfile) -> AnyPublisher<(),FireBaseError> {
        Future { promise in
            guard let currentUser = Auth.auth().currentUser?.uid else {
                promise(.failure(.unknownError(message: "No current user")))
                return }
            let databaseRef = Database.database().reference()
            
            let userRef = databaseRef.child("users").child(currentUser)
            
            userRef.child("name").setValue(data.name)
            userRef.child("dateOfBirth").setValue(data.dateOfBirth)
            userRef.child("phoneNumber").setValue(data.phoneNumber)
            userRef.child("gender").setValue(data.gender)
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
    
    func uploadAvatar(imageData: Data) -> AnyPublisher<String, FireBaseError> {
        Future { promise in
            guard let uid = Auth.auth().currentUser?.uid else {
                promise(.failure(.unknownError(message: "No current user")))
                return
            }
            let storageRef = Storage.storage().reference()
                .child("user_images/\(uid)/user_image.jpg")
            storageRef.putData(imageData) { _, error in
                if let error = error {
                    promise(.failure(.unknownError(message: error.localizedDescription)))
                    return
                }
                storageRef.downloadURL { url, error in
                    if let error = error {
                        promise(.failure(.unknownError(message: error.localizedDescription)))
                        return
                    }
                    guard let downloadURL = url else {
                        promise(.failure(.unknownError(message: "No download URL")))
                        return
                    }
                    let avatarRef = Database.database().reference()
                        .child("users").child(uid).child("avatar")
                    avatarRef.setValue(downloadURL.absoluteString)
                    promise(.success(downloadURL.absoluteString))
                }
            }
        }
        .eraseToAnyPublisher()
    }

}


