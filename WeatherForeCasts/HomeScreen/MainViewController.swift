import UIKit
import CoreLocation
import Alamofire

protocol MainViewControllerDisplay: UIViewController {
    func updateDataForCurrentLocation(with weatherData: WeatherData24h,address: String? )
    func goToMapsVC()
    func updateInternetView()
}

class MainViewController: UIViewController,MainViewControllerDisplay {
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var blurMenuView: UIView!
    @IBOutlet weak var openMenuBtn: UIButton!
    @IBOutlet weak var menuViewWidth: NSLayoutConstraint!
    @IBOutlet weak var menuViewLocation: NSLayoutConstraint!
    @IBOutlet weak var locationNameLb: UILabel!
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var noInternetView: UIView!
    @IBOutlet weak var noInternetViewConstraints: NSLayoutConstraint!
    @IBOutlet weak var nointernetLb: UILabel!
    private let naviation = NavigationHelper.shared
    private let locationManager = CLLocationManager()
    private var isMenuOpen = false
    private var weatherData: WeatherData24h?
    private var mainPresenter: MainPresenter?
    private var sideMenuVC: SideMenuViewController?
    private var hasReachedEnd = false
    private var refeshControl = UIRefreshControl()
    
    enum HomeNewsSection: Int,CaseIterable {
        case currentCell = 0
        case dailyCell
        case weeklyCell
        case otherCell
        case aqiCell
        case astroCell
        case adviceCell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkMonitor.shared.mainVC = self
        mainPresenter = MainPresenterImpl(mainVC: self)
        setupTableView()
        updateInternetView()
        sideMenuVC?.loadDataFromFirebase()
        mainPresenter?.checkLocationAuthorizationStatus()
        pullToRefesh()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSideMenuViewController()
        tapGestureSetup()
        mainPresenter?.requestLocation()
        locationManager.delegate = self
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func MenuBtnHandle(_ sender: Any) {
        displayMenu()
    }
    @IBAction func locationBtn(_ sender: Any) {
        print("requestLocation")
        mainPresenter?.currentLocationBtnHandle()
        mainTableView.reloadData()
    }
    @IBAction func mapBtn(_ sender: Any) {
        mainPresenter?.mapBtnHandle()
    }
}
// MARK: - Các hàm liên quan side Menu
extension MainViewController {
    
    // thêm tapGestureSetup cho blurview
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let locationInView = sender.location(in: view)
        if isMenuOpen {
            displayMenu()
        }
    }
    
    func tapGestureSetup(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        blurMenuView.addGestureRecognizer(tapGesture)
    }
    
