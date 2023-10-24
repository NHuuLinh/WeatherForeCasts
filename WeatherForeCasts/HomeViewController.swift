//
//  HomeViewController.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 14/10/2023.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Weather {
    let time: String
    let temperature: String
    let rainChance: String
    let icon: String
}


class HomeViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate  {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var testLB: UILabel!
    var weatherData = [Weather]()
    let apiKey = "e683110b37024f1f8c332826232410"

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        getWeatherData()
    }

    func getWeatherData() {
        let url = "http://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=Hanoi&days=1&hourly=1"

        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let forecast = json["forecast"]["forecastday"][0]["hour"]

                for i in 0..<forecast.count {
                    let time = forecast[i]["time"].stringValue
                    let temp = forecast[i]["temp_c"].stringValue
                    let rain = forecast[i]["chance_of_rain"].stringValue
                    let icon = forecast[i]["condition"]["icon"].stringValue
                    self.weatherData.append(Weather(time: time, temperature: temp, rainChance: rain, icon: icon))
                    print("success")
                }
                

                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherData.count
//        return 12
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(UINib(nibName: "Weather24hCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Weather24hCollectionViewCell")

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Weather24hCollectionViewCell", for: indexPath) as! Weather24hCollectionViewCell

//        let c = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
//        categoriesCollectionView.register(nib, forCellWithReuseIdentifier: "CategoryCollectionViewCell")


        cell.timeLabel.text = weatherData[indexPath.row].time
        cell.temperatureLabel.text = weatherData[indexPath.row].temperature + "°C"
        cell.precipitationLabel.text = weatherData[indexPath.row].rainChance + "%"
        cell.weatherIconImageView.image = UIImage(named: weatherData[indexPath.row].icon)
        print(cell.timeLabel.text ?? "")
        print(cell.temperatureLabel.text ?? "")
        return cell
    }

}
