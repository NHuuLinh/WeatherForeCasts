//
//  WeatherLongDayViewController.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 29/10/2023.
//

import UIKit
import Alamofire



class WeatherLongDayViewController: UIViewController {
    
    @IBOutlet weak var Weather14dayTbView: UITableView!
    var dates = [String]()
    var forecastdays: [ForecastDay1] = []
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
        //        Weather14dayTbView.estimatedRowHeight = 100 // Adjust this to a reasonable estimate
        //            Weather14dayTbView.rowHeight = UITableView.automaticDimension
        
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
                                    // Lấy danh sách các ngày trong tuần
                                    self.dates = forecastdays.map { $0.date }
//                self.forecastdays = weatherData.forecast.forecastday
                                    self.Weather14dayTbView.reloadData()
                                    print("success")
//                 In giá trị date sau khi lấy dữ liệu
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
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DatesTableViewCell", for: indexPath) as! DatesTableViewCell
            cell.bindData(dates: dates) { selectedIndexPath in
//                //            // Xử lý sự kiện khi người dùng chọn một ngày
//                ////            print("Selected date: \(self.dates[selectedIndexPath.row])")
            }
                return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherByDayTableViewCell", for: indexPath) as! WeatherByDayTableViewCell

            return cell
        }
    }
}
