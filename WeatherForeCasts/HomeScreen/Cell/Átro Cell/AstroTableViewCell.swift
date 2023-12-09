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
    
    @IBOutlet weak var sunAndMoonTitle: UILabel!
    @IBOutlet weak var sunriseLb: UILabel!
    @IBOutlet weak var sunsetLb: UILabel!
    @IBOutlet weak var moonriseLb: UILabel!
    @IBOutlet weak var moonsetLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        sunAndMoonTitle.text = NSLocalizedString(sunAndMoonTitle.text ?? "", comment: "")
        sunriseLb.text = NSLocalizedString(sunriseLb.text ?? "", comment: "")
        sunsetLb.text = NSLocalizedString(sunsetLb.text ?? "", comment: "")
        moonriseLb.text = NSLocalizedString(moonriseLb.text ?? "", comment: "")
        moonsetLb.text = NSLocalizedString(moonsetLb.text ?? "", comment: "")
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
        moonPhase.text = NSLocalizedString(moonPhase.text ?? "", comment: "")
    }
    
}
