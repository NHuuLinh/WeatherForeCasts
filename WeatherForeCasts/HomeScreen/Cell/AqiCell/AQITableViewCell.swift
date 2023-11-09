//
//  AQITableViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 04/11/2023.
//

import UIKit

class AQITableViewCell: UITableViewCell {
    @IBOutlet weak var currentAirQuality: UILabel!
    @IBOutlet weak var currentAirCondition: UILabel!
    @IBOutlet weak var currentAirLevel: UIView!
    @IBOutlet weak var currentAirLevelWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("\(currentAirLevel.frame.size.width)")

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func getAirData(with forecastAqi : AirQuality) {
        let AirQlyNumber = forecastAqi.usEpaIndex ?? 0
        currentAirQuality.text = "\(AirQlyNumber)"
        let airCondition = airQlyDataCell(numb: AirQlyNumber)
        currentAirCondition.text = airCondition
        let airLevel = airQlyLevel(width: AirQlyNumber)
        currentAirLevelWidth.constant = airLevel
        let airQlyColor = airQlyColor(numb: AirQlyNumber)
        currentAirLevel.backgroundColor = airQlyColor
        
    }
}
