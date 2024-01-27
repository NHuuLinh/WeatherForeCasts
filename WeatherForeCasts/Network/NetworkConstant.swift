
import Foundation
import Alamofire

// Tạo một lớp mới để quản lý việc gọi API
class WeatherAPIManager {
    static let shared = WeatherAPIManager()
    
    private init() {}
    
    func fetchWeatherData(latitude: Double, longitude: Double, completion: @escaping (WeatherData24h?) -> Void) {
        let selectedLanguage = UserDefaults.standard.string(forKey: "AppleLanguages") ?? Locale.current.languageCode
        let url = Constants.baseUrl
        let parameters: [String: Any] = [
            "key": Constants.key,
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

