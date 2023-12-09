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
    }
    func getWeeklyDatas(with week: Forecastday ) {
        weeklyDate.text = DateConvert.convertDate(date: week.date, inputFormat: "yyyy-MM-dd", outputFormat: "EEE dd/MM")
        let imageName = ExtractImage.extractImageName(url: "\(week.day.condition.icon)")
        weeklyImage.image = UIImage(named: imageName)
        weeklyConditionText.text = week.day.condition.text
        minTemp.text = "\(Int(week.day.mintempC.rounded()))"
        maxTemp.text = "\(Int(week.day.maxtempC.rounded()))"
    }
}
