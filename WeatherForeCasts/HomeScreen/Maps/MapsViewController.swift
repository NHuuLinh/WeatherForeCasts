
import UIKit
import MapKit

protocol MapsViewControllerDelegate:AnyObject {
    func checkLocationAuthorizationStatus()
}
//func didPickLocation(_ location: CLLocation, address: String)
//}

class MapsViewController: UIViewController,UISearchBarDelegate//, MapsViewControllerDelegate{
{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapsView: MKMapView!
    @IBOutlet weak var selectLocationBtn: UIButton!
    @IBOutlet weak var LocationsHistoryTableView: UITableView!
    @IBOutlet weak var LocationsHistoryTableViewHieght: NSLayoutConstraint!
    
    let geocoder = CLGeocoder()
    weak var delegate: MapsViewControllerDelegate?
    private var mainPresenter: MainPresenter?
    var selectedLocation: CLLocation?
    var selectedLocationHistory = UserDefaults.standard.stringArray(forKey: "searchHistory") ?? []
    private var sections = [Sections]()
    enum Sections:Int {
        case HistoryTitle = 0
        case LocationsHistory
    }
    override func viewDidAppear(_ animated: Bool) {
        translateLangue()
        searchBar.delegate = self
        mapsView.showsUserLocation = true
        mapsView.delegate = self
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        mapsView.addGestureRecognizer(tapRecognizer)
        let userLocationButton = MKUserTrackingBarButtonItem(mapView: mapsView)
        self.navigationItem.rightBarButtonItem = userLocationButton
        LocationsHistoryTableView.isHidden = true
        registerCell()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        mainPresenter = MainPresenterImpl(mapsVC: self)
    }
    func registerCell(){
        LocationsHistoryTableView.dataSource = self
        LocationsHistoryTableView.delegate = self
        let searchHistoryCell = UINib(nibName: "LocationHistoryTitleTableViewCell", bundle: nil)
        LocationsHistoryTableView.register(searchHistoryCell, forCellReuseIdentifier: "LocationHistoryTitleTableViewCell")
        let locationCell = UINib(nibName: "SelectedLocationsHistoryTableViewCell", bundle: nil)
        LocationsHistoryTableView.register(locationCell, forCellReuseIdentifier: "SelectedLocationsHistoryTableViewCell")
        tableViewHeight()
    }
    func tableViewHeight(){
        LocationsHistoryTableViewHieght.constant = CGFloat(40 + 30 * (selectedLocationHistory.count))
    }
    // xử lí khi người dùng click vào maps
    @objc func handleMapTap(_ sender: UITapGestureRecognizer) {
        LocationsHistoryTableView.isHidden = true

        // lấy tọa độ trên màn hinh
        let locationInView = sender.location(in: mapsView)
        // chuyển đổi tọa độ trên màn hình sang tọa độ bản đồ
        let tappedCoordinate = mapsView.convert(locationInView, toCoordinateFrom: mapsView)
        // Thêm một pin vào bản đồ tại tọa độ được nhấn
        addPinToMapView(at: tappedCoordinate)
        //chuyển đổi giá trị CLLocationCoordinate2D sang CLLocation
        let location = CLLocation(latitude: tappedCoordinate.latitude, longitude: tappedCoordinate.longitude)
        selectedLocation = location
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            if let error = error {
                print("fail handleMapTap \(error.localizedDescription) ")
            } else {
                if let placemarks = placemarks?.first {
                    self?.searchBar.text = placemarks.administrativeArea
                }
            }
        }
    }
    // xử lí khi người dùng thao tác với searchBar
    @objc func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        LocationsHistoryTableView.isHidden = false
    }
    @objc func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        LocationsHistoryTableView.isHidden = false

    }
    @objc func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        LocationsHistoryTableView.isHidden = true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //ẩn bàn phím
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text {
            getCoordinateFromString(location: locationString)
        }
    }
    func getCoordinateFromString(location: String?) {
        guard let location = location else { return  }
//        if let location != nil {
            geocoder.geocodeAddressString(location) { [weak self] (placemarks, error) in
                if let error = error {
                    print("Geocode failed: \(error.localizedDescription)")
                } else if let placemarks = placemarks, let location = placemarks.first?.location {
                    // thêm pin vào vị tọa độ được tìm kiếm
                    self?.addPinToMapView(at: location.coordinate)
                    // zoom vào vị tọa độ được tìm kiếm
                    self?.zoomToLocation(at: location.coordinate)
                    // Cập nhật selectedLocation với tọa độ của điểm pin
                    self?.selectedLocation = location
                }
            }
        }
    
    func addPinToMapView(at coordinate: CLLocationCoordinate2D) {
        // Xóa tất cả các điểm hiện có
        mapsView.removeAnnotations(mapsView.annotations)
        
        // Thêm điểm mới
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapsView.addAnnotation(annotation)
    }
    
    func zoomToLocation(at coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapsView.setRegion(region, animated: true)
    }
    func zoomToLocation1(at coordinate: CLLocation) {
//        let region =MK
        let region = MKCoordinateRegion(center: coordinate.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapsView.setRegion(region, animated: true)
    }
    func selecLoacations(){
        if let selectedLocation = selectedLocation {
            geocoder.reverseGeocodeLocation(selectedLocation) { [weak self] (placemarks, error) in
                if let error = error {
                    print("lỗi khi lựa chọn địa điểm \(error.localizedDescription)")
                    let warningTitle = NSLocalizedString("Warning", comment: "")
                    let warningMessage = NSLocalizedString("Please select a location", comment: "")
                    self?.showAlert(title: warningTitle, message: warningMessage)
                }
                // lấy địa điểm để truyền sang main
                if let placemark = placemarks?.first {
                    let province = placemark.administrativeArea ?? ""
                    let country = placemark.country ?? ""
                    let address = "\(province), \(country)"
                    print("province:\(province)")

                    DispatchQueue.main.async {
                        //tìm giá trị trong index, nếu có thì xóa nó đi
                        if let index = self?.selectedLocationHistory.firstIndex(of: province) {
                            self?.selectedLocationHistory.remove(at: index)
                        }
                        // chèn giá trị vào vị trí đầu sau khi xóa
                        self?.selectedLocationHistory.insert(province, at: 0)
                        // câp nhật UserDefault
                        UserDefaults.standard.set(self?.selectedLocationHistory, forKey: "searchHistory")
                        // cập nhật lại chiều cao do mới thêm giá trị vào mảng
                        self?.tableViewHeight()
                        self?.LocationsHistoryTableView.reloadData()
                    }
                    if !province.isEmpty {
                        UserDefaults.standard.set(selectedLocation.coordinate.latitude, forKey: "locationLatitude")
                        UserDefaults.standard.set(selectedLocation.coordinate.longitude, forKey: "locationLongitude")
                        UserDefaults.standard.set(address, forKey: "locationAddress")
                        self?.delegate?.checkLocationAuthorizationStatus()
//                        self?.mainPresenter?.fetchWeatherData()
                        print("self?.mapsDelegate?.fetchWeatherData()")
                        self?.navigationController?.popViewController(animated: true)
                    } else {
                        let warningTitle = NSLocalizedString("Warning", comment: "")
                        let warningMessage = NSLocalizedString("Please select a different location", comment: "")
                        self?.showAlert(title: warningTitle, message: warningMessage)
                    }
                }
            }
        }
    }
    
    @IBAction func selectLocation(_ sender: Any) {
//        guard let mainPresenter = mainPresenter else {
//            print("mainPresenter is nil")
//            return
//        }
//
//        mainPresenter.test()
////
        selecLoacations()
        print("selectLocationBtn: \(selectedLocationHistory.count)")
        LocationsHistoryTableView.reloadData()
    }

    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func currentLocation(_ sender: Any) {
        if let userLocation = mapsView.userLocation.location {
            zoomToLocation(at: userLocation.coordinate)
            addPinToMapView(at: userLocation.coordinate)
            self.selectedLocation = userLocation
        }
    }
}

