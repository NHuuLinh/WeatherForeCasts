//
//  CurrentWeatherTableViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 10/11/2023.
//

import UIKit

class CurrentWeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var currentWeatherCondition: UILabel!
    @IBOutlet weak var currentFeelsLikeTemp: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentWillRain: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func getCurrentData(with forecastCurrent : WeatherData24h ) {
        currentTime.text = forecastCurrent.location.localtime
        currentTemp.text = "\(forecastCurrent.current.tempC)°C"
        currentWeatherCondition.text = forecastCurrent.current.condition.text
        currentFeelsLikeTemp.text = "\(forecastCurrent.current.feelslikeC)°C"
        let icon = extractImageNameCell(url: forecastCurrent.current.condition.icon)
        currentWeatherIcon.image = UIImage(named: icon)
        let forecastDays = forecastCurrent.forecast.forecastday
        var willItRainValues: [Int] = []
        for i in 0...1 {
            for hour in forecastDays[i].hour {
                let willItRainValue = hour.willItRain
                willItRainValues.append(willItRainValue)
                print("Day \(i + 1) - Will it rain: \(willItRainValue)")
            }
        }
        if willItRainValues.count >= 2 {
            let components = currentTime.text?.components(separatedBy: " ")
            let currentTime = components?[1]
            print("\(currentTime)")

            let hourComponents = currentTime?.components(separatedBy: ":")
            let hours = hourComponents?[0]
            print("\(hours)")
            let hour  = Int(hours ?? "") ?? 0
            print(hour)
            let firstValue = willItRainValues[hour]
            let secondValue = willItRainValues[hour + 1]
            print("\(firstValue)")
            print("\(secondValue)")

            if firstValue == 0 && secondValue == 0 {
                currentWillRain.text = "Won't rain in 2 hours"
            }else {
                currentWillRain.text = "Will rain in 2 hours"
            }
        } else {
            print("Not enough data")
        }

    }
}
