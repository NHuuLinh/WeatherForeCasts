//
//  AstroTableViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 09/11/2023.
//

import UIKit

class AstroTableViewCell: UITableViewCell, DateConvertFormat,AnimationHandle {
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
    
    @IBOutlet weak var sunOrbit: UIImageView!
    @IBOutlet weak var sunImage: UIImageView!
    @IBOutlet weak var moonOrbit: UIImageView!
    @IBOutlet weak var moonImage: UIImageView!
    
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
    func getAstroData(with forecastAstro : Forecastday,with currentTime: String ) {
        sunriseTime.text = convertDate24h(date: forecastAstro.astro.sunrise,
                                                      inputFormat: "hh:mm a",
                                                      outputFormat: "HH:mm")
        sunsetTime.text = convertDate24h(date: forecastAstro.astro.sunset,
                                                     inputFormat: "hh:mm a",
                                                     outputFormat: "HH:mm")
        moonriseTime.text = convertDate24h(date:forecastAstro.astro.moonrise,
                                                       inputFormat: "hh:mm a",
                                                       outputFormat: "HH:mm")
        moonsetTime.text = convertDate24h(date: forecastAstro.astro.moonset,
                                                      inputFormat: "hh:mm a",
                                                      outputFormat: "HH:mm")
        let moonPhaseText = forecastAstro.astro.moonPhase
        moonPhase.text = NSLocalizedString(moonPhaseText ,comment: "")
        
        let currentValue = convertDate24h(date: currentTime,
                                                      inputFormat: "yyyy-MM-dd HH:mm",
                                                      outputFormat: "HH:mm")
        
        let sunEndAngle = hourToAngle(riseHours: sunriseTime.text ?? "",
                                                  setHours: sunsetTime.text ?? "",
                                                  currentHours: currentValue )
        
        astroAnimetion(endAngle: sunEndAngle,
                                       rootImage: sunOrbit,
                                       animationImage: sunImage)
        
        let moonEndAngle = hourToAngle(riseHours: moonriseTime.text ?? "",
                                                   setHours: moonsetTime.text ?? "",
                                                   currentHours: currentValue )
        
        astroAnimetion(endAngle: moonEndAngle,
                                       rootImage: moonOrbit,
                                       animationImage: moonImage)
    }
    
}
