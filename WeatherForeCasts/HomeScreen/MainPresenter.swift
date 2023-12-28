//
//  MainPresenter.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 27/12/2023.
//

import Foundation
import CoreLocation

protocol MainPresenter:AnyObject {
    func fetchWeatherDataForCurrentLocation()
    func test()
    func fetchWeatherData()
}
class MainPresenterImpl: MainPresenter{
    
    weak var mainVC: MainViewControllerDisplay?
    private var loadingTimer: Timer?
    let locationManager = CLLocationManager()
    private var isDataLoaded = false
    weak var mapsVC: MapsViewControllerDelegate?
    
    init(mainVC: MainViewControllerDisplay? = nil, loadingTimer: Timer? = nil, isDataLoaded: Bool = false, mapsVC: MapsViewControllerDelegate? = nil) {
        self.mainVC = mainVC
        self.loadingTimer = loadingTimer
        self.isDataLoaded = isDataLoaded
        self.mapsVC = mapsVC
    }
    func test(){
        print("test ok")
    }
    func fetchWeatherDataForCurrentLocation() {
        // Bắt đầu hẹn giờ 20 giây
        loadingTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(handleLoadingTimeout), userInfo: nil, repeats: false)
        mainVC?.showLoading(isShow: true)
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
//                self?.mainVC.locationNameLb.text = address
                UserDefaults.standard.set(address, forKey: "locationAddress")
                UserDefaults.standard.set(currentLocation.coordinate.latitude, forKey: "locationLatitude")
                UserDefaults.standard.set(currentLocation.coordinate.longitude, forKey: "locationLongitude")
                print("currentLocation.coordinate.latitude: \(currentLocation.coordinate.latitude)")
                print("currentLocation.coordinate.longitude: \(currentLocation.coordinate.longitude)")

                // Fetch weather data using the current location
                WeatherAPIManager.shared.fetchWeatherData(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude) { [weak self] weatherData in
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
                            self.mainVC?.updateDataForCurrentLocation(with: weatherData, address: address)
//                            self.weatherData = weatherData
//                            self.mainVC.mainTableView.reloadData()
                        }
                        self.isDataLoaded = true
                        self.mainVC?.showLoading(isShow: false)
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
        mainVC?.showAlert(title: title, message: message )
        mainVC?.showLoading(isShow: false)
    }

    private func handleLoadingError() {
        // Hủy hẹn giờ và hiển thị cảnh báo khi có lỗi trong quá trình lấy dữ liệu
        loadingTimer?.invalidate()
        loadingTimer = nil
        let title = NSLocalizedString("Error", comment: "")
        let message = NSLocalizedString("Please allow to use location.", comment: "")
        mainVC?.showAlert(title: title, message: message)
        mainVC?.showLoading(isShow: false)
    }

     func fetchWeatherData() {
         print("fetchWeatherDataHead")

        // Bắt đầu hẹn giờ 20 giây
        loadingTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(handleLoadingTimeout), userInfo: nil, repeats: false)
         mainVC?.showLoading(isShow: true)
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
                var address: String?
                if UserDefaults.standard.string(forKey: "locationAddress") == "" {
                    address = "\(province), \(country)"
                } else {
                    address = UserDefaults.standard.string(forKey: "locationAddress")
                }
                print("Đã chọn địa điểm: \(address)")
                var latitude = UserDefaults.standard.double(forKey: "locationLatitude")
                var longitude = UserDefaults.standard.double(forKey: "locationLongitude")
                if latitude == 0.0 || longitude == 0.0 {
                     latitude = currentLocation.coordinate.latitude
                     longitude = currentLocation.coordinate.longitude
                }

                // Fetch weather data using the current location
                WeatherAPIManager.shared.fetchWeatherData(latitude: latitude , longitude: longitude ) { [weak self] weatherData in
                    print("longitude: \(longitude)")
                    print("latitude: \(latitude)")
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
                            self.mainVC?.updateDataForCurrentLocation(with: weatherData, address: address)
                            print("fetchWeatherDataTail")
                        }
                        self.isDataLoaded = true
                        self.mainVC?.showLoading(isShow: false)
                    }
                }
            }
        }
    }
}
