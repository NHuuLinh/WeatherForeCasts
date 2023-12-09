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
    @IBOutlet weak var currentWillSnow: UILabel!
    @IBOutlet weak var feelLikeLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        translateLangue()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func getCurrentData(with forecastCurrent : WeatherData24h ) {
        let localTime = forecastCurrent.location.localtime
//        print( "localTime: \(localTime)")
        currentTime.text = DateConvert.convertDate(date: localTime, inputFormat: "yyyy-MM-dd HH:mm", outputFormat: "HH:mm EEEE")
        currentTemp.text = "\(Int(forecastCurrent.current.tempC.rounded()))°C"
        currentWeatherCondition.text = forecastCurrent.current.condition.text
        currentFeelsLikeTemp.text = "\(Int(forecastCurrent.current.feelslikeC.rounded()))°C"
        let imageName = ExtractImage.extractImageName(url: forecastCurrent.current.condition.icon)
        currentWeatherIcon.image = UIImage(named: imageName)
        let willItRain = WeatherCondition.willRain(localTime: localTime, forecastDays: forecastCurrent.forecast.forecastday)
        currentWillRain.text = willItRain
        let willItSnow = WeatherCondition.willSnow(localTime: localTime, forecastDays: forecastCurrent.forecast.forecastday)
        currentWillSnow.text = willItSnow
    }
}
extension CurrentWeatherTableViewCell {
    func translateLangue(){
        feelLikeLb.text = NSLocalizedString("Feel like: ", comment: "")
    }
}
