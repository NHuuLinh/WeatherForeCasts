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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
