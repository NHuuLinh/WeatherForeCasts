
import UIKit
import MapKit

protocol MapsViewControllerDelegate: AnyObject {
    func didPickLocation(_ location: CLLocationCoordinate2D, address: String)
}

class MapsViewController: UIViewController,UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapsView: MKMapView!
    
    let geocoder = CLGeocoder()
    weak var delegate: MapsViewControllerDelegate?
    var selectedLocation: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        mapsView.showsUserLocation = true
        mapsView.delegate = self
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        mapsView.addGestureRecognizer(tapRecognizer)
        let userLocationButton = MKUserTrackingBarButtonItem(mapView: mapsView)
        self.navigationItem.rightBarButtonItem = userLocationButton
    }
    
    @objc func handleMapTap(_ sender: UITapGestureRecognizer) {
        let locationInView = sender.location(in: mapsView)
        let tappedCoordinate = mapsView.convert(locationInView, toCoordinateFrom: mapsView)
        // Cập nhật selectedLocation
        selectedLocation = tappedCoordinate
        // Thêm một pin vào bản đồ tại tọa độ được nhấn
        addPinToMapView(at: tappedCoordinate)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text {
            geocoder.geocodeAddressString(locationString) { [weak self] (placemarks, error) in
                if let error = error {
                    print("Geocode failed: \(error.localizedDescription)")
                } else if let placemarks = placemarks, let location = placemarks.first?.location {
                    self?.addPinToMapView(at: location.coordinate)
                    self?.zoomToLocation(at: location.coordinate)
                    // Cập nhật selectedLocation với tọa độ của điểm pin
                    self?.selectedLocation = location.coordinate
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
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapsView.setRegion(region, animated: true)
    }
    
    @IBAction func selectLocation(_ sender: Any) {
        if let selectedLocation = selectedLocation {
            print("Đã chọn điểm có tọa độ: Latitude \(selectedLocation.latitude), Longitude \(selectedLocation.longitude)")
            let location = CLLocation(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude)
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                if let placemark = placemarks?.first {
                    let province = placemark.administrativeArea ?? ""
                    let country = placemark.country ?? ""
                    let address = "\(province), \(country)"
                    print("Đã chọn địa điểm: \(address)")
                    self?.delegate?.didPickLocation(selectedLocation, address: address)
                }
            }
            navigationController?.popViewController(animated: true)
        }
    }

    
    @IBAction func currentLocation(_ sender: Any) {
        if let userLocation = mapsView.userLocation.location {
            zoomToLocation(at: userLocation.coordinate)
            addPinToMapView(at: userLocation.coordinate)
        }
    }
}

extension MapsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            selectedLocation = annotation.coordinate
        }
    }
}