extension MapsViewController: MKMapViewDelegate {
    // xử lí nếu người dùng nhấn vào pin
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            zoomToLocation(at: annotation.coordinate)
        } else {
            print("lỗi zoomToLocation khi người dùng nhấn vào pin ")
        }
    }
}
extension MapsViewController {
    func translateLangue(){
        selectLocationBtn.setTitle(NSLocalizedString("Select Location", comment: ""), for: .normal)
    }
}
extension MapsViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let mapsSection = Sections(rawValue: section)
        switch mapsSection {
        case .HistoryTitle:
            return 1
        case .LocationsHistory:
            return selectedLocationHistory.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mapsSection = Sections(rawValue: indexPath.section)
        switch mapsSection {
        case .HistoryTitle :
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationHistoryTitleTableViewCell", for: indexPath) as! LocationHistoryTitleTableViewCell
            cell.onDataUpdate = { [weak self] in
                UserDefaults.standard.removeObject(forKey: "searchHistory")
                self?.selectedLocationHistory = []
                self?.tableViewHeight()
                self?.LocationsHistoryTableView.reloadData()
            }
            return cell
        case .LocationsHistory:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedLocationsHistoryTableViewCell", for: indexPath) as! SelectedLocationsHistoryTableViewCell
            cell.getHistoryLocation(with: selectedLocationHistory[indexPath.row])
//            self.LocationsHistoryTableView.reloadData()
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapsSection = Sections(rawValue: indexPath.section)
        switch mapsSection {
        case .HistoryTitle :
            return
        case .LocationsHistory:
            print("\(indexPath.row)")
            let historyLocation = selectedLocationHistory[indexPath.row]
            self.searchBar.text = historyLocation
            getCoordinateFromString(location: historyLocation)
        default:
            return
        }
    }
}

