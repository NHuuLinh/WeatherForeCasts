import UIKit
import CoreLocation
import Alamofire
import FirebaseAuth

class MainViewController: UIViewController {
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var blurMenuView: UIView!
    @IBOutlet weak var openMenuBtn: UIButton!
    @IBOutlet weak var menuViewWidth: NSLayoutConstraint!
    @IBOutlet weak var menuViewLocation: NSLayoutConstraint!
    @IBOutlet weak var locationNameLb: UILabel!
    @IBOutlet weak var menuImage: UIImageView!
    private var isMenuOpen = false
    private var loadingTimer: Timer?
    private var isDataLoaded = false
    private var sections = [HomeNewsSection]()
    var weatherData: WeatherData24h?
    let locationManager = CLLocationManager()

    enum HomeNewsSection: Int {
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
        setupTableView()
        checkLocationAuthorizationStatus()
        print("view : \(view.frame.width)")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSideMenuViewController()
        tapGestureSetup()
        requestLocation()
        locationManager.delegate = self
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func MenuBtnHandle(_ sender: Any) {
        displayMenu()
    }
    @IBAction func locationBtn(_ sender: Any) {
        requestLocation()
        fetchWeatherDataForCurrentLocation()
        mainTableView.reloadData()
        print("requestLocation")
    }
    @IBAction func mapBtn(_ sender: Any) {
        goToMapsVC()
    }
}
// MARK: - Các hàm liên quan side Menu
extension MainViewController {
    // thêm tapGestureSetup cho blurview
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if isMenuOpen {
            displayMenu()
        }
        print(isMenuOpen)
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
            case .settings :
                print("settings")
                goToSettingVC()
            case .notification :
                print("notification")
            case .aboutUs :
                print("aboutUs")
            case .privatePolicy :
                print("privatePolicy")
            case .termsOfUse :
                print("termsOfUse")
            case .logout :
                logoutHandle()
                print("logout")
            }
        }
    //logout firebase
    private func logoutHandle() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            if firebaseAuth.currentUser == nil {
                print("Error: User nil")
                AppDelegate.scene?.goToLogin()
            } else {
                print("Error: User is still signed in")
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
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
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: mainTableView.frame.size.width, height: 10))
        headerView.backgroundColor = .green
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
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
                //                cell.goTodailyForecastVC = { [weak self] in
                //                        self?.goTodailyForecastVC()
                //                    }
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
            if let forecastAstro = weatherData?.forecast.forecastday[indexPath.row] {
                cell.getAstroData(with: forecastAstro)
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
            goTodailyForecastVC()
        default:
            return
        }
    }
}
// MARK: - Các hàm chuyển màn hình
extension MainViewController {
    private func goToProfileVC() {
        NavigationHelper.navigateToViewController(from: self, withIdentifier: "ProfileViewController")
    }
    private func goToForecast14DaysVC() {
        NavigationHelper.navigateToViewController(from: self, withIdentifier: "WeatherLongDayViewController") { viewcontroller in
            if let weatherLongDayVC = viewcontroller as? WeatherLongDayViewController {
                weatherLongDayVC.weatherData = self.weatherData
            }
        }
    }
    private func goToMapsVC() {
        NavigationHelper.navigateToViewController(from: self, withIdentifier: "MapsViewController") { viewcontroller in
            if let mapsVC = viewcontroller as? MapsViewController {
                mapsVC.delegate = self
            }
        }
    }
    private func goTodailyForecastVC() {
        NavigationHelper.navigateToViewController(from: self, withIdentifier: "DailyForecastViewController")
    }
    private func goToSettingVC(){
        NavigationHelper.navigateToViewController(from: self, withIdentifier: "SetingViewController")
    }
}
// MARK: - Các hàm liên quan vị trí
extension MainViewController : CLLocationManagerDelegate {
    func checkLocationAuthorizationStatus() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            // Yêu cầu quyền sử dụng vị trí khi ứng dụng đang được sử dụng
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            showAlert(title: "Ok", message: "Please allow to use location")
            break
        case .authorizedWhenInUse, .authorizedAlways:
            // Bắt đầu cập nhật vị trí và gọi api nếu được cấp quyền
            locationManager.startUpdatingLocation()
            fetchWeatherDataForCurrentLocation()
        @unknown default:
            break
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Kiểm tra lại trạng thái ủy quyền khi nó thay đổi
        checkLocationAuthorizationStatus()
    }
    func requestLocation() {
        // đưa nó vào một luồng khác để tránh làm màn hình người dùng đơ
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                // khai báo delegate để nhận thông tin thay đổi trạng thái vị trí
                self.locationManager.delegate = self
                // yêu cầu độ chính xác khi dò vi trí
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                // update vị trí cho các hàm của CLLocationManager
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    private func fetchWeatherDataForCurrentLocation() {
        // Bắt đầu hẹn giờ 20 giây
        loadingTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(handleLoadingTimeout), userInfo: nil, repeats: false)
        showLoading(isShow: true)
        // check xem có đia điểm hiện tại không,nếu không thì không làm gì cả
        guard let currentLocation = locationManager.location else {
            print("Current location not available.")
            handleLoadingError()
            return
        }

        let geocoder = CLGeocoder()
        // lấy placemark
        geocoder.reverseGeocodeLocation(currentLocation) { [weak self] (placemarks, error) in
            if let error = error {
                print("Reverse geocoding failed: \(error.localizedDescription)")
                self?.handleLoadingError()
                return
            }

            // lấy tên thành phố, đất nước
            if let placemark = placemarks?.first {
                let province = placemark.administrativeArea ?? ""
                let country = placemark.country ?? ""
                let address = "\(province), \(country)"
                print("Đã chọn địa điểm: \(address)")
                self?.locationNameLb.text = address

                // Fetch weather data using the current location
                WeatherAPIManager1.shared.fetchWeatherData(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude) { [weak self] weatherData in
                    //đảm bảo rằng self vẫn tồn tại trước khi sử dụng nó bên trong closure
                    guard let self = self else { return }

                    // Hủy hẹn giờ vì đã có dữ liệu
                    self.loadingTimer?.invalidate()
                    self.loadingTimer = nil
                    // chạy các tác vụ ưu tiên trên luồng chính, tránh lag  giao diện
                    DispatchQueue.main.async {
                        guard let weatherData = weatherData else {
                            print("Failed to fetch weather data")
                            self.handleLoadingError()
                            return
                        }
                        DispatchQueue.main.async {
                            self.weatherData = weatherData
                            self.mainTableView.reloadData()
                        }
                        self.isDataLoaded = true
                        self.showLoading(isShow: false)
                    }
                }
            }
        }
    }
    @objc private func handleLoadingTimeout() {
        // Hủy hẹn giờ và hiển thị cảnh báo khi lấy dữ liệu quá thời gian
        loadingTimer?.invalidate()
        loadingTimer = nil
        let title = NSLocalizedString("Error", comment: "")
        let message = NSLocalizedString("Failed to fetch weather data. Please try again.", comment: "")
        showAlert(title: title, message: message )
        showLoading(isShow: false)
    }

    private func handleLoadingError() {
        // Hủy hẹn giờ và hiển thị cảnh báo khi có lỗi trong quá trình lấy dữ liệu
        loadingTimer?.invalidate()
        loadingTimer = nil
        let title = NSLocalizedString("Error", comment: "")
        let message = NSLocalizedString("Please allow to use location.", comment: "")
        showAlert(title: title, message: message)
        showLoading(isShow: false)
    }
}
// MARK: - Call API sau khi chọn địa điểm
extension MainViewController: MapsViewControllerDelegate {
     func didPickLocation(_ location: CLLocationCoordinate2D,
                          address: String) {
        showLoading(isShow: true)
        WeatherAPIManager1.shared.fetchWeatherData(latitude: location.latitude, longitude: location.longitude) { [weak self] weatherData in
                guard let self = self else { return }
                    DispatchQueue.main.async {
                        guard let weatherData = weatherData else {
                            print("Failed to fetch weather data")
                            return
                        }
                        DispatchQueue.main.async {
                            self.weatherData = weatherData
                            self.locationNameLb.text = address
                            self.mainTableView.reloadData()
                        }
                    }
                    self.showLoading(isShow: false)
                }
            }
        }
