//
//  WeeklyWeatherCollectionViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 03/11/2023.
//

import UIKit

class WeeklyWeatherCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var weeklyDate: UILabel!
    @IBOutlet weak var weeklyImage: UIImageView!
    @IBOutlet weak var weeklyConditionText: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    static let identifier = String(describing: WeeklyWeatherCollectionViewCell.self)

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func getWeeklyDatas(weeklyDatas: Forecastday ) {
        weeklyDate.text = weeklyDatas.date
        let icon = extractImageNameCollect(url: "\(weeklyDatas.day.condition.icon)")
        weeklyImage.image = UIImage(named: icon)
        weeklyConditionText.text = weeklyDatas.day.condition.text
        minTemp.text = "\(weeklyDatas.day.mintempC)"
        maxTemp.text = "\(weeklyDatas.day.maxtempC)"
    }

}
