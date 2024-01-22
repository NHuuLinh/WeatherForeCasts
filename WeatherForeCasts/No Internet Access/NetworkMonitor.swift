import Foundation
import Network
import FirebaseAuth


class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var mainVC: MainViewController?
    var mainPresenter: MainPresenter?
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.mainVC?.handleNetworkStatusChange(isReachable: self?.isReachable ?? false)
            if path.status == .satisfied {
                print("We're connected!")
                print("isReachable: \(self?.isReachable)")
            } else {
                print("No connection.")
                print("isReachable: \(self?.isReachable)")
                if UserDefaults.standard.hasOnboarded {
                    if Auth.auth().currentUser != nil {
//                        AppDelegate.scene?.goToMain()
                    } else {
                        DispatchQueue.main.async {
                            AppDelegate.scene?.routeToNoInternetAccess()
                        }
                    }
                }  else {
                    DispatchQueue.main.async {
                        AppDelegate.scene?.routeToNoInternetAccess()
                    }
                }
            }
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