    // thêm subview
    private func addSideMenuViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let menuController = storyboard.instantiateViewController(identifier: "SideMenuViewController") as? SideMenuViewController else {
            return
        }
        menuController.onMenuItemSelected = { [weak self] menuItem in
            self?.handleMenuItemSelection(menuItem)
        }
        configureSideMenuView(menuController)
    }
    
    // cấu hình sidemenu
    private func configureSideMenuView(_ menuController: SideMenuViewController) {
        //Thiết lập kích thước và vị trí của Side Menu:
        menuController.view.frame = menuView.bounds
        //Thêm Side Menu vào menuView
        menuView.addSubview(menuController.view)
        //Thêm Side Menu vào Child View Controller:
        addChild(menuController)
        //Gọi để thông báo rằng side menu đã được thêm vào main view controller như là một child view controller.
        menuController.didMove(toParent: self)
        //setup vị trí
        menuViewLocation.constant = -250
        blurMenuView.isHidden = true
        isMenuOpen = false
    }
    // xử lí khi nhấn vào có ô trên menu
    private func handleMenuItemSelection(_ menuItem: MenuItem) {
        switch menuItem.screen {
        case .profile :
            print("profile")
            goToProfileVC()
        case .location :
            print("Location")
            self.underDevelopment()
        case .settings :
            print("settings")
            goToSettingVC()
        case .notification :
            self.underDevelopment()
            print("notification")
        case .aboutUs :
            self.underDevelopment()
            print("aboutUs")
        case .privatePolicy :
            self.underDevelopment()
            print("privatePolicy")
        case .termsOfUse :
            self.underDevelopment()
            print("termsOfUse")
        case .logout :
            mainPresenter?.logoutHandle()
            print("logout")
        }
    }
    
    // display menu
    private func displayMenu() {
        isMenuOpen.toggle()
        blurMenuView.alpha = isMenuOpen ? 0.5 : 0
        blurMenuView.isHidden = !isMenuOpen
        UIView.animate(withDuration: 0.2, animations: {
            self.menuViewLocation.constant = self.isMenuOpen ? 0 : -250
            self.view.layoutIfNeeded()
        })
    }
}
// MARK: - Các hàm liên quan TableVC
extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    private func setupTableView() {
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.separatorStyle = .none
        mainTableView.sectionFooterHeight = 10
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
        let adviceCell = UINib(nibName: "WeatherAdviceTableViewCell", bundle: nil)
        mainTableView.register(adviceCell, forCellReuseIdentifier: "WeatherAdviceTableViewCell")
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10 // Đặt khoảng cách giữa các section
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear // Đặt màu nền của footerInSection ở đây
        return footerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfCases = HomeNewsSection.allCases.count
        return numberOfCases
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
        case .adviceCell:
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
            if let forecastDay1 = weatherData?.forecast.forecastday[indexPath.row],
               let forecastDay2 = weatherData?.forecast.forecastday[indexPath.row + 1] {
                let forecastHours = forecastDay1.hour + forecastDay2.hour
                let currentTime = weatherData?.location.localtime
                cell.getData24h(from: currentTime, with: forecastHours)
            }
            return cell
        case.weeklyCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyTableViewCell", for: indexPath) as! WeeklyTableViewCell
            if let forecastWeek = weatherData?.forecast.forecastday {
                cell.getWeeklyDatas(with: forecastWeek)
                cell.goToForecast14Days = { [weak self] in
                    self?.goToForecast14DaysVC()
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
            if let currentTime = weatherData?.location.localtime, let forecastAstro = weatherData?.forecast.forecastday[indexPath.row] {
                cell.getAstroData(with: forecastAstro, with: currentTime)
            }
            return cell
        case.adviceCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherAdviceTableViewCell", for: indexPath) as! WeatherAdviceTableViewCell
            if let forecastAdvice = weatherData?.forecast.forecastday[0] {
                cell.getAdviceData(data: forecastAdvice)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let homeSection = HomeNewsSection(rawValue: indexPath.section)
        switch homeSection {
        case.aqiCell:
            print("aqiCell")
        default:
            return
        }
    }
}
// MARK: - Các hàm chuyển màn hình
extension MainViewController: MapsViewControllerDelegate {
    private func goToProfileVC() {
        naviation.navigateToViewController(from: self, withIdentifier: "ProfileViewController")
    }
    private func goToForecast14DaysVC() {
        naviation.navigateToViewController(from: self, withIdentifier: "WeatherLongDayViewController") { viewcontroller in
            if let weatherLongDayVC = viewcontroller as? WeatherLongDayViewController {
                weatherLongDayVC.weatherData = self.weatherData
            }
        }
    }
    func goToMapsVC() {
        naviation.navigateToViewController(from: self, withIdentifier: "MapsViewController") { viewcontroller in
            if let mapsVC = viewcontroller as? MapsViewController {
                mapsVC.delegate = self
            }
        }
    }
    private func goTodailyForecastVC() {
        naviation.navigateToViewController(from: self, withIdentifier: "DailyForecastViewController")
    }
    private func goToSettingVC(){
        naviation.navigateToViewController(from: self, withIdentifier: "SetingViewController")
    }
    private func underDevelopment(){
        let title = NSLocalizedString("The feature is under development", comment: "")
        let message = NSLocalizedString("The feature is under development, please try again later.", comment: "")
        showAlert(title: title, message: message)
    }
}
// MARK: - Các hàm dể load data
extension MainViewController : CLLocationManagerDelegate {
    // sử dụng để load lại data sau khi chọn địa điểm trên maps
    func loadDataAfterAuthorizationStatus(){
        print("loadDataAfterAuthorizationStatus")
        mainPresenter?.checkLocationAuthorizationStatus()
    }
    
    func updateDataForCurrentLocation(with weatherData: WeatherData24h,address: String? ){
        self.weatherData = weatherData
        self.locationNameLb.text = address
        self.mainTableView.reloadData()
    }
}
extension MainViewController: UIScrollViewDelegate {
    func pullToRefesh(){
        refeshControl.addTarget(self, action: #selector(reloadData), for: UIControl.Event.valueChanged)
        mainTableView.addSubview(refeshControl)
        nointernetLb.text = NSLocalizedString(nointernetLb.text ?? "", comment: "")
    }
    @objc func reloadData(send: UIRefreshControl){
        DispatchQueue.main.async {
            self.mainPresenter?.chooseDataToFetch()
            print("đã scroll hết")
            self.refeshControl.endRefreshing()
        }
    }
}
// MARK: - Các hàm xử lí liên quan đến kết nối internet
extension MainViewController {
    // Khi có thay đổi trạng thái mạng, bạn có thể gọi hàm này để cập nhật UIView
    func handleNetworkStatusChange(isReachable: Bool) {
        // Xử lý sự thay đổi trạng thái mạng tại đây
        updateInternetView()
    }
    func updateInternetView() {
        print("updateInternetView")

        if NetworkMonitor.shared.isReachable {
            DispatchQueue.main.async {
                self.noInternetView.isHidden = true
                self.noInternetViewConstraints.constant = -25
            }
        } else {
            DispatchQueue.main.async {
                self.noInternetView.isHidden = false
                self.noInternetViewConstraints.constant = 0
            }
        }
    }
}


