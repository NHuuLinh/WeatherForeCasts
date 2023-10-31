//
//  WeatherLongDayViewController.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 29/10/2023.
//

import UIKit


class WeatherLongDayViewController: UIViewController {

    @IBOutlet weak var Weather14dayTbView: UITableView!
    var dates = [String]()
    var forecastdays = [Forecastday]()
    var dateSelectedHandler: (() -> Void)?
    enum TotalSection: Int {
        case dateSection // 0
        case WeatherSection // 1
    }
    private var homeSection = [TotalSection]()
    override func viewDidLoad() {
        super.viewDidLoad()
        get14DaysData()
        setupTableView()
        print(Weather14dayTbView.frame)

    }
    private func setupTableView() {
        Weather14dayTbView.dataSource = self // self chính instance của HomeViewController
        
        Weather14dayTbView.delegate = self
        
        Weather14dayTbView.separatorStyle = .none
        
        let datasCell = UINib(nibName: "DatesTableViewCell", bundle: nil)
        Weather14dayTbView.register(datasCell, forCellReuseIdentifier: "DatesTableViewCell")
        let weatherByDayCell = UINib(nibName: "WeatherByDayTableViewCell", bundle: nil)
        Weather14dayTbView.register(weatherByDayCell, forCellReuseIdentifier: "WeatherByDayTableViewCell")
    }
    func get14DaysData() {
        APIClient.shared.getWeatherData { result in
            switch result {
            case .success(let weatherData):
                let forecastdays = weatherData.forecast.forecastday
                // Lấy danh sách 14 ngày
                self.dates = forecastdays.map { $0.date }
                self.Weather14dayTbView.reloadData()
                print("success")
                
                // In giá trị date sau khi lấy dữ liệu
                for date in self.dates {
                    print("Date: \(date)")
                }
            case .failure(let error):
                print("API error: \(error)")
            }
        }
    }

}
    
extension WeatherLongDayViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let homeSection = TotalSection(rawValue: section)
        switch homeSection {
        case .dateSection:
            return forecastdays.count
        case.WeatherSection:
            return forecastdays.count
        default :
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < dates.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DatesTableViewCell", for: indexPath) as! DatesTableViewCell
            cell.bindData(date: dates[indexPath.row])
            cell.setOnClickDateHandler { selectedIndexPath in
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherByDayTableViewCell", for: indexPath) as! WeatherByDayTableViewCell
            let forecastData = forecastdays[indexPath.row - dates.count]
            cell.updateValue(withForecastData: forecastData)
            return cell
        }
    }
}
//extension WeatherLongDayViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return forecastdays.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "DatesTableViewCell", for: indexPath) as! DatesTableViewCell
//
//        // Truyền danh sách ngày và closure xử lý sự kiện từ WeatherLongDayViewController
//        cell.bindData(date: dates[indexPath.row])
//        return cell
//    }
//}

