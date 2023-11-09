//
//  WeatherByDayTableViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 31/10/2023.
//

import UIKit

class WeatherByDayTableViewCell: UITableViewCell {
    //    forecastDay
    @IBOutlet weak var forecastDayIcone: UIImageView!
    @IBOutlet weak var forecastDayAvgTemp: UILabel!
    @IBOutlet weak var forecastDayConditionText: UILabel!
    @IBOutlet weak var forecastDayMaxTemp: UILabel!
    @IBOutlet weak var forecastDayMinTemp: UILabel!
    @IBOutlet weak var forecastDayWind: UILabel!
    @IBOutlet weak var forecastDayUV: UILabel!
    @IBOutlet weak var forecastDayRainChance: UILabel!
    @IBOutlet weak var forecastDayHumidity: UILabel!
    @IBOutlet weak var forecastDayAirQly: UILabel!
    @IBOutlet weak var forecastDayAirQlyText: UILabel!
    @IBOutlet weak var forecastDaySunRaise: UILabel!
    @IBOutlet weak var forecastDaySunSet: UILabel!
    @IBOutlet weak var forecastDayMoonRise: UILabel!
    @IBOutlet weak var forecastDayMoonset: UILabel!
    @IBOutlet weak var forecastDayMoonPhase: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func updateValue1231(datasForecast: Forecastday ) {
        let icon = extractImageNameCell(url: "\(datasForecast.day.condition.icon)")
        forecastDayIcone.image = UIImage(named: icon)
        forecastDayAvgTemp.text = "\(datasForecast.day.avgtempC)"
//        forecastDayConditionText.text = datasForecast.day.condition.text
        forecastDayConditionText.text = datasForecast.date
        forecastDayMaxTemp.text = "\(datasForecast.day.maxtempC)"
        forecastDayMinTemp.text = "\(datasForecast.day.mintempC)"
        forecastDayWind.text = "\(datasForecast.day.maxwindKph)"
        forecastDayUV.text = "\(datasForecast.day.uv)"
        forecastDayRainChance.text = "\(datasForecast.day.dailyChanceOfRain)"
        forecastDayHumidity.text = "\(datasForecast.day.avghumidity)"
//        forecastDayHumidity.text = "\(datasForecast.day.air_quality?.co ?? 0 )"

        forecastDayAirQly.text = "\(datasForecast.day.air_quality?.usEpaIndex ?? 0)"
        let AirQlyText = airQlyDataCell(numb: datasForecast.day.air_quality?.usEpaIndex ?? 0)
        forecastDayAirQlyText.text = AirQlyText
        forecastDaySunRaise.text = datasForecast.astro.sunrise
        forecastDaySunSet.text = datasForecast.astro.sunset
        forecastDayMoonRise.text = datasForecast.astro.moonrise
        forecastDayMoonset.text = datasForecast.astro.moonset
        forecastDayMoonPhase.text = "\(datasForecast.astro.moonPhase)"
    }
}

