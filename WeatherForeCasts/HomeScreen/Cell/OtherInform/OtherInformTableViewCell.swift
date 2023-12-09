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
    @IBOutlet weak var currentUvCondition: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var currentWindSpeed: UILabel!
    @IBOutlet weak var currentVisibility: UILabel!
    @IBOutlet weak var currentHumidity: UILabel!
    
    @IBOutlet weak var cloudLb: UILabel!
    @IBOutlet weak var tempLb: UILabel!
    @IBOutlet weak var visibilityLb: UILabel!
    @IBOutlet weak var uvIndex: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var humidity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        translateLangue()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func getOtherData(with forecastOther : Current) {
        currentCloud.text = "\(forecastOther.cloud)"
        let indexValue = Int(forecastOther.uv)
        currentUvIndex.text = "\(indexValue)"
        currentUvCondition.text = NSLocalizedString(UVIndex.uvCondition(uvValue: indexValue), comment: "")
        currentTemp.text = "\(Int(forecastOther.tempC.rounded()))"
        currentWindSpeed.text = "\(forecastOther.windKph)"
        currentVisibility.text = "\(forecastOther.visKm)"
        currentHumidity.text = "\(forecastOther.humidity)"
    }
    func translateLangue(){
        cloudLb.text = NSLocalizedString(cloudLb.text ?? "", comment: "")
        tempLb.text = NSLocalizedString(tempLb.text ?? "", comment: "")
        visibilityLb.text = NSLocalizedString(visibilityLb.text ?? "", comment: "")
        uvIndex.text = NSLocalizedString(uvIndex.text ?? "", comment: "")
        windSpeed.text = NSLocalizedString(windSpeed.text ?? "", comment: "")
        humidity.text = NSLocalizedString(humidity.text ?? "", comment: "")
    }
}
