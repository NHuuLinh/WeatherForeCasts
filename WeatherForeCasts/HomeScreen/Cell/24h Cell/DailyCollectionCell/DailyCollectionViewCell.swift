//
//  DailyCollectionViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 04/11/2023.
//

import UIKit

class DailyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    static let identifier = String(describing: DailyCollectionViewCell.self)


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func getData24h(with hour: Hour ) {
        timeLabel.text = hour.time
//        print(timeLabel.text)
        temperatureLabel.text = "\(hour.tempC)"
        precipitationLabel.text = "\(hour.chanceOfRain)"
        let weatherIcon = extractImageNameCollect(url: "\(hour.condition.icon)")
//        print(weatherIcon)
        weatherIconImageView.image = UIImage(named: weatherIcon)
    }
}
