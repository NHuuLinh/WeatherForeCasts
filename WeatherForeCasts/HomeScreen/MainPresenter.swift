
import Foundation
import CoreLocation
import CoreData
import FirebaseAuth

protocol MainPresenter:AnyObject {
    func fetchWeatherData()
    func chooseDataToFetch()
    func currentLocationBtnHandle()
    func mapBtnHandle()
    func requestLocation()
    func checkLocationAuthorizationStatus()
    func logoutHandle()
}

class MainPresenterImpl: NSObject, MainPresenter, CLLocationManagerDelegate{
    weak var mainVC: MainViewControllerDisplay?
    weak var mapsVC: MapsViewControllerDelegate?
    let locationManager = CLLocationManager()
    let isReachable = NetworkMonitor.shared.isReachable
    let coreData = CoreDataHelper.share
    private var isDataLoaded = false
    
    init(mainVC: MainViewControllerDisplay? = nil, isDataLoaded: Bool = false, mapsVC: MapsViewControllerDelegate? = nil) {
        self.mainVC = mainVC
        self.isDataLoaded = isDataLoaded
        self.mapsVC = mapsVC
    }
    func fetchWeatherDataForCurrentLocation() {
        // Bắt đầu hẹn giờ 40 giây
        mainVC?.showLoading(isShow: true)
        // check xem có đia điểm hiện tại không,nếu không thì không làm gì cả
        guard let currentLocation = locationManager.location else {
            print("Current location not available.")
            return
        }
        let geocoder = CLGeocoder()
        // lấy placemark
        geocoder.reverseGeocodeLocation(currentLocation) { [weak self] (placemarks, error) in
            if let error = error {
                print("Reverse geocoding failed: \(error.localizedDescription)")
                return
            }
            let longitude = currentLocation.coordinate.longitude
            let latitude = currentLocation.coordinate.latitude
            
            // lấy tên thành phố, đất nước
            if let placemark = placemarks?.first {
                let province = placemark.administrativeArea ?? ""
                let country = placemark.country ?? ""
                let address = "\(province), \(country)"
                print("Đã chọn địa điểm: \(address)")
                // Fetch weather data using the current location
                CoreDataHelper.share.saveLocationValueToCoreData(address: address, longitude: longitude, latitude: latitude)
                UserDefaults.standard.didOnMain = true
                WeatherAPIManager.shared.fetchWeatherData(latitude: latitude, longitude: longitude) { [weak self] weatherData in
                    //đảm bảo rằng self vẫn tồn tại trước khi sử dụng nó bên trong closure
                    guard let self = self else { return }
                    
                    // chạy các tác vụ ưu tiên trên luồng chính, tránh lag  giao diện
                    DispatchQueue.main.async {
                        guard let weatherData = weatherData else {
                            print("Failed to fetch weather data")
                            return
                        }
                        DispatchQueue.main.async {
                            self.mainVC?.updateDataForCurrentLocation(with: weatherData, address: address)
                            CoreDataHelper.share.saveWeatherData(weatherData)
                        }
                        self.isDataLoaded = true
                        self.mainVC?.showLoading(isShow: false)
                    }
                }
            }
        }
    }
    
    func fetchWeatherData() {
        mainVC?.showLoading(isShow: true)
        // check xem có đia điểm hiện tại không,nếu không thì không làm gì cả
        guard let currentLocation = locationManager.location else {
            print("Current location not available.")
            return
        }
        let latitude = CoreDataHelper.share.getLocationValueFromCoreData(key: "latitude") as? Double ?? 0
        let longitude = CoreDataHelper.share.getLocationValueFromCoreData(key: "longitude") as? Double ?? 0
        let address = CoreDataHelper.share.getLocationValueFromCoreData(key: "address") as? String ?? "error"
        
        // Fetch weather data using the current location
        WeatherAPIManager.shared.fetchWeatherData(latitude: latitude , longitude: longitude ) { [weak self] weatherData in
            //đảm bảo rằng self vẫn tồn tại trước khi sử dụng nó bên trong closure
            guard let self = self else { return }
            
            // chạy các tác vụ ưu tiên trên luồng chính, tránh lag  giao diện
            DispatchQueue.main.async {
                guard let weatherData = weatherData else {
                    print("Failed to fetch weather data")
                    return
                }
                DispatchQueue.main.async {
                    self.mainVC?.updateDataForCurrentLocation(with: weatherData, address: address)
                    CoreDataHelper.share.saveWeatherData(weatherData)
                }
                self.isDataLoaded = true
                self.mainVC?.showLoading(isShow: false)
            }
        }
    }
    func updateDataFormCoreData(){
        guard let weatherData = CoreDataHelper.share.fetchWeatherData() else { return }
        let address = CoreDataHelper.share.getLocationValueFromCoreData(key: "address") as? String ?? "error"
        self.mainVC?.updateDataForCurrentLocation(with: weatherData, address: address)
    }
    func chooseDataToFetch(){
        if UserDefaults.standard.didGetData && !isReachable {
            updateDataFormCoreData()
        } else {
            if UserDefaults.standard.didOnMain {
                fetchWeatherData()
            } else {
                fetchWeatherDataForCurrentLocation()
            }
        }
    }
}
// MARK: - Các hàm xử lí nút nhấn màn hình home
extension MainPresenterImpl {
    func noInternetWarning(){
        self.mainVC?.showAlert(title: NSLocalizedString("No internet connection", comment: ""), message: NSLocalizedString("Please check internet connection and retry again", comment: ""))
    }
    func mapBtnHandle(){
        if isReachable {
            self.mainVC?.goToMapsVC()
        } else {
            noInternetWarning()
        }
    }
    
    func logoutHandle() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            coreData.deleteProfileValue()
            coreData.deleteWeatherValue()
            coreData.deleteLocationValue()
            coreData.saveValue()
            UserDefaults.standard.didOnMain = false

            if firebaseAuth.currentUser == nil {
                if isReachable {
                    AppDelegate.scene?.goToLogin()
                } else {
                    AppDelegate.scene?.routeToNoInternetAccess()
                }
            }  else {
                print("Error: User is still signed in")
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    func currentLocationBtnHandle(){
        if isReachable {
            self.requestLocation()
            self.fetchWeatherDataForCurrentLocation()
        } else {
            noInternetWarning()
        }
    }
}
// MARK: - Các hàm liên quan vị trí
extension MainPresenterImpl {
    func requestLocation() {
        print("requestLocation")
        
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
    func checkLocationAuthorizationStatus() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            // Yêu cầu quyền sử dụng vị trí khi ứng dụng đang được sử dụng
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            self.mainVC?.showAlert(title: "Ok", message: "Please allow to use location")
            break
        case .authorizedWhenInUse, .authorizedAlways:
            // Bắt đầu cập nhật vị trí và gọi api nếu được cấp quyền
            locationManager.startUpdatingLocation()
            chooseDataToFetch()
        @unknown default:
            break
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Kiểm tra lại trạng thái ủy quyền khi nó thay đổi
        checkLocationAuthorizationStatus()
    }
}
