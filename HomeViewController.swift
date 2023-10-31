import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import Kingfisher



//struct Weather {
//    let time: String
//    let temperature: Double
//    let rainChance: Int
//    let icon: String
//}

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var testLB: UILabel!
    @IBOutlet weak var localTime: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var currentConditionText: UILabel!
    @IBOutlet weak var currentFeelsLikeTemp: UILabel!
    @IBOutlet weak var willItRain: UILabel!
    var weatherData = [Weather]()
    let apiKey = "e683110b37024f1f8c332826232410"
    let baseURL = "http://api.weatherapi.com/v1/forecast.json"
    var imageUrlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createLayout()
        getWeatherData24h()
    }

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 80, height: 220)
        return layout
    }
    func getWeatherData24h() {
        let parameters: [String: Any] = [
            "key": apiKey,
            "q": "Hanoi",
            "days": 1,
            "lang": "vn"
        ]
        
        AF.request(baseURL, method: .get, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: value)
                    let forecast24h = try JSONDecoder().decode(WeatherData24h.self, from: jsonData)
                    self.weatherData = forecast24h.forecast.forecastday[0].hour.map { hourlyData in
                        print(time)

                        return Weather(
                            time: hourlyData.time,
                            temperature: hourlyData.tempC,
                            rainChance: hourlyData.chanceOfRain,
                            icon: hourlyData.condition.icon
                        )
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.localTime.text = forecast24h.location.localtime
                        self.currentTemp.text = "\(forecast24h.current.tempC)°C"
                        self.currentConditionText.text = forecast24h.current.condition.text
                        self.currentFeelsLikeTemp.text = "\(forecast24h.current.feelslikeC)°C"
                        let willItRainValue = forecast24h.forecast.forecastday[0].hour[0].willItRain
                        self.willItRain.text = (willItRainValue == 1) ? "Có mưa trong 120 phút" : "Không có mưa trong 120 phút"
                    }
                } catch {
                    print("JSON parsing error: \(error)")
                }
            case .failure(let error):
                print("Network request error: \(error)")
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
        
        let fullTime = weatherData[indexPath.row].time
        let index = fullTime.index(fullTime.startIndex, offsetBy: 11)
        let time = String(fullTime.suffix(from: index))
        cell.timeLabel.text = time
        cell.temperatureLabel.text = "\(weatherData[indexPath.row].temperature)°C"
        cell.precipitationLabel.text = "\(weatherData[indexPath.row].rainChance)%"
        let iconName = extractImageName(url: weatherData[indexPath.row].icon)
        cell.weatherIconImageView.image = UIImage(named: iconName)
        return cell
    }

    func extractImageName(url: String) -> String {
        let cleanedURL = url
            .replacingOccurrences(of: "//cdn.weatherapi.com/weather/64x64/", with: "")
            .replacingOccurrences(of: ".png", with: "")
            .replacingOccurrences(of: "/", with: "")
        return cleanedURL
    }
    
    @IBAction func testBtn(_ sender: UIButton) {
        let weatherLongDayVC = WeatherLongDayViewController() // Tạo một thể hiện của WeatherLongDayViewController
            self.navigationController?.pushViewController(weatherLongDayVC, animated: true) // Chuyển sang màn hình WeatherLongDayViewController
        print("go to WeatherLongDayViewController ")
    }
}
