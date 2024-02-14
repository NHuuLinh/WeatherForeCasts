
import Foundation
import Alamofire
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

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
            print("\(apiKey)")
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    func fetchWeatherData(latitude: Double, longitude: Double, completion: @escaping (WeatherData24h?) -> Void) {
        let apiKey = UserDefaults.standard.string(forKey: "WeatherAPIKey") ?? "40b3c28ec1264e0f9fe125143242601"
        let selectedLanguage = UserDefaults.standard.string(forKey: "AppleLanguages") ?? Locale.current.languageCode
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

