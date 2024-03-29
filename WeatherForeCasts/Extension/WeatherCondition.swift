//
//  WeatherCondition.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 11/11/2023.
//

import Foundation
protocol WeatherCondition {
    func willSnow(localTime: String, forecastDays: [Forecastday]) -> String
    func willRain(localTime: String, forecastDays: [Forecastday]) -> String
}

extension WeatherCondition {
    
    func willSnow(localTime: String, forecastDays: [Forecastday]) -> String {
        // tạo mảng để lấy giá trị từ 2 mảng ngày gần nhất
        var willItSnowValues: [Int] = []
            // các biến để dịch thuật
        let hourText = NSLocalizedString("hours", comment: "")
        let wontText = NSLocalizedString("Won't snow in", comment: "")
        let willText = NSLocalizedString("Will snow in", comment: "")
        let errorText = NSLocalizedString("Unknown", comment: "")
        
        for i in 0...1 {
            for hour in forecastDays[i].hour {
                let willItSnowValue = hour.willItRain
                willItSnowValues.append(willItSnowValue)
            }
        }
        
        let hourForcast = 3
        guard willItSnowValues.count >= hourForcast else {
            return errorText
        }
        
        let hours = convertDate(date: localTime, inputFormat: "yyyy-MM-dd HH:ss", outputFormat: "HH")

        let hour  = Int(hours) ?? 0
        let values = Array(willItSnowValues[hour..<hour+hourForcast])

        switch values {
        case let arr where arr.allSatisfy({ $0 == 0 }):
            return "\(wontText) \(hourForcast) \(hourText)"
        default:
            return "\(willText) \(hourForcast) \(hourText)"
        }
    }
    
    func willRain(localTime: String, forecastDays: [Forecastday]) -> String {
        
        var willItRainValues: [Int] = []
        let hourText = NSLocalizedString("hours", comment: "")
        let wontText = NSLocalizedString("Won't rain in", comment: "")
        let willText = NSLocalizedString("Will rain in", comment: "")
        
        for i in 0...1 {
            for hour in forecastDays[i].hour {
                let willItRainValue = hour.willItRain
                willItRainValues.append(willItRainValue)
            }
        }
        let hourForcast = 3
        let errorText = NSLocalizedString("Unknown", comment: "")
        
        guard willItRainValues.count >= hourForcast else {
            return errorText
        }
        
        let hours = convertDate(date: localTime, inputFormat: "yyyy-MM-dd HH:ss", outputFormat: "HH")
        let hour  = Int(hours) ?? 0
        let values = Array(willItRainValues[hour..<hour+hourForcast])
        
        switch values {
        case let arr where arr.allSatisfy({ $0 == 0 }):
            return "\(wontText) \(hourForcast) \(hourText)"
        default:
            return "\(willText) \(hourForcast) \(hourText)"
        }
    }
    private func convertDate(date: String, inputFormat: String, outputFormat: String) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = inputFormat
        if let inputDate = dateFormatter.date(from: date) {
            // Định dạng thời gian đầu ra
            dateFormatter.dateFormat = outputFormat
            // Chuyển đổi thành chuỗi
            let formattedDateString = dateFormatter.string(from: inputDate)
            return formattedDateString
        } else {
            return "date error"
        }
    }

}
