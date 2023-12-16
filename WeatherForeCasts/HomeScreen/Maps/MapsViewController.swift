
import UIKit
import MapKit

protocol MapsViewControllerDelegate: AnyObject {
    func didPickLocation(_ location: CLLocation, address: String)
}

class MapsViewController: UIViewController,UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapsView: MKMapView!
    @IBOutlet weak var selectLocationBtn: UIButton!
    
    let geocoder = CLGeocoder()
    weak var delegate: MapsViewControllerDelegate?
//    var selectedLocation: CLLocationCoordinate2D?CLLocation
    var selectedLocation: CLLocation?


    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        mapsView.showsUserLocation = true
        mapsView.delegate = self
        translateLangue()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        mapsView.addGestureRecognizer(tapRecognizer)
        let userLocationButton = MKUserTrackingBarButtonItem(mapView: mapsView)
        self.navigationItem.rightBarButtonItem = userLocationButton
    }
    // xử lí khi người dùng click vào maps
    @objc func handleMapTap(_ sender: UITapGestureRecognizer) {
        // lấy tọa độ trên màn hinh
        let locationInView = sender.location(in: mapsView)
        print("tọa độ trên màn hình : \(locationInView)")
        // chuyển đổi tọa độ trên màn hình sang tọa độ bản đồ
        let tappedCoordinate = mapsView.convert(locationInView, toCoordinateFrom: mapsView)
        print("tọa độ trên bản đồ : \(tappedCoordinate)")
        // Cập nhật selectedLocation
//        selectedLocation = tappedCoordinate
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
                    print("huyện : \(placemarks.administrativeArea)")
                    print("Quốc gia :\(placemarks.country)")
                }
            }
        }
    }
    // xử lí khi người dùng thao tác với searchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text {
            geocoder.geocodeAddressString(locationString) { [weak self] (placemarks, error) in
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
//        let region =MK
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
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
                    print("Đã chọn địa điểm: \(address)")
                    if !province.isEmpty {
                        self?.delegate?.didPickLocation(selectedLocation, address: address)
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
        selecLoacations()
    }

    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func currentLocation(_ sender: Any) {
        if let userLocation = mapsView.userLocation.location {
            zoomToLocation(at: userLocation.coordinate)
            addPinToMapView(at: userLocation.coordinate)
        }
    }
}

extension MapsViewController: MKMapViewDelegate {
    // xử lí nếu người dùng nhấn vào pin
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            selectedLocation = annotation as? CLLocation
            zoomToLocation(at: selectedLocation?.coordinate ?? mapsView.userLocation.coordinate)
        }
    }
}
extension MapsViewController {
    func translateLangue(){
        selectLocationBtn.setTitle(NSLocalizedString("Select Location", comment: ""), for: .normal)
    }
}

