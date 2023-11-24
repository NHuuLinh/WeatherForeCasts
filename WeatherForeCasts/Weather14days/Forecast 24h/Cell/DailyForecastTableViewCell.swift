//
//  DailyForecastTableViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 21/11/2023.
//

import UIKit

class DailyForecastTableViewCell: UITableViewCell {
    @IBOutlet weak var forecastHourTime: UILabel!
    @IBOutlet weak var forecastHourIcone: UIImageView!
    @IBOutlet weak var forecastHourTemp: UILabel!
    @IBOutlet weak var forecastHourConditionText: UILabel!
    @IBOutlet weak var forecastHourFellTemp: UILabel!
    @IBOutlet weak var forecastHourWind: UILabel!
    @IBOutlet weak var forecastHourUv: UILabel!
    @IBOutlet weak var forecastHourUvText: UILabel!
    @IBOutlet weak var forecastHourRainChance: UILabel!
    @IBOutlet weak var forecastHourHumidity: UILabel!
    @IBOutlet weak var forecastHourAirQly: UILabel!
    @IBOutlet weak var forecastHourAirQlyText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func getHourData(hour: Hour ) {
        forecastHourTime.text = DateConvert.convertDate(date: hour.time, inputFormat: "yyyy-MM-dd HH:mm", outputFormat: "HH:mm")
        forecastHourIcone.image = ExtractImage.extractImageName(url: "\(hour.condition.icon)")
        forecastHourTemp.text = "\(Int(hour.tempC.rounded()))°C"
        forecastHourConditionText.text = hour.condition.text
        forecastHourFellTemp.text = "\(Int(hour.feelslikeC.rounded()))°C"
        forecastHourWind.text = "\(Int(hour.windMph.rounded()))"
        forecastHourUv.text = "\(Int(hour.uv))"
        forecastHourRainChance.text = UVIndex.uvCondition(uvValue: Int(hour.uv))
        forecastHourRainChance.text = "\(hour.chanceOfRain)"
        forecastHourHumidity.text = "\(hour.humidity)"
        let AirQlyNumber = hour.airQuality.usEpaIndex ?? 0
        forecastHourAirQly.text = "\(AirQlyNumber)"
        forecastHourAirQlyText.text = "\(AQIHandle.airQlyDataCondition(numb: AirQlyNumber))"
    }
}

