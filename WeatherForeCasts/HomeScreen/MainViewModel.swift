//
//  MainViewModel.swift
//  WeatherForeCasts
//
//  Created by Huu Linh Nguyen on 2/7/26.
//

import Foundation
import Combine
import CoreLocation
import FirebaseAuth

class MainViewModel: NSObject {
    // MARK: - Output
    @Published var weatherData: WeatherData24h?
    @Published var locationName: String?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var shouldShowNoInternet = false

    // MARK: - Private
    private let service = WeatherAPIManager.shared
    private let locationManager = CLLocationManager()
    private let networkMonitor = NetworkMonitor.shared
    private var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }

    // MARK: - Location Authorization
    func checkLocationAuthorizationStatus() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            errorMessage = "Please allow to use location"
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            chooseDataToFetch()
        @unknown default:
            break
        }
    }

    func requestLocation() {
        DispatchQueue.global().async { [weak self] in
            guard CLLocationManager.locationServicesEnabled() else { return }
            self?.locationManager.startUpdatingLocation()
        }
    }

    // MARK: - Data Loading
    func chooseDataToFetch() {
        shouldShowNoInternet = !networkMonitor.isReachable

        if !networkMonitor.isReachable {
            if UserDefaults.standard.didGetData {
                loadFromCoreData()
            }
            return
        }

        if UserDefaults.standard.didOnMain {
            fetchSavedLocation()
        } else {
            fetchCurrentLocation()
        }
    }

    func fetchCurrentLocation() {
        guard let location = locationManager.location else {
            print("Current location not available")
            return
        }
        isLoading = true

        service.fetchLocation(latitude: location.coordinate.latitude,
                              longitude: location.coordinate.longitude)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] weatherData, address in
                guard let self = self else { return }
                self.weatherData = weatherData
                self.locationName = address
                CoreDataHelper.share.saveWeatherData(weatherData)
                CoreDataHelper.share.saveLocationValueToCoreData(
                    address: address,
                    longitude: location.coordinate.longitude,
                    latitude: location.coordinate.latitude
                )
                UserDefaults.standard.didOnMain = true
            }
            .store(in: &cancellables)
    }

    func fetchSavedLocation() {
        let latitude = CoreDataHelper.share.getLocationValueFromCoreData(key: "latitude") as? Double ?? 0
        let longitude = CoreDataHelper.share.getLocationValueFromCoreData(key: "longitude") as? Double ?? 0
        let address = CoreDataHelper.share.getLocationValueFromCoreData(key: "address") as? String ?? ""
        isLoading = true

        service.fetchWeatherData(latitude: latitude, longitude: longitude)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] weatherData in
                guard let self = self else { return }
                self.weatherData = weatherData
                self.locationName = address
                CoreDataHelper.share.saveWeatherData(weatherData)
            }
            .store(in: &cancellables)
    }

    private func loadFromCoreData() {
        guard let weatherData = CoreDataHelper.share.fetchWeatherData() else { return }
        let address = CoreDataHelper.share.getLocationValueFromCoreData(key: "address") as? String ?? ""
        self.weatherData = weatherData
        self.locationName = address
    }

    // MARK: - Button Handlers
    func currentLocationBtnHandle() {
        guard networkMonitor.isReachable else {
            errorMessage = "No internet connection"
            return
        }
        requestLocation()
        fetchCurrentLocation()
    }

    func mapBtnHandle() -> Bool {
        guard networkMonitor.isReachable else {
            errorMessage = "No internet connection"
            return false
        }
        return true
    }

    func logoutHandle() {
        do {
            try Auth.auth().signOut()
            CoreDataHelper.share.deleteProfileValue()
            CoreDataHelper.share.deleteWeatherValue()
            CoreDataHelper.share.deleteLocationValue()
            CoreDataHelper.share.saveValue()
            UserDefaults.standard.didOnMain = false

            if networkMonitor.isReachable {
                AppCoordinator.shared.routeToScene(.login)
            } else {
                AppCoordinator.shared.routeToScene(.noInternet)
            }
        } catch {
            print("Error signing out: \(error)")
        }
    }

    // MARK: - Update from Maps
    func updateLocation(latitude: Double, longitude: Double, address: String) {
        isLoading = true
        service.fetchWeatherData(latitude: latitude, longitude: longitude)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] weatherData in
                guard let self = self else { return }
                self.weatherData = weatherData
                self.locationName = address
                CoreDataHelper.share.saveWeatherData(weatherData)
            }
            .store(in: &cancellables)
    }
}

// MARK: - CLLocationManagerDelegate
extension MainViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorizationStatus()
    }
}
