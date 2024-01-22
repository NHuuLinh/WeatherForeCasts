//
//  DailyForecastViewController.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 21/11/2023.
//

import UIKit

class DailyForecastViewController: UIViewController, DateConvertFormat {
    @IBOutlet weak var dailyForecastTableView: UITableView!
    @IBOutlet weak var dayForecastLb: UILabel!
    var weatherData24h: Forecastday?
    var dayForecast : Int?
    @IBOutlet weak var mainTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        dayForecastLb.text = convertDate(date: weatherData24h?.date ?? "0", inputFormat: "yyyy-MM-dd", outputFormat: "EEE dd/MM")
        mainTitle.text = NSLocalizedString(mainTitle.text ?? "" , comment: "")
            dailyForecastTableView.reloadData()
    }
    private func registerCell() {
        let cell = UINib(nibName: "DailyForecastTableViewCell", bundle: nil)
        dailyForecastTableView.register(cell, forCellReuseIdentifier: "DailyForecastTableViewCell")
        dailyForecastTableView.dataSource = self
        dailyForecastTableView.delegate = self
    }
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

