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
    @IBOutlet weak var titleForecast: UILabel!
    private var dateSelectedHandler: (() -> Void)?
    var weatherData: WeatherData24h?
    private var selectedDateIndex: Int?
    private var sections = [WeatherLongDay]()
    enum WeatherLongDay: Int {
        case dates = 0
        case datasForecast
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        Weather14dayTbView.reloadData()
        titleForecast.text = NSLocalizedString(titleForecast.text ?? "", comment: "")
//        getweatherData()
    }
    private func setupTableView() {
        Weather14dayTbView.dataSource = self
        Weather14dayTbView.delegate = self
        Weather14dayTbView.separatorStyle = .none
        let datasCell = UINib(nibName: "DatesTableViewCell", bundle: nil)
        Weather14dayTbView.register(datasCell, forCellReuseIdentifier: "DatesTableViewCell")
        let weatherByDayCell = UINib(nibName: "WeatherByDayTableViewCell", bundle: nil)
        Weather14dayTbView.register(weatherByDayCell, forCellReuseIdentifier: "WeatherByDayTableViewCell")
    }
    @IBAction func BackHomeButton(_ sender: Any) {
        gotoHomeViewController()
    }
    func gotoHomeViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
//        private func getweatherData() {
//            guard let location = LocationManager.shared.currentLocation else {
//                print("Failed to get current location")
//                return
//            }
//            DispatchQueue.global().async {
//                WeatherAPIManager1.shared.fetchWeatherData(latitude: location.latitude, longitude: location.longitude) { weatherData in
//                    guard let weatherData = weatherData else {
//                        print("Failed to fetch weather data")
//                        return
//                    }
//                    WeatherDataManager.shared.weatherData = weatherData
//                    self.weatherData = weatherData
//                    self.Weather14dayTbView.reloadData()
//                }
//            }
//        }
}

extension WeatherLongDayViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let homeSection = WeatherLongDay(rawValue: section)
        switch homeSection {
        case .dates:
            return 1
        case .datasForecast:
            print("\(weatherData?.forecast.forecastday.count ?? 0)")

            return weatherData?.forecast.forecastday.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weatherSection = WeatherLongDay(rawValue: indexPath.section)
        switch weatherSection {
        case.dates:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DatesTableViewCell", for: indexPath) as! DatesTableViewCell
            if let dates = weatherData?.forecast.forecastday {
                cell.bindData(dates: dates, selectedDateIndex: selectedDateIndex) { index in
                    self.selectedDateIndex = index
                    tableView.reloadData()
                }
            }
            return cell
        case.datasForecast:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherByDayTableViewCell", for: indexPath) as! WeatherByDayTableViewCell
            if let datasForecast = weatherData?.forecast.forecastday {
                cell.updateValue(datasForecast: datasForecast[indexPath.row])
            }
            if let test1 = weatherData{
                cell.test1123(test1: test1)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let weatherSection = WeatherLongDay(rawValue: indexPath.section)
        switch weatherSection {
        case.dates:
            return 50
        case.datasForecast:
            if indexPath.row == (selectedDateIndex ?? 0) {
                return 700
            } else {
                return 0.1
            }
        default:
            return 700
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weatherSection = WeatherLongDay(rawValue: indexPath.section)
        switch weatherSection {
        case .datasForecast:
            print("Bạn đã chọn dòng \(indexPath.row) trong phần datasForecast")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let dailyForecastVC: DailyForecastViewController = storyboard.instantiateViewController(withIdentifier: "DailyForecastViewController") as! DailyForecastViewController
//            dailyForecastVC.dayForecast = indexPath.row // Gán giá trị cho dayForecast
            dailyForecastVC.weatherData24h = weatherData?.forecast.forecastday[indexPath.row]
            navigationController?.pushViewController(dailyForecastVC, animated: true )
        default:
            break
        }
    }
}
