//
//  MainPresenter.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 27/12/2023.
//

import Foundation
import CoreLocation
import UIKit
import CoreData

protocol MainPresenter:AnyObject {
    func fetchWeatherDataForCurrentLocation()
    func test()
    func fetchWeatherData()
    func chooseDataToFetch()
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
                            CoreDataHelper.share.saveWeatherData(weatherData)
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
        // Bắt đầu hẹn giờ 20 giây
        loadingTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(handleLoadingTimeout), userInfo: nil, repeats: false)
        mainVC?.showLoading(isShow: true)
        // check xem có đia điểm hiện tại không,nếu không thì không làm gì cả
        guard let currentLocation = locationManager.location else {
            print("Current location not available.")
            handleLoadingError()
            return
        }
        let latitude = CoreDataHelper.share.getLocationValueFromCoreData(key: "latitude") as? Double ?? 0
        let longitude = CoreDataHelper.share.getLocationValueFromCoreData(key: "longitude") as? Double ?? 0
        let address = CoreDataHelper.share.getLocationValueFromCoreData(key: "address") as? String ?? "error"
        
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
//        if UserDefaults.standard.didGetData {
//            updateDataFormCoreData()
//        } else {
            if UserDefaults.standard.didOnMain {
                fetchWeatherData()
                print("true")
            } else {
                fetchWeatherDataForCurrentLocation()
                print("false")
            }
        }
//    }
}
