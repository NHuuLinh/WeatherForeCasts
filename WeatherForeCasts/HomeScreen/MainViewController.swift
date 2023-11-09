import UIKit
import Alamofire

class MainViewController: UIViewController {
    @IBOutlet weak var mainTableView: UITableView!
    private var sections = [HomeNewsSection]()
    var weatherData: WeatherData24h?
    enum HomeNewsSection: Int {
        case currentCell = 0
        case dailyCell
        case weeklyCell
        case otherCell
        case aqiCell
        case astroCell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getweatherData()
    }
    private func setupTableView() {
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.separatorStyle = .none
        let dailyCell = UINib(nibName: "DailyTableViewCell", bundle: nil)
        mainTableView.register(dailyCell, forCellReuseIdentifier: "DailyTableViewCell")
        let weeklyCell = UINib(nibName: "WeeklyTableViewCell", bundle: nil)
        mainTableView.register(weeklyCell, forCellReuseIdentifier: "WeeklyTableViewCell")
        let otherCell = UINib(nibName: "OtherInformTableViewCell", bundle: nil)
        mainTableView.register(otherCell, forCellReuseIdentifier: "OtherInformTableViewCell")
        let aqiCell = UINib(nibName: "AQITableViewCell", bundle: nil)
        mainTableView.register(aqiCell, forCellReuseIdentifier: "AQITableViewCell")
        let astroCell = UINib(nibName: "AstroTableViewCell", bundle: nil)
        mainTableView.register(astroCell, forCellReuseIdentifier: "AstroTableViewCell")
        let currentCell = UINib(nibName: "CurrentWeatherTableViewCell", bundle: nil)
        mainTableView.register(currentCell, forCellReuseIdentifier: "CurrentWeatherTableViewCell")
    }
    func getweatherData() {
        APIManager.shared.fetchWeatherData { weatherData in
            guard let weatherData = weatherData else {
                print("Failed to fetch weather data")
                return
            }
            self.weatherData = weatherData
            self.mainTableView.reloadData()
        }
    }
}

extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: mainTableView.frame.size.width, height: 10))
        headerView.backgroundColor = .green
        //        headerView.backgroundColor = UIColor(red: 0.28, green: 0.29, blue: 0.36, alpha: 1.00)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let homeSection = HomeNewsSection(rawValue: section)
        switch homeSection {
        case .currentCell:
            return 1
        case .dailyCell:
            return 1
        case .weeklyCell :
            return 1
        case .otherCell:
            return 1
        case .aqiCell:
            return 1
        case .astroCell:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let homeSection = HomeNewsSection(rawValue: indexPath.section)
        switch homeSection {
        case.currentCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentWeatherTableViewCell", for: indexPath) as! CurrentWeatherTableViewCell
            if let forecastCurrent = weatherData {
                cell.getCurrentData(with: forecastCurrent)
            }
            return cell
        case.dailyCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyTableViewCell", for: indexPath) as! DailyTableViewCell
            if let forecastDay = weatherData?.forecast.forecastday[indexPath.row] {
                cell.getData24h(with: forecastDay)
            }
            return cell
        case.weeklyCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyTableViewCell", for: indexPath) as! WeeklyTableViewCell
            if let forecastWeek = weatherData?.forecast.forecastday {
                cell.getWeeklyDatas(with: forecastWeek)
                cell.goToForecast14Days = {
                    self.goToForCast14DaysVC()
                    }
            }
            return cell
        case.otherCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OtherInformTableViewCell", for: indexPath) as! OtherInformTableViewCell
            if let forecastOther = weatherData?.current {
                cell.getOtherData(with: forecastOther)
            }
            return cell
        case.aqiCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AQITableViewCell", for: indexPath) as! AQITableViewCell
            if let forecastAqi = weatherData?.current.airQuality {
                cell.getAirData(with: forecastAqi)
            }
            return cell
        case.astroCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AstroTableViewCell", for: indexPath) as! AstroTableViewCell
            if let forecastAstro = weatherData?.forecast.forecastday[indexPath.row] {
                cell.getAstroData(with: forecastAstro)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    func goToForCast14DaysVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let Weather14DayVC = storyboard.instantiateViewController(withIdentifier: "WeatherLongDayViewController") as! WeatherLongDayViewController
        navigationController?.pushViewController(Weather14DayVC, animated: true)
        print("1111")
    }
}
