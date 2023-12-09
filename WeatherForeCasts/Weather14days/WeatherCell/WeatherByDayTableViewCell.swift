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
    @IBOutlet weak var forecastDayUvCondition: UILabel!
    @IBOutlet weak var forecastDayRainChance: UILabel!
    @IBOutlet weak var forecastDayHumidity: UILabel!
    @IBOutlet weak var forecastDayAirQly: UILabel!
    @IBOutlet weak var forecastDayAirQlyText: UILabel!
    @IBOutlet weak var forecastDaySunRaise: UILabel!
    @IBOutlet weak var forecastDaySunSet: UILabel!
    @IBOutlet weak var forecastDayMoonRise: UILabel!
    @IBOutlet weak var forecastDayMoonset: UILabel!
    @IBOutlet weak var forecastDayMoonPhase: UILabel!
    @IBOutlet weak var test: UILabel!
    
    @IBOutlet weak var titleHighestTemp: UILabel!
    @IBOutlet weak var titleLowestTemp: UILabel!
    @IBOutlet weak var titleWindSpeed: UILabel!
    @IBOutlet weak var titleUV: UILabel!
    @IBOutlet weak var titleRainChain: UILabel!
    @IBOutlet weak var titleHumidity: UILabel!
    @IBOutlet weak var titleAirQty: UILabel!
    @IBOutlet weak var titleSunAndMoon: UILabel!
    @IBOutlet weak var titleSunrise: UILabel!
    @IBOutlet weak var titleSunset: UILabel!
    @IBOutlet weak var titleMoonrise: UILabel!
    @IBOutlet weak var titleMoonset: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        translateLangue()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func updateValue(datasForecast: Forecastday ) {
        let imageName  = ExtractImage.extractImageName(url: "\(datasForecast.day.condition.icon)")
        forecastDayIcone.image = UIImage(named: imageName)
        forecastDayAvgTemp.text = "\(Int(datasForecast.day.avgtempC.rounded()))"
        forecastDayConditionText.text = datasForecast.day.condition.text
        forecastDayMaxTemp.text = "\(Int(datasForecast.day.maxtempC.rounded()))"
        forecastDayMinTemp.text = "\(Int(datasForecast.day.mintempC.rounded()))"
        forecastDayWind.text = "\(Int(datasForecast.day.maxwindKph.rounded()))"
        let uvValue = Int(datasForecast.day.uv.rounded())
        forecastDayUV.text = "\(uvValue)"
        forecastDayUvCondition.text = NSLocalizedString(UVIndex.uvCondition(uvValue: uvValue), comment: "")
        forecastDayRainChance.text = "\(datasForecast.day.dailyChanceOfRain)"
        forecastDayHumidity.text = "\(Int(datasForecast.day.avghumidity.rounded()))"
        let aqiValue = datasForecast.day.airQuality.usEpaIndex ?? 0
        forecastDayAirQly.text = "\(aqiValue)"
        let AirQlyCondition = NSLocalizedString(AQIHandle.airQlyDataCondition(numb: aqiValue), comment: "")
        forecastDayAirQlyText.text = NSLocalizedString(AirQlyCondition, comment: "")
        forecastDaySunRaise.text = datasForecast.astro.sunrise
        forecastDaySunSet.text = datasForecast.astro.sunset
        forecastDayMoonRise.text = datasForecast.astro.moonrise
        forecastDayMoonset.text = datasForecast.astro.moonset
//        let moonPhase = "\(datasForecast.astro.moonPhase)"
        forecastDayMoonPhase.text = NSLocalizedString(datasForecast.astro.moonPhase, comment: "")
    }
    func test1123(test1: WeatherData24h) {
        test.text = "\(test1.forecast.forecastday[2].hour[3].humidity)"
    }
    func translateLangue(){
        titleHighestTemp.text = NSLocalizedString(titleHighestTemp.text ?? "", comment: "")
        titleLowestTemp.text = NSLocalizedString(titleLowestTemp.text ?? "", comment: "")
        titleWindSpeed.text = NSLocalizedString(titleWindSpeed.text ?? "", comment: "")
        titleUV.text = NSLocalizedString(titleUV.text ?? "", comment: "")
        titleRainChain.text = NSLocalizedString(titleRainChain.text ?? "", comment: "")
        titleHumidity.text = NSLocalizedString(titleHumidity.text ?? "", comment: "")
        titleAirQty.text = NSLocalizedString(titleAirQty.text ?? "", comment: "")
        titleSunrise.text = NSLocalizedString(titleSunrise.text ?? "", comment: "")
        titleSunset.text = NSLocalizedString(titleSunset.text ?? "", comment: "")
        titleMoonrise.text = NSLocalizedString(titleMoonrise.text ?? "", comment: "")
        titleMoonset.text = NSLocalizedString(titleMoonset.text ?? "", comment: "")
        titleSunAndMoon.text = NSLocalizedString(titleSunAndMoon.text ?? "", comment: "")

    }
}

