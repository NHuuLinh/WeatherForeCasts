////
////  MainPresenter.swift
////  WeatherForeCasts
////
////  Created by LinhMAC on 27/12/2023.
////
//
//import Foundation
//protocol MainPresenter {
//
//}
//class MainPresenterImpl: MainPresenter{
//    var mainVC: MainViewController
//    init(mainVC: MainViewController) {
//        self.mainVC = mainVC
//    }
//    private func fetchWeatherDataForCurrentLocation() {
//        // Bắt đầu hẹn giờ 20 giây
//        loadingTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(handleLoadingTimeout), userInfo: nil, repeats: false)
//        showLoading(isShow: true)
//        // check xem có đia điểm hiện tại không,nếu không thì không làm gì cả
//        guard let currentLocation = locationManager.location else {
//            print("Current location not available.")
//            handleLoadingError()
//            return
//        }
//        let geocoder = CLGeocoder()
//        // lấy placemark
//        geocoder.reverseGeocodeLocation(currentLocation) { [weak self] (placemarks, error) in
//            if let error = error {
//                print("Reverse geocoding failed: \(error.localizedDescription)")
//                self?.handleLoadingError()
//                return
//            }
//
//            // lấy tên thành phố, đất nước
//            if let placemark = placemarks?.first {
//                let province = placemark.administrativeArea ?? ""
//                let country = placemark.country ?? ""
//                let address = "\(province), \(country)"
//                print("Đã chọn địa điểm: \(address)")
//                self?.locationNameLb.text = address
//                UserDefaults.standard.set(address, forKey: "locationAddress")
//                UserDefaults.standard.set(currentLocation.coordinate.latitude, forKey: "locationLatitude")
//                UserDefaults.standard.set(currentLocation.coordinate.longitude, forKey: "locationLongitude")
//                print("currentLocation.coordinate.latitude: \(currentLocation.coordinate.latitude)")
//                print("currentLocation.coordinate.longitude: \(currentLocation.coordinate.longitude)")
//
//                // Fetch weather data using the current location
//                WeatherAPIManager.shared.fetchWeatherData(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude) { [weak self] weatherData in
//                    //đảm bảo rằng self vẫn tồn tại trước khi sử dụng nó bên trong closure
//                    guard let self = self else { return }
//
//                    // Hủy hẹn giờ vì đã có dữ liệu
//                    self.loadingTimer?.invalidate()
//                    self.loadingTimer = nil
//                    // chạy các tác vụ ưu tiên trên luồng chính, tránh lag  giao diện
//                    DispatchQueue.main.async {
//                        guard let weatherData = weatherData else {
//                            print("Failed to fetch weather data")
//                            self.handleLoadingError()
//                            return
//                        }
//                        DispatchQueue.main.async {
//                            self.weatherData = weatherData
//                            self.mainTableView.reloadData()
//                        }
//                        self.isDataLoaded = true
//                        self.showLoading(isShow: false)
//                    }
//                }
//            }
//        }
//    }
//
//}
