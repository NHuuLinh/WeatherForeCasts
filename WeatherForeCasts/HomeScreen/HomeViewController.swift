import UIKit
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController {
    @IBOutlet weak var daiLyCollectionView: UICollectionView!
    @IBOutlet weak var testLB: UILabel!
    @IBOutlet weak var localTime: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var currentConditionText: UILabel!
    @IBOutlet weak var currentFeelsLikeTemp: UILabel!
    @IBOutlet weak var willItRain: UILabel!
    @IBOutlet weak var WeeklyCollectionView: UICollectionView!
    private var data24h = [Hour]()
    private var weeklyDatas = [Forecastday]()
    private var sections = [HomeNewsSection]()
    enum HomeNewsSection: Int {
        case weeklyDatas = 0
        case data24h
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        daiLyCollectionView.collectionViewLayout = createLayout()
        getWeatherData()
        registerCells()
//        getWeatherData1()
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 80, height: 220)
        return layout
    }
    private func registerCells() {
        daiLyCollectionView.register(UINib(nibName: DailyCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: DailyCollectionViewCell.identifier)
        WeeklyCollectionView.register(UINib(nibName: WeeklyWeatherCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: WeeklyWeatherCollectionViewCell.identifier)
    }
    
    func getWeatherData() {
        APIClient.shared.getWeatherData { result in
            switch result {
            case .success(let weatherData):
                let datas = weatherData.forecast.forecastday
                self.weeklyDatas = datas
                self.WeeklyCollectionView.reloadData()
            case .failure(let error):
                print("API error: \(error)")
            }
        }
    }
    func getWeatherData1() {
        APIClient2.shared.getWeatherData { result in
            switch result {
            case .success(let weatherData):
                let data24h = weatherData.hour
                self.data24h = data24h
                self.daiLyCollectionView.reloadData()
            case .failure(let error):
                print("API error: \(error)")
            }
        }
    }
    
}
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let homeSection = HomeNewsSection(rawValue: section)
        switch collectionView {
        case WeeklyCollectionView:
            return data24h.count
        case daiLyCollectionView:
            return weeklyDatas.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case WeeklyCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyWeatherCollectionViewCell.identifier, for: indexPath) as! WeeklyWeatherCollectionViewCell
            cell.getWeeklyDatas(weeklyDatas: weeklyDatas[indexPath.row])
            return cell
        case daiLyCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyCollectionViewCell.identifier, for: indexPath) as! DailyCollectionViewCell
            cell.getData24h(data24h: data24h[indexPath.row])
            return cell
        default: return UICollectionViewCell()
        }
    }

}
