//
//  WeatherCondition.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 11/11/2023.
//

import Foundation
class WeatherCondition {
    static func willSnow1(localTime: String, forecastDays: [Forecastday] ) -> String{
        var willItSnowValues: [Int] = []
        for i in 0...1 {
           for hour in forecastDays[i].hour {
               let willItSnowValue = hour.willItSnow
               willItSnowValues.append(willItSnowValue)
              print("Day \(i + 1) - Will it snow: \(willItSnowValue)")
           }
        }
        if willItSnowValues.count >= 2 {
           let components = localTime.components(separatedBy: " ")
           let currentTime = components[1]
           print("\(currentTime)")
           let hourComponents = currentTime.components(separatedBy: ":")
           let hours = hourComponents[0]
           print("\(hours)")
           let hour  = Int(hours) ?? 0
           print("hour : \(hour)")
           let firstValue = willItSnowValues[hour]
           print("firstValue : \(firstValue)")
           let secondValue = willItSnowValues[hour + 1]
           print("secondValue : \(secondValue)")
           if firstValue == 0 && secondValue == 0 {
              return "Won't snow in 2 hours"
           }else {
              return "Will snow in 2 hours"
           }
        } else {
           return "Unknow"
        }
     }
    static func willSnow(localTime: String, forecastDays: [Forecastday]) -> String {
        var willItSnowValues: [Int] = []
        let hourText = NSLocalizedString("hours", comment: "")
        let resultText = NSLocalizedString("Won't snow in", comment: "")
        let failText = NSLocalizedString("Will snow in", comment: "")
        let errorText = NSLocalizedString("Unknown", comment: "")
        for i in 0...1 {
            for hour in forecastDays[i].hour {
                let willItSnowValue = hour.willItRain
                willItSnowValues.append(willItSnowValue)
            }
        }
        let hourForcast = 6
        guard willItSnowValues.count >= hourForcast else {
            return errorText
        }
        let hours = DateConvert.convertDate(date: localTime, inputFormat: "yyyy-MM-dd HH:ss", outputFormat: "HH")
        print("\(hours)")
        let hour  = Int(hours) ?? 0
        let values = Array(willItSnowValues[hour..<hour+hourForcast])
        print("\(values)")
        switch values {
        case let arr where arr.allSatisfy({ $0 == 0 }):
            return "\(resultText) \(hourForcast) \(hourText)"
        default:
            return "\(failText) \(hourForcast) \(hourText)"
        }
    }
    static func willRain(localTime: String, forecastDays: [Forecastday]) -> String {
        var willItRainValues: [Int] = []
        let hourText = NSLocalizedString("hours", comment: "")
        let resultText = NSLocalizedString("Won't rain in", comment: "")
        let failText = NSLocalizedString("Will snow in", comment: "")
        
        for i in 0...1 {
            for hour in forecastDays[i].hour {
                let willItRainValue = hour.willItRain
                willItRainValues.append(willItRainValue)
            }
        }
        let hourForcast = 6
        let errorText = NSLocalizedString("Unknown", comment: "")
        guard willItRainValues.count >= hourForcast else {
            return errorText
        }
        let hours = DateConvert.convertDate(date: localTime, inputFormat: "yyyy-MM-dd HH:ss", outputFormat: "HH")
        print("\(hours)")
        let hour  = Int(hours) ?? 0
        let values = Array(willItRainValues[hour..<hour+hourForcast])
        print("\(values)")
        switch values {
        case let arr where arr.allSatisfy({ $0 == 0 }):
            return "\(resultText) \(hourForcast) \(hourText)"
        default:
            return "\(failText) \(hourForcast) \(hourText)"
        }
    }

}
