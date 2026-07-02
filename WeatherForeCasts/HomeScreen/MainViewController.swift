import UIKit
import CoreLocation
import Combine
//import Alamofire

protocol MainViewControllerDisplay: UIViewController {
    func updateDataForCurrentLocation(with weatherData: WeatherData24h,address: String? )
    func goToMapsVC()
    func updateInternetView()
}
enum HomeNewsSection: Int,CaseIterable {
    case currentCell = 0
    case dailyCell
    case weeklyCell
    case otherCell
    case aqiCell
    case astroCell
    case adviceCell
}

class MainViewController: UIViewController {
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
    
    
    private let viewModel = MainViewModel()
    private let navigation = AppCoordinator.shared
    private var isMenuOpen = false
    private var cancellables = Set<AnyCancellable>()
    private var refeshControl = UIRefreshControl()
    
    enum HomeNewsSection: Int, CaseIterable {
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
        NetworkMonitor.shared.startMonitoring()
        setupTableView()
        handleObserve()
        viewModel.checkLocationAuthorizationStatus()
        pullToRefesh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSideMenuViewController()
        tapGestureSetup()
        viewModel.requestLocation()
        navigationController?.isNavigationBarHidden = true
        nointernetLb.text = NSLocalizedString(nointernetLb.text ?? "", comment: "")
    }
    
    // MARK: - Combine Bindings
    func handleObserve() {
        viewModel.$weatherData
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.mainTableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$locationName
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] name in
                self?.locationNameLb.text = name
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.showLoading(isShow: isLoading)
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.showAlert(title: "Thông báo", message: message)
            }
            .store(in: &cancellables)
        
        viewModel.$shouldShowNoInternet
            .receive(on: DispatchQueue.main)
            .sink { [weak self] noInternet in
                self?.updateInternetView(isReachable: !noInternet)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - IBActions
    @IBAction func MenuBtnHandle(_ sender: Any) {
        displayMenu()
    }
    
    @IBAction func locationBtn(_ sender: Any) {
        viewModel.currentLocationBtnHandle()
    }
    
    @IBAction func mapBtn(_ sender: Any) {
        if viewModel.mapBtnHandle() {
            goToMapsVC()
        }
    }
    
    // MARK: - Internet View
    func updateInternetView(isReachable: Bool) {
        noInternetView.isHidden = isReachable
        noInternetViewConstraints.constant = isReachable ? -25 : 0
    }
}

