//
//  DailyForecastViewController.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 21/11/2023.
//

import UIKit

class DailyForecastViewController: UIViewController {
    @IBOutlet weak var dailyForecastTableView: UITableView!
    @IBOutlet weak var dayForecastLb: UILabel!
    var weatherData24h: Forecastday?
    var dayForecast : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
//        weatherData24h = WeatherDataManager.shared.weatherData?.forecast.forecastday[0]
        dayForecastLb.text = DateConvert.convertDate(date: weatherData24h?.date ?? "0", inputFormat: "yyyy-MM-dd", outputFormat: "EEE dd/MM")
            dailyForecastTableView.reloadData()
//        getweatherData()
    }
    private func registerCell() {
        let cell = UINib(nibName: "DailyForecastTableViewCell", bundle: nil)
        dailyForecastTableView.register(cell, forCellReuseIdentifier: "DailyForecastTableViewCell")
        dailyForecastTableView.dataSource = self
        dailyForecastTableView.delegate = self
    }
//    private func getweatherData() {
//        guard let location = LocationManager.shared.currentLocation else {
//            print("Failed to get current location")
//            return
//        }
//        self.showLoading(isShow: true)
//        DispatchQueue.global().async {
//            WeatherAPIManager1.shared.fetchWeatherData(latitude: location.latitude, longitude: location.longitude) { weatherData in
//                guard let weatherData = weatherData?.forecast.forecastday[self.dayForecast ?? 0] else {
//                    print("Failed to fetch weather data")
//                    return
//                }
//                self.weatherData24h = weatherData
//                self.dayForecastLb.text = DateConvert.convertDate(date: weatherData.date, inputFormat: "yyyy-MM-dd", outputFormat: "EEE dd/MM")
//                self.dailyForecastTableView.reloadData()
//            }
//        }
//        self.showLoading(isShow: false)
//    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension DailyForecastViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData24h?.hour.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyForecastTableViewCell", for: indexPath) as! DailyForecastTableViewCell
        if let hour = weatherData24h?.hour {
            cell.getHourData(hour: hour[indexPath.row])
        }
        return cell
    }
}

