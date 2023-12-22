//
//  WeatherByDayTableViewCell.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 31/10/2023.
//

import UIKit

class WeatherByDayTableViewCell: UITableViewCell {
    //    forecastDay
    @IBOutlet weak var forecastDayIcone: UIImageView!
    @IBOutlet weak var forecastDayAvgTemp: UILabel!
    @IBOutlet weak var forecastDayConditionText: UILabel!
    @IBOutlet weak var forecastDayMaxTemp: UILabel!
    @IBOutlet weak var forecastDayMinTemp: UILabel!
    @IBOutlet weak var forecastDayWind: UILabel!
    @IBOutlet weak var forecastDayUV: UILabel!
    @IBOutlet weak var forecastDayUvCondition: UILabel!
    @IBOutlet weak var forecastDayRainChance: UILabel!
    @IBOutlet weak var forecastDayHumidity: UILabel!
    @IBOutlet weak var forecastDayAirQly: UILabel!
    @IBOutlet weak var forecastDayAirQlyText: UILabel!
    @IBOutlet weak var forecastDaySunRaise: UILabel!
    @IBOutlet weak var forecastDaySunSet: UILabel!
    @IBOutlet weak var forecastDayMoonRise: UILabel!
    @IBOutlet weak var forecastDayMoonset: UILabel!
    @IBOutlet weak var forecastDayMoonPhase: UILabel!
    @IBOutlet weak var test: UILabel!
    
    @IBOutlet weak var titleHighestTemp: UILabel!
    @IBOutlet weak var titleLowestTemp: UILabel!
    @IBOutlet weak var titleWindSpeed: UILabel!
    @IBOutlet weak var titleUV: UILabel!
    @IBOutlet weak var titleRainChain: UILabel!
    @IBOutlet weak var titleHumidity: UILabel!
    @IBOutlet weak var titleAirQty: UILabel!
    @IBOutlet weak var titleSunAndMoon: UILabel!
    @IBOutlet weak var titleSunrise: UILabel!
    @IBOutlet weak var titleSunset: UILabel!
    @IBOutlet weak var titleMoonrise: UILabel!
    @IBOutlet weak var titleMoonset: UILabel!
    
    @IBOutlet weak var sunOrbit: UIImageView!
    @IBOutlet weak var sunImage: UIImageView!
    @IBOutlet weak var sunImageXConstan: NSLayoutConstraint!
    @IBOutlet weak var sunImageYConstan: NSLayoutConstraint!
    @IBOutlet weak var moonOrbit: UIImageView!
    @IBOutlet weak var moonImage: UIImageView!
    var currentTime : String?
    var timeData : WeatherData24h?
    override func awakeFromNib() {
        super.awakeFromNib()
        translateLangue()
        
//        animationAstro()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func test1123(test1: WeatherData24h) {
        self.timeData = test1
    }
    func updateValue(datasForecast: Forecastday ) {
        let imageName  = ExtractImage.extractImageName(url: "\(datasForecast.day.condition.icon)")
        forecastDayIcone.image = UIImage(named: imageName)
        forecastDayAvgTemp.text = "\(Int(datasForecast.day.avgtempC.rounded()))"
        forecastDayConditionText.text = datasForecast.day.condition.text
        forecastDayMaxTemp.text = "\(Int(datasForecast.day.maxtempC.rounded()))"
        forecastDayMinTemp.text = "\(Int(datasForecast.day.mintempC.rounded()))"
        forecastDayWind.text = "\(Int(datasForecast.day.maxwindKph.rounded()))"
        let uvValue = Int(datasForecast.day.uv.rounded())
        forecastDayUV.text = "\(uvValue)"
        forecastDayUvCondition.text = NSLocalizedString(UVIndex.uvCondition(uvValue: uvValue),
                                                        comment: "")
        forecastDayRainChance.text = "\(datasForecast.day.dailyChanceOfRain)"
        forecastDayHumidity.text = "\(Int(datasForecast.day.avghumidity.rounded()))"
        let aqiValue = datasForecast.day.airQuality.usEpaIndex ?? 0
        forecastDayAirQly.text = "\(aqiValue)"
        let AirQlyCondition = NSLocalizedString(AQIHandle.airQlyDataCondition(numb: aqiValue),
                                                comment: "")
        forecastDayAirQlyText.text = NSLocalizedString(AirQlyCondition,
                                                       comment: "")
        forecastDaySunRaise.text = DateConvert.convertDate24h(date: datasForecast.astro.sunrise,
                                                              inputFormat: "hh:mm a",
                                                              outputFormat: "HH:mm")
        forecastDaySunSet.text = DateConvert.convertDate24h(date: datasForecast.astro.sunset,
                                                            inputFormat: "hh:mm a",
                                                            outputFormat: "HH:mm")
        forecastDayMoonRise.text = DateConvert.convertDate24h(date: datasForecast.astro.moonrise,
                                                              inputFormat: "hh:mm a",
                                                              outputFormat: "HH:mm")
        forecastDayMoonset.text = DateConvert.convertDate24h(date: datasForecast.astro.moonset,
                                                             inputFormat: "hh:mm a",
                                                             outputFormat: "HH:mm")
        
        forecastDayMoonPhase.text = NSLocalizedString(datasForecast.astro.moonPhase, comment: "")
        
        
        let currentValue = DateConvert.convertDate24h(date: timeData?.location.localtime ?? "",
                                                      inputFormat: "yyyy-MM-dd HH:mm",
                                                      outputFormat: "HH:mm")
        let sunEndAngle = DateConvert.hourToAngle(riseHours: forecastDaySunRaise.text ?? "",
                                                  setHours: forecastDaySunSet.text ?? "",
                                                  currentHours: currentValue)

        let moonEndAngle = DateConvert.hourToAngle(riseHours: forecastDayMoonRise.text ?? "",
                                                  setHours: forecastDayMoonset.text ?? "",
                                                  currentHours: currentValue)

        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let currentDate = DateConvert.convertDate(date: timeData?.location.localtime ?? "", inputFormat: "yyyy-MM-dd HH:mm", outputFormat: "yyyy-MM-dd")
        let tomorrowDate = datasForecast.date

        if let todayDay = dateFormatter.date(from: currentDate), let tomorrowDay = dateFormatter.date(from: tomorrowDate) {
            if todayDay < tomorrowDay {
                print("không cần hàm animation")

            } else {
                AnimationHandle.astroAnimetion(endAngle: sunEndAngle,
                                               rootImage: sunOrbit,
                                               animationImage: sunImage)
                AnimationHandle.astroAnimetion(endAngle: moonEndAngle,
                                               rootImage: moonOrbit,
                                               animationImage: moonImage)
            }
        } else {
            print("Không thể chuyển đổi chuỗi thành ngày")
        }
    }

