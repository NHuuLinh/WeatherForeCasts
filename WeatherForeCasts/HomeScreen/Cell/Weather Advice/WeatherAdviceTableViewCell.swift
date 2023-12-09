//
//  WeatherAdviceTableViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 30/11/2023.
//

import UIKit

class WeatherAdviceTableViewCell: UITableViewCell {
    @IBOutlet weak var outDoorActive: UILabel!
    @IBOutlet weak var outDoorExercise: UILabel!
    @IBOutlet weak var conditionForUV: UILabel!
    @IBOutlet weak var conditionForDrive: UILabel!
    @IBOutlet weak var adviceAirPolution: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func getAdviceData(data: Forecastday) {
        let willRain = data.day.dailyWillItRain
        let willSnow = data.day.dailyWillItSnow
        let isRainSnow : Bool
        if willRain == 0 && willSnow == 0 {
            isRainSnow = false
        } else {
            isRainSnow = true
        }
        let dayTemp = data.day.avgtempC
        let dayHumidity = data.day.avghumidity
        let dayWindSpeed = data.day.maxwindKph
        let dayVision = data.day.avgvisKm
        let dayUV = data.day.uv
        
        var outDoorActiveResult = ""
        if !isRainSnow && dayTemp >= 20 && dayTemp <= 30 && dayHumidity >= 30 && dayHumidity <= 50 && dayWindSpeed < 17 && dayVision >= 5 && dayUV <= 5 {
            outDoorActiveResult = NSLocalizedString("Weather is great for outdoor active", comment: "")
        } else {
            outDoorActiveResult = NSLocalizedString("Weather is bad for outdoor active", comment: "")
        }
        outDoorActive.text = outDoorActiveResult
        
        var outDoorExerciseResult = ""
        if !isRainSnow {
            outDoorExerciseResult = NSLocalizedString("Weather is great for outdoor exercise", comment: "")
        } else {
            outDoorExerciseResult = NSLocalizedString("Weather is bad for outdoor exercise", comment: "")
        }
        outDoorExercise.text = outDoorExerciseResult
        
        var conditionForDriveResult = ""
        if !isRainSnow && dayTemp >= 20 && dayTemp <= 30 && dayHumidity >= 30 && dayHumidity <= 50 && dayWindSpeed < 17 && dayVision >= 5 && dayUV <= 5 {
            conditionForDriveResult = NSLocalizedString("Weather is good for driving", comment: "")
        } else {
            conditionForDriveResult = NSLocalizedString("Weather is not good for driving", comment: "")
        }
        conditionForDrive.text = conditionForDriveResult
        
        conditionForUV.text = NSLocalizedString(UVIndex.uvAdvice(uvValue: data.day.uv), comment: "")
        let aqiData = AQIHandle.airQualityDataAdvice(index: data.day.airQuality.usEpaIndex ?? 0)
        adviceAirPolution.text = NSLocalizedString(aqiData, comment: "")
    }
}
