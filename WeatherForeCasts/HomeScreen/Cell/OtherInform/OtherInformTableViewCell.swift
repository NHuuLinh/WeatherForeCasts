//
//  OtherInformTableViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 04/11/2023.
//

import UIKit

class OtherInformTableViewCell: UITableViewCell {
    @IBOutlet weak var currentCloud: UILabel!
    @IBOutlet weak var currentUvIndex: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var currentWindSpeed: UILabel!
    @IBOutlet weak var currentVisibility: UILabel!
    @IBOutlet weak var currentHumidity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func getOtherData(with forecastOther : Current) {
        currentCloud.text = "\(forecastOther.cloud)"
        print("\(forecastOther.cloud)")
        currentUvIndex.text = "\(forecastOther.uv)"
        currentTemp.text = "\(forecastOther.tempC)"
        currentWindSpeed.text = "\(forecastOther.windKph)"
        currentVisibility.text = "\(forecastOther.visKm)"
        currentHumidity.text = "\(forecastOther.humidity)"
    }
    
}
