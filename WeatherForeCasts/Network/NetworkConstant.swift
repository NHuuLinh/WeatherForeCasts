//
//  NetworkConstant.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 29/10/2023.
//

import Foundation
import Alamofire

struct Weather {
    let time: String
    let temperature: Double
    let rainChance: Int
    let icon: String
}

class APIClient {
    static let shared = APIClient()
//    static let Location =

    private init() {}

    func getWeatherData(completion: @escaping (Result<WeatherData24h, Error>) -> Void) {
        let apiKey = "29eecb9c4b7945d282190107232910"
        let baseURL = "http://api.weatherapi.com/v1/forecast.json"

        let parameters: [String: Any] = [
            "key": apiKey,
            "q": "Hanoi",
            "days": 14,
            "lang": "vn"
        ]

        AF.request(baseURL, method: .get, parameters: parameters).responseDecodable(of: WeatherData24h.self) { response in
            switch response.result {
            case .success(let weatherData):
                completion(.success(weatherData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
class APIClient1 {
    static let shared = APIClient1()

    private init() {}

    func getWeatherData(completion: @escaping (Result<Forecast, Error>) -> Void) {
        let apiKey = "29eecb9c4b7945d282190107232910"
        let baseURL = "http://api.weatherapi.com/v1/forecast.json"

        let parameters: [String: Any] = [
            "key": apiKey,
            "q": "Hanoi",
            "days": 14,
            "aqi": "yes",
            "lang": "vi"
            
        ]

        AF.request(baseURL, method: .get, parameters: parameters).responseDecodable(of: Forecast.self) { response in
            switch response.result {
            case .success(let weatherData):
                completion(.success(weatherData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
class APIClient2 {
    static let shared = APIClient2()

    private init() {}

    func getWeatherData(completion: @escaping (Result<Forecastday, Error>) -> Void) {
        let apiKey = "29eecb9c4b7945d282190107232910"
        let baseURL = "http://api.weatherapi.com/v1/forecast.json"

        let parameters: [String: Any] = [
            "key": apiKey,
            "q": "Hanoi",
            "days": 14,
            "aqi": "yes",
            "lang": "vi"
            
        ]

        AF.request(baseURL, method: .get, parameters: parameters).responseDecodable(of: Forecastday.self) { response in
            switch response.result {
            case .success(let weatherData):
                completion(.success(weatherData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}



