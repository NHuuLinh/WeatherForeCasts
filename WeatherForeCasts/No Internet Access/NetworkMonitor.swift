import Foundation
import Network
import FirebaseAuth


class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    private let appCoordinator = AppCoordinator.shared

    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
//            self?.mainVC?.handleNetworkStatusChange(isReachable: self?.isReachable ?? false)
            if path.status == .satisfied {
                print("We're connected!")
                print("isReachable: \(self?.isReachable ?? false)")
            } else {
                print("No connection.")
                print("isReachable: \(self?.isReachable  ?? false)")
                if UserDefaults.standard.hasOnboarded {
                    if Auth.auth().currentUser != nil {
//                        AppDelegate.scene?.goToMain()
                    } else {
                        DispatchQueue.main.async {
                            self?.appCoordinator.routeToScene(.noInternet)
                        }
                    }
                }  else {
                    DispatchQueue.main.async {
                        self?.appCoordinator.routeToScene(.noInternet)
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