// MARK: - Side Menu
extension MainViewController {
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if isMenuOpen { displayMenu() }
    }
    
    func tapGestureSetup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        blurMenuView.addGestureRecognizer(tapGesture)
    }
    
    private func addSideMenuViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let menuController = storyboard.instantiateViewController(
            identifier: "SideMenuViewController"
        ) as? SideMenuViewController else { return }
        
        menuController.onMenuItemSelected = { [weak self] menuItem in
            self?.handleMenuItemSelection(menuItem)
        }
        configureSideMenuView(menuController)
    }
    
    private func configureSideMenuView(_ menuController: SideMenuViewController) {
        menuController.view.frame = menuView.bounds
        menuView.addSubview(menuController.view)
        addChild(menuController)
        menuController.didMove(toParent: self)
        menuViewLocation.constant = -250
        blurMenuView.isHidden = true
        isMenuOpen = false
    }
    
    private func handleMenuItemSelection(_ menuItem: MenuItem) {
        switch menuItem.screen {
        case .profile:      goToProfileVC()
        case .settings:     goToSettingVC()
        case .logout:       viewModel.logoutHandle()
        default:            underDevelopment()
        }
    }
    
    private func displayMenu() {
        isMenuOpen.toggle()
        blurMenuView.alpha = isMenuOpen ? 0.5 : 0
        blurMenuView.isHidden = !isMenuOpen
        UIView.animate(withDuration: 0.2) {
            self.menuViewLocation.constant = self.isMenuOpen ? 0 : -250
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Navigation
extension MainViewController: MapsViewControllerDelegate {
    func loadDataAfterAuthorizationStatus() {
        //unknow ?
    }
    
    private func goToProfileVC() {
        navigation.navigateToVC(from: self, withIdentifier: .profileVC)
    }
    
    private func goToForecast14DaysVC() {
        navigation.navigateToVC(from: self, withIdentifier: .weatherLongDayVC) { [weak self] vc in
            if let weatherLongDayVC = vc as? WeatherLongDayViewController {
                weatherLongDayVC.weatherData = self?.viewModel.weatherData
            }
        }
    }
    
    func goToMapsVC() {
        navigation.navigateToVC(from: self, withIdentifier: .mapsVC) { [weak self] vc in
            if let mapsVC = vc as? MapsViewController {
                mapsVC.delegate = self
            }
        }
    }
    
    private func goToSettingVC() {
        navigation.navigateToVC(from: self, withIdentifier: .setingVC)
    }
    
    private func underDevelopment() {
        showAlert(
            title: NSLocalizedString("The feature is under development", comment: ""),
            message: NSLocalizedString("The feature is under development, please try again later.", comment: "")
        )
    }
    
    func updateDataForCurrentLocation(with weatherData: WeatherData24h, address: String?) {
        viewModel.weatherData = weatherData
        viewModel.locationName = address
    }
}

// MARK: - TableView
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    private func setupTableView() {
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.separatorStyle = .none
        mainTableView.sectionFooterHeight = 10
        
        [("DailyTableViewCell", "DailyTableViewCell"),
         ("WeeklyTableViewCell", "WeeklyTableViewCell"),
         ("OtherInformTableViewCell", "OtherInformTableViewCell"),
         ("AQITableViewCell", "AQITableViewCell"),
         ("AstroTableViewCell", "AstroTableViewCell"),
         ("CurrentWeatherTableViewCell", "CurrentWeatherTableViewCell"),
         ("WeatherAdviceTableViewCell", "WeatherAdviceTableViewCell")
        ].forEach { nibName, identifier in
            mainTableView.register(
                UINib(nibName: nibName, bundle: nil),
                forCellReuseIdentifier: identifier
            )
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        HomeNewsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { 10 }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = viewModel.weatherData
        switch HomeNewsSection(rawValue: indexPath.section) {
        case .currentCell:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "CurrentWeatherTableViewCell", for: indexPath
            ) as! CurrentWeatherTableViewCell
            if let data = data { cell.getCurrentData(with: data) }
            return cell
            
        case .dailyCell:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "DailyTableViewCell", for: indexPath
            ) as! DailyTableViewCell
            if let day1 = data?.forecast.forecastday[0],
               let day2 = data?.forecast.forecastday[1] {
                cell.getData24h(from: data?.location.localtime, with: day1.hour + day2.hour)
            }
            return cell
            
        case .weeklyCell:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "WeeklyTableViewCell", for: indexPath
            ) as! WeeklyTableViewCell
            if let forecastWeek = data?.forecast.forecastday {
                cell.getWeeklyDatas(with: forecastWeek)
                cell.goToForecast14Days = { [weak self] in
                    self?.goToForecast14DaysVC()
                }
            }
            return cell
            
        case .otherCell:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "OtherInformTableViewCell", for: indexPath
            ) as! OtherInformTableViewCell
            if let current = data?.current { cell.getOtherData(with: current) }
            return cell
            
        case .aqiCell:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "AQITableViewCell", for: indexPath
            ) as! AQITableViewCell
            if let aqi = data?.current.airQuality { cell.getAirData(with: aqi) }
            return cell
            
        case .astroCell:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "AstroTableViewCell", for: indexPath
            ) as! AstroTableViewCell
            if let time = data?.location.localtime,
               let astro = data?.forecast.forecastday[indexPath.row] {
                cell.getAstroData(with: astro, with: time)
            }
            return cell
            
        case .adviceCell:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "WeatherAdviceTableViewCell", for: indexPath
            ) as! WeatherAdviceTableViewCell
            if let advice = data?.forecast.forecastday[0] {
                cell.getAdviceData(data: advice)
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch HomeNewsSection(rawValue: indexPath.section) {
        case .aqiCell:
            print("aqiCell")
        default:
            break
        }
    }
}

// MARK: - Pull to Refresh
extension MainViewController {
    func pullToRefesh() {
        refeshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        mainTableView.addSubview(refeshControl)
    }
    
    @objc func reloadData() {
        viewModel.chooseDataToFetch()
        refeshControl.endRefreshing()
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