    func translateLangue(){
        titleHighestTemp.text = NSLocalizedString(titleHighestTemp.text ?? "", comment: "")
        titleLowestTemp.text = NSLocalizedString(titleLowestTemp.text ?? "", comment: "")
        titleWindSpeed.text = NSLocalizedString(titleWindSpeed.text ?? "", comment: "")
        titleUV.text = NSLocalizedString(titleUV.text ?? "", comment: "")
        titleRainChain.text = NSLocalizedString(titleRainChain.text ?? "", comment: "")
        titleHumidity.text = NSLocalizedString(titleHumidity.text ?? "", comment: "")
        titleAirQty.text = NSLocalizedString(titleAirQty.text ?? "", comment: "")
        titleSunrise.text = NSLocalizedString(titleSunrise.text ?? "", comment: "")
        titleSunset.text = NSLocalizedString(titleSunset.text ?? "", comment: "")
        titleMoonrise.text = NSLocalizedString(titleMoonrise.text ?? "", comment: "")
        titleMoonset.text = NSLocalizedString(titleMoonset.text ?? "", comment: "")
        titleSunAndMoon.text = NSLocalizedString(titleSunAndMoon.text ?? "", comment: "")
    }
    func testads(endAngle: CGFloat ) {
        let path = UIBezierPath()
        let xcordate = sunOrbit.frame.minX + 25
        print("xcordate: \(xcordate)")
        let ycordate = sunOrbit.frame.maxY - 15
        print("ycordate: \(ycordate)")
        let value: CGFloat = 110

        path.move(to: CGPoint(x: xcordate, y: ycordate))
        
        
        // Add an arc representing 1/2 of a circle
        let startAngle = CGFloat.pi  // Bắt đầu từ phía trên
        print("\(startAngle)")
//        let endAngle = startAngle + CGFloat.pi  // Kết thúc ở phía dưới
        path.addArc(withCenter: CGPoint(x: xcordate + value/2, y: ycordate),
                    radius: value/2,
                    startAngle: startAngle,
                    endAngle: -(CGFloat.pi*(endAngle )),
                    clockwise: true)

        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.duration = 4
        animation.timingFunctions = [CAMediaTimingFunction(name: .easeInEaseOut)]
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false

        sunImage.layer.add(animation, forKey: "curveAnimation")
        sunImage.layer.position = CGPoint(x: xcordate, y: ycordate + value)
    }
}

