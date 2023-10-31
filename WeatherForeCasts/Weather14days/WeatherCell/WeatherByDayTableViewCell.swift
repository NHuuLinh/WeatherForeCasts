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
    @IBOutlet weak var forecastDayFellTemp: UILabel!
    @IBOutlet weak var forecastDayMaxTemp: UILabel!
    @IBOutlet weak var forecastDayMinTemp: UILabel!
    @IBOutlet weak var forecastDayWind: UILabel!
    @IBOutlet weak var forecastDayUV: UILabel!
    @IBOutlet weak var forecastDayRainChance: UILabel!
    @IBOutlet weak var forecastDayHumidity: UILabel!
    @IBOutlet weak var forecastDayAirQly: UILabel!
    @IBOutlet weak var forecastDaySunRaise: UILabel!
    @IBOutlet weak var forecastDaySunSet: UILabel!
    @IBOutlet weak var forecastDayMoonRise: UILabel!
    @IBOutlet weak var forecastDayMoonset: UILabel!
    @IBOutlet weak var forecastDayMoonPhase: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateValue(withForecastData forecastData: Forecastday) {
        forecastDayAvgTemp.text = ("\(forecastData.day.avgtempC)")
        forecastDayConditionText.text = forecastData.day.condition.text
    }
    
}

