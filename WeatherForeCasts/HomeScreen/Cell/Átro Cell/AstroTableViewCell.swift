//
//  AstroTableViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 09/11/2023.
//

import UIKit

class AstroTableViewCell: UITableViewCell {
    @IBOutlet weak var sunriseTime: UILabel!
    @IBOutlet weak var sunsetTime: UILabel!
    @IBOutlet weak var moonriseTime: UILabel!
    @IBOutlet weak var moonsetTime: UILabel!
    @IBOutlet weak var moonPhase: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func getAstroData(with forecastAstro : Forecastday) {
        sunriseTime.text = forecastAstro.astro.sunrise
        sunsetTime.text = forecastAstro.astro.sunset
        moonriseTime.text = forecastAstro.astro.moonrise
        moonsetTime.text = forecastAstro.astro.moonset
        moonPhase.text = forecastAstro.astro.moonPhase
    }
    
}
