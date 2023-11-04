//
//  Weather24hCollectionViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 24/10/2023.
//

import UIKit

class Weather24hCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    static let identifier = String(describing: Weather24hCollectionViewCell.self)


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func getData24h(data24h: Forecastday ) {
        timeLabel.text = data24h.date
        temperatureLabel.text = "\(data24h.day.avgtempC)"
        precipitationLabel.text = "\(data24h.day.dailyChanceOfRain)"
        let weatherIcon = extractImageNameCollect(url: "\(data24h.day.dailyChanceOfRain)")
        weatherIconImageView.image = UIImage(named: weatherIcon)
    }
}
