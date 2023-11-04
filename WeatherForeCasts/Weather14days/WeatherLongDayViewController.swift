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
    private var dates = [String]()
    private var dateSelectedHandler: (() -> Void)?
    private var datasForecast = [Forecastday]()
    private var isDataLoaded = false
    private var dateReload: Int?
    private var selectedDateIndex: Int?
    private var sections = [WeatherLongDay]()
    enum WeatherLongDay: Int {
        case dates = 0
        case datasForecast
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        get14DaysDatas()
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
    func get14DaysDatas() {
        APIClient.shared.getWeatherData { result in
            switch result {
            case .success(let weatherData):
                let datasForecast1 = weatherData.forecast.forecastday
                self.datasForecast = datasForecast1
                self.dates = datasForecast1.map { $0.date }
                self.Weather14dayTbView.reloadData()
            case .failure(let error):
                print("API error: \(error)")
            }
        }
    }
    @IBAction func BackHomeButton(_ sender: Any) {
        gotoHomeViewController()
    }
    func gotoHomeViewController() {
        if let uwWindow = (UIApplication.shared.delegate as? AppDelegate)?.window {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
            uwWindow.rootViewController = mainVC
            uwWindow.makeKeyAndVisible()
        } else {
            print("LỖI")
        }
    }
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
            return datasForecast.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weatherSection = WeatherLongDay(rawValue: indexPath.section)
        switch weatherSection {
        case.dates:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DatesTableViewCell", for: indexPath) as! DatesTableViewCell
            cell.bindData(dates: dates, selectedDateIndex: selectedDateIndex) { index in
                self.selectedDateIndex = index
                tableView.reloadData()
            }
            return cell
        case.datasForecast:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherByDayTableViewCell", for: indexPath) as! WeatherByDayTableViewCell
            cell.updateValue1231(datasForecast: datasForecast[indexPath.row])
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
    
}
