
import Foundation
import Alamofire

// Tạo một lớp mới để quản lý việc gọi API
class WeatherAPIManager1 {
    static let shared = WeatherAPIManager1()
    

    private init() {}
    
    func fetchWeatherData(latitude: Double, longitude: Double, completion: @escaping (WeatherData24h?) -> Void) {
        let selectedLanguage = UserDefaults.standard.string(forKey: "AppleLanguages") ?? Locale.current.languageCode
        print("selectedLanguage: \(selectedLanguage)")
        let url = Constants.baseUrl
        let parameters: [String: Any] = [
            "key": Constants.key,
            "q": "\(latitude),\(longitude)",
            "days": 14,
            "aqi": "yes",
            "lang": selectedLanguage ?? "en"
        ]

        AF.request(url, parameters: parameters).response { response in
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let weatherData = try decoder.decode(WeatherData24h.self, from: data)
                    print("Fetched weather data: \(weatherData.location.name)")
                    completion(weatherData)
                } catch {
                    print("Error decoding: \(error)")
                    completion(nil)
                }
            }
        }
    }
}

