//
//  DailyCollectionViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 04/11/2023.
//

import UIKit

class DailyCollectionViewCell: UICollectionViewCell,ExtractImageFromUrl,DateConvertFormat {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    static let identifier = String(describing: DailyCollectionViewCell.self)

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func getData24h(with hour: Hour) {
        timeLabel.text = convertDate(date: hour.time, inputFormat: "yyyy-MM-dd HH:mm", outputFormat: "HH:mm")
        temperatureLabel.text = "\(Int(hour.tempC.rounded()))°C"
        precipitationLabel.text = "\(hour.chanceOfRain)"
        let weatherIcon = extractImageName(url: "\(hour.condition.icon)")
        weatherIconImageView.image = UIImage(named: weatherIcon)
    }
}
