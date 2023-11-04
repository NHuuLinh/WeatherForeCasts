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
    func getData24h(data24h: Hour ) {
        timeLabel.text = data24h.time
        temperatureLabel.text = "\(data24h.tempC)"
        precipitationLabel.text = "\(data24h.chanceOfRain)"
        let weatherIcon = extractImageNameCollect(url: "\(data24h.condition.text)")
        weatherIconImageView.image = UIImage(named: weatherIcon)
    }
}
