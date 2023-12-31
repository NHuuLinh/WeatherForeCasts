
import Foundation
import Alamofire

// Tạo một lớp mới để quản lý việc gọi API
class WeatherAPIManager {
    static let shared = WeatherAPIManager()
    

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
//    func fetchWeatherData1(completion: @escaping (WeatherData24h?) -> Void) {
//        let selectedLanguage = UserDefaults.standard.string(forKey: "AppleLanguages") ?? Locale.current.languageCode
//        print("selectedLanguage: \(selectedLanguage)")
//        let longitude = UserDefaults.standard.double(forKey: "locationLongitude")
//        let latitude = UserDefaults.standard.double(forKey: "locationLatitude")
//        print("longitude: \(longitude)")
//        print("latitude: \(latitude)")
//        let url = Constants.baseUrl
//        let parameters: [String: Any] = [
//            "key": Constants.key,
//            "q": "\(latitude),\(longitude)",
//            "days": 14,
//            "aqi": "yes",
//            "lang": selectedLanguage ?? "en"
//        ]
//        AF.request(url, parameters: parameters).response { response in
//            if let data = response.data {
//                let decoder = JSONDecoder()
//                do {
//                    let weatherData = try decoder.decode(WeatherData24h.self, from: data)
//                    print("Fetched weather data: \(weatherData.location.name)")
//                    completion(weatherData)
//                } catch {
//                    print("Error decoding: \(error)")
//                    completion(nil)
//                }
//            }
//        }
//    }
    
}

