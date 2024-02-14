//
//  DailyForecastTableViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 21/11/2023.
//

import UIKit

class DailyForecastTableViewCell: UITableViewCell, UvValueHandle, AQIHandle, ExtractImageFromUrl,DateConvertFormat {
    
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
    
    @IBOutlet weak var titleFeelLike: UILabel!
    @IBOutlet weak var titleSpeedWind: UILabel!
    @IBOutlet weak var titleUvIndex: UILabel!
    @IBOutlet weak var titleRainChain: UILabel!
    @IBOutlet weak var titleHumidity: UILabel!
    @IBOutlet weak var titleAirQty: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        translateLangue()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func getHourData(hour: Hour ) {
        forecastHourTime.text = convertDate(date: hour.time, inputFormat: "yyyy-MM-dd HH:mm", outputFormat: "HH:mm")
        let imageName = extractImageName(url: "\(hour.condition.icon)")
        forecastHourIcone.image = UIImage(named: imageName)
        forecastHourTemp.text = "\(Int(hour.tempC.rounded()))°C"
        forecastHourConditionText.text = hour.condition.text
        forecastHourFellTemp.text = "\(Int(hour.feelslikeC.rounded()))°C"
        forecastHourWind.text = "\(Int(hour.windMph.rounded()))"
        forecastHourUv.text = "\(Int(hour.uv))"
        forecastHourUvText.text = NSLocalizedString(uvCondition(uvValue: Int(hour.uv)), comment: "")
        forecastHourRainChance.text = "\(hour.chanceOfRain)"
        forecastHourHumidity.text = "\(hour.humidity)"
        
        let AirQlyNumber = hour.airQuality?.usEpaIndex ?? 0
        forecastHourAirQly.text = "\(AirQlyNumber)"
        forecastHourAirQlyText.text = NSLocalizedString(airQlyDataCondition(numb: AirQlyNumber), comment: "")
    }
    func translateLangue(){
        titleFeelLike.text = NSLocalizedString(titleFeelLike.text ?? "", comment: "")
        titleSpeedWind.text = NSLocalizedString(titleSpeedWind.text ?? "", comment: "")
        titleUvIndex.text = NSLocalizedString(titleUvIndex.text ?? "", comment: "")
        titleRainChain.text = NSLocalizedString(titleRainChain.text ?? "", comment: "")
        titleHumidity.text = NSLocalizedString(titleHumidity.text ?? "", comment: "")
        titleAirQty.text = NSLocalizedString(titleAirQty.text ?? "", comment: "")
    }
}

